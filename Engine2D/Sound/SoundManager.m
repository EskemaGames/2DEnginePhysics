//
//  SoundManager.m
//  
//
//  Idea from Michael Daley.
//	Created by Eskema
//  Copyright 2009 Eskema. All rights reserved.
//

#import "SoundManager.h"
#import "MyOpenALSupport.h"


#pragma mark -
#pragma mark Private interface

@interface SoundManager (Private)

// This method is used to initialize OpenAL.  It gets the default device, creates a new context 
// to be used and then preloads the define # sources.  This preloading means we wil be able to play up to
// (max 32) different sounds at the same time
- (BOOL)initOpenAL;

// This method is used to initialize OpenAL.  It gets the default device, creates a new context 
// to be used and then preloads the define # sources.  This preloading means we wil be able to play up to
// (max 32) different sounds at the same time
- (NSUInteger)nextAvailableSource;

// Opens as audiofile from the file path which is provided and returns an |AudioFileID|.
- (AudioFileID)openAudioFile:(NSString*)theFilePath;

// Returns the size of sound data within the file speicified by |fileDescriptor|.
- (UInt32)audioFileSize:(AudioFileID)fileDescriptor;

@end


#pragma mark -
#pragma mark Public implementation

@implementation SoundManager

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(SoundManager);

// Method which handles an interruption message from the audio session.  It reacts to the
// type of interruption state i.e. beginInterruption or endInterruption
void interruptionListener(	void *	inClientData,
                          UInt32	inInterruptionState) {
    
	SoundManager *SELF = [SoundManager sharedSoundManager];
    
    if (inInterruptionState == kAudioSessionBeginInterruption) {
        [SELF setActivated:NO];
	} else if (inInterruptionState == kAudioSessionEndInterruption) {
        [SELF setActivated:YES];
	}
}


- (void)dealloc {
	// Loop through the OpenAL sources and delete them
	for(NSNumber *sourceIDVal in _soundSources) {
		NSUInteger sourceID = [sourceIDVal unsignedIntValue];
		alDeleteSources(1, &sourceID);
	}
	
	// Loop through the OpenAL buffers and delete 
	NSEnumerator *enumerator = [_soundLibrary keyEnumerator];
	id key;
	while ((key = [enumerator nextObject])) {
		NSNumber *bufferIDVal = [_soundLibrary objectForKey:key];
		NSUInteger bufferID = [bufferIDVal unsignedIntValue];
		alDeleteBuffers(1, &bufferID);		
	}
    
	// Release the arrays and dictionaries we have been using
	[_soundLibrary release];
	[_soundSources release];

	

	// Disable and then destroy the context
	alcMakeContextCurrent(NULL);
	alcDestroyContext(_context);
	
	// Close the device
	alcCloseDevice(_device);
	
	[super dealloc];
}


-(void) CheckIfOtherAudioIsPlaying
{
	UInt32		propertySize, audioIsAlreadyPlaying;
	
	// do not open the track if the audio hardware is already in use (could be the iPod app playing music)
	propertySize = sizeof(UInt32);
	AudioSessionInitialize(NULL,NULL,interruptionListener, self);
	
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &audioIsAlreadyPlaying);
	if (audioIsAlreadyPlaying != 0)
	{
		gOtherAudioIsPlaying = YES;
		UInt32	sessionCategory = kAudioSessionCategory_AmbientSound;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
		AudioSessionSetActive(YES);
	}
	else
	{
		
		gOtherAudioIsPlaying = NO;
		
		// since no other audio is *supposedly* playing, then we will make darn sure by changing the audio session category temporarily
		// to kick any system remnants out of hardware (iTunes (or the iPod App, or whatever you wanna call it) sticks around)
		UInt32	sessionCategory = kAudioSessionCategory_MediaPlayback;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
		AudioSessionSetActive(YES);
		
		// now change back to ambient session category so our app honors the "silent switch"
		sessionCategory = kAudioSessionCategory_AmbientSound;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
	}
}



- (id)init {
	if(self = [super init]) {

		// Register to be notified of both the UIApplicationWillResignActive and UIApplicationDidBecomeActive.
		// Set up notifications that will let us know if the application resigns being active or becomes active
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) 
                                                     name:@"UIApplicationWillResignActiveNotification" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) 
                                                     name:@"UIApplicationDidBecomeActiveNotification" object:nil];
		
        // Initialize the array and dictionaries we are going to use
		_soundSources = [[NSMutableArray alloc] init];
		_soundLibrary = [[NSMutableDictionary alloc] init];
		
		
		[self CheckIfOtherAudioIsPlaying];

		
        // Set up the OpenAL.  If an error occurs then NO will be returned.
		BOOL success = [self initOpenAL];
		if(!success) return nil;
		
		// Set up the listener position
		ALfloat listener_pos[] = {0, 0, 0};
		ALfloat listener_ori[] = {0.0, 1.0, 0.0, 0.0, 0.0, 1.0}; //for stereo sounds
		ALfloat listener_vel[] = {0, 0, 0};
		
		alListenerfv(AL_POSITION, listener_pos);
		alListenerfv(AL_ORIENTATION, listener_ori);
		alListenerfv(AL_VELOCITY, listener_vel);
        
        // Set the default volume for music and sound FX
		_FXVolume = 1.0f;

		return self;
	}
	[self release];
	return nil;
}








- (void)shutdownSoundManager {
	@synchronized(self) {
		if(sharedSoundManager != nil) {
			[self dealloc];
		}
	}
}


- (void)loadSoundWithKey:(NSString*)aSoundKey fileName:(NSString*)aFileName 
                 fileExt:(NSString*)aFileExt
{
	
	// Check to make sure that a sound with the same key does not already exist
    NSNumber *numVal = [_soundLibrary objectForKey:aSoundKey];
    
    // If the key is not found return 
    if(numVal != nil) {
        return;
    }
	
	
	NSUInteger bufferID;
	
	// Generate a buffer within OpenAL for this sound
	alGenBuffers(1, &bufferID);
    
    // Set up the variables which are going to be used to hold the format
    // size and frequency of the sound file we are loading
	ALenum  error = AL_NO_ERROR;
	ALenum  format;
	ALsizei size;
	ALsizei freq;
	ALvoid *data;
    
	NSBundle *bundle = [NSBundle mainBundle];
	
	// Get the audio data from the file which has been passed in
	CFURLRef fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:aFileName ofType:aFileExt]] retain];
	
	if (fileURL)
	{	
		data = MyGetOpenALAudioData(fileURL, &size, &format, &freq);
		CFRelease(fileURL);
		
		if(error  != AL_NO_ERROR) {
			//NSLog(@"ERROR - SoundManager: Error loading sound: %x\n", error);
			exit(1);
		}
		
		// Use the static buffer data API
		alBufferDataStaticProc(bufferID, format, data, size, freq);
		
		if(error  != AL_NO_ERROR) {
			NSLog(@"ERROR - SoundManager: Error attaching audio to buffer: %x\n", error);
		}		
	}
	else
	{
		NSLog(@"ERROR - SoundManager: Could not find file '%@.%@'", aFileName, aFileExt);
		data = NULL;
	}
	
	// Place the buffer ID into the sound library against |aSoundKey|
	[_soundLibrary setObject:[NSNumber numberWithUnsignedInt:bufferID] forKey:aSoundKey];
	

	
}





- (void)removeSoundWithKey:(NSString*)aSoundKey {
	
    // Find the buffer which has been linked to the sound key provided
    NSNumber *numVal = [_soundLibrary objectForKey:aSoundKey];
    
    // If the key is not found finish
    if(numVal == nil) {
        return;
    }
    
    // Get the buffer number form the sound library so that the sound buffer can be released
    NSUInteger bufferID = [numVal unsignedIntValue];
	alDeleteBuffers(1, &bufferID);
    [_soundLibrary removeObjectForKey:aSoundKey];
    
}




- (NSUInteger)playSoundWithKey:(NSString*)aSoundKey gain:(ALfloat)aGain pitch:(ALfloat)aPitch location:(Vector2f)aLocation shouldLoop:(BOOL)aLoop {
	
	_err = alGetError(); // clear the error code
	
	// Find the buffer linked to the key which has been passed in
	NSNumber *numVal = [_soundLibrary objectForKey:aSoundKey];
	if(numVal == nil) return 0;
	NSUInteger bufferID = [numVal unsignedIntValue];
	
	// Find an available source i.e. it is currently not playing anything
	NSUInteger sourceID = [self nextAvailableSource];
	
	// Make sure that the source is clean by resetting the buffer assigned to the source
	// to 0
	alSourcei(sourceID, AL_BUFFER, 0);
	//Attach the buffer we have looked up to the source we have just found
	alSourcei(sourceID, AL_BUFFER, bufferID);
	
	// Set the pitch and gain of the source
	alSourcef(sourceID, AL_PITCH, aPitch);
	alSourcef(sourceID, AL_GAIN, aGain * _FXVolume);
	
	// Set the looping value
	if(aLoop) {
		alSourcei(sourceID, AL_LOOPING, AL_TRUE);
	} else {
		alSourcei(sourceID, AL_LOOPING, AL_FALSE);
	}
   
	// Set the source location
	alSource3f(sourceID, AL_POSITION, aLocation.x, aLocation.y, 0.0f);
	
	// Check to see if there were any errors
	_err = alGetError();
	if(_err != 0) 
	{
		return 0;
	}
	 
	
	// Now play the sound
	alSourcePlay(sourceID);
	
	
	// Return the source ID so that loops can be stopped etc
	return sourceID;
	
}






- (void)stopSoundWithKey:(NSString*)theSoundKey {

	// Get the buffer ID for the sound key
	NSNumber *numVal = [_soundLibrary objectForKey:theSoundKey];
	if(numVal == nil) return;
	NSUInteger bufferID = [numVal unsignedIntValue];
	
	// Loop through the OpenAL sources and stop them
	// if it is using the wanted buffer.
	for(NSNumber *sourceIDVal in _soundSources) {
		
		NSUInteger sourceID = [sourceIDVal unsignedIntValue];
		
		NSInteger bufferForSource;
		alGetSourcei(sourceID, AL_BUFFER, &bufferForSource);
		
		if (bufferForSource == bufferID) {
			
			alSourceStop( sourceID );
			alSourcei( sourceID, AL_BUFFER, 0);
			
		}
		
	}
	
	// Remove the object from the sound library
	[_soundLibrary removeObjectForKey:theSoundKey];
	
}


-(void) UnloadSounds
{
// Release the arrays and dictionaries we have been using
[_soundLibrary release];
[_soundSources release];
}



//change if you want to add any other format than MP3
-(void) LoadMusic:(NSString *)filemusic   Volume:(float)Volume
{
	NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:filemusic ofType:@"mp3"]]; 
	_musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
	_musicPlayer.volume = Volume; 
	_musicPlayer.numberOfLoops = -1;
}



-(void) PlayMusic
{
	//check if ipod is playing, dont play our music
	if (gOtherAudioIsPlaying == NO)
	[_musicPlayer play];	
}


-(void) PauseMusic
{
	[_musicPlayer pause];
}


-(void) UnLoadMusic
{
	[_musicPlayer release];
}


-(void) StopMusic
{
	if (gOtherAudioIsPlaying == NO)
	[_musicPlayer stop];
}


-(BOOL) GetPlayerPlaying
{
	if (_musicPlayer.playing == YES)
		return YES;
	
	return NO;
}

-(void) SetVolume:(float)Volume
{
	_musicPlayer.volume = Volume;
}




- (void) setListenerPosition:(Vector2f)aPosition {
	_listenerPosition = aPosition;
	alListener3f(AL_POSITION, aPosition.x, aPosition.y, 0.0f);
}


- (void)setOrientation:(Vector2f)aPosition {
    ALfloat orientation[] = {aPosition.x, aPosition.y, 0.0f, 0.0f, 0.0f, 1.0f};
    alListenerfv(AL_ORIENTATION, orientation);
}


- (void)setFXVolume:(ALfloat)aVolume {
	_FXVolume = aVolume;
}


- (void)applicationWillResignActive:(NSNotification *)notification
{
	//after deactive, pause music
    [self setActivated:NO];
	[_musicPlayer pause];
}


- (void)applicationDidBecomeActive:(NSNotification *)notification
{
	//now after the call, reactivate the music
    [self setActivated:YES];
	[_musicPlayer play];
}


- (void)setActivated:(BOOL)aState {
    
    if(aState) {
		
		UInt32 category = kAudioSessionCategory_AmbientSound;
		AudioSessionSetProperty ( kAudioSessionProperty_AudioCategory, sizeof (category), &category );
		
		// Reactivate the current audio session
		AudioSessionSetActive(YES);

		ALenum err = alGetError();
		if (err != 0) 
			return; 

		// Bind and start the current context
        alcMakeContextCurrent(_context);
        alcProcessContext(_context);
    } else {
        
		// Set the audio session state to false (NO)
		AudioSessionSetActive(NO);

		ALenum err = alGetError();
		if (err != 0) 
			return; 

        // Unbind the current context and suspend it
        alcMakeContextCurrent(NULL);
        alcSuspendContext(_context);
    }
}
@end


#pragma mark -
#pragma mark Private implementation

@implementation SoundManager (Private)

// Define the number of sources which will be created.  iPhone can have a max of 32
#define OPENAL_SOURCES 16
#define REFERENCE_DISTNACE 100.0f
- (BOOL) initOpenAL {
	// Get the device we are going to use for sound.  Using NULL gets the default device
	_device = alcOpenDevice(NULL);
	
	// If a device has been found we then need to create a context, make it current and then
	// preload the OpenAL Sources
	if(_device) {
		// Use the device we have now got to create a context "air"
		_context = alcCreateContext(_device, NULL);
		// Make the context we have just created into the active context
		alcMakeContextCurrent(_context);
		// Pre-create 16 sound sources which can be dynamically allocated to buffers (sounds)
		NSUInteger sourceID_;
		for(int index = 0; index < OPENAL_SOURCES; index++) {
			// Generate an OpenAL source
			alGenSources(1, &sourceID_);
            alSourcef(sourceID_, AL_REFERENCE_DISTANCE, REFERENCE_DISTNACE);
			// Add the generated sourceID to our array of sound sources
			[_soundSources addObject:[NSNumber numberWithUnsignedInt:sourceID_]];
		}
        
		// Return YES as we have successfully initialized OpenAL
		return YES;
	}

	// We were unable to obtain a device for playing sound so tell the user and return NO.
	return NO;
}


- (NSUInteger) nextAvailableSource {
	
	// Holder for the current state of the current source
	NSInteger sourceState;
	
	// Find a source which is not being used at the moment
	for(NSNumber *sourceNumber in _soundSources) {
		alGetSourcei([sourceNumber unsignedIntValue], AL_SOURCE_STATE, &sourceState);
		// If this source is not playing then return it
		if(sourceState != AL_PLAYING) return [sourceNumber unsignedIntValue];
	}
	
	// If all the sources are being used we look for the first non looping source
	// and use the source associated with that
	NSInteger looping;
	for(NSNumber *sourceNumber in _soundSources) {
		alGetSourcei([sourceNumber unsignedIntValue], AL_LOOPING, &looping);
		if(!looping) {
			// We have found a none looping source so return this source and stop checking
			NSUInteger sourceID = [sourceNumber unsignedIntValue];
			alSourceStop(sourceID);
			return sourceID;
		}
	}
	
	// If there are no looping sources to be found then just use the first sounrce and use that
	NSUInteger sourceID = [[_soundSources objectAtIndex:0] unsignedIntegerValue];
	alSourceStop(sourceID);
	return sourceID;
}


- (AudioFileID) openAudioFile:(NSString*)theFilePath {
	
	AudioFileID outAFID;
	// Create an NSURL which will be used to load the file.  This is slightly easier
	// than using a CFURLRef
	NSURL *afUrl = [NSURL fileURLWithPath:theFilePath];
	
	// Open the audio file provided
	OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, kAudioFileReadPermission, 0, &outAFID);
	
	// If we get a result that is not 0 then something has gone wrong.  We report it and 
	// return the out audio file id.
	if(result != 0)
		NSLog(@"ERROR SoundEngine: Cannot open file: %@", theFilePath);
	
	return outAFID;
}


- (UInt32) audioFileSize:(AudioFileID)fileDescriptor {
    
	UInt64 outDataSize = 0;
    
    // |thePropSize| will stores the size of an unsigned 64bit integer which is the size of the
    // property we are going to query i.e. |kAudioFilePropertyAudioDataByteCount|.
	UInt32 thePropSize = sizeof(UInt64);
    
    // Get the |kAudioFilePropertyAudioDataByteCount| property from the audio file.
	OSStatus result = AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, 
                                           &thePropSize, &outDataSize);

    // If the result is not 0 then there was a problem so put a message in the log
	if(result != 0)	
		NSLog(@"ERROR SoundManager: Cannot get file size");
	
    // Return the data size which will be zero if an error occured.
	return (UInt32)outDataSize;
}


@end

