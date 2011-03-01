//
//  SoundManager.h
//  
//
//  Idea from Michael Daley .
//  Created by Eskema 2009
//  Copyright 2009 Eskema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "CommonEngine.h"
#import "SynthesizeSingleton.h"



// SoundManager provides a basic wrapper for OpenAL and AVAudioPlayer.  It is a singleton
// class that allows sound clips to be loaded and cached with a key and then played back
// using that key.  It also allows for music tracks to be played, stopped and paused
//


@interface SoundManager : NSObject {

@public
	BOOL gOtherAudioIsPlaying;
	
 @private
	ALCcontext *_context;
	ALCdevice *_device;
	NSMutableArray *_soundSources;
	NSMutableDictionary *_soundLibrary;
	AVAudioPlayer *_musicPlayer;
	Vector2f _listenerPosition;
	float _FXVolume;
    ALenum _err;
	

}

// Returns as instance of the SoundManager class.  If an instance has already been created
// then this instance is returned, otherwise a new instance is created and returned.
+ (SoundManager *)sharedSoundManager;


//check if ipod is playing music, if so, disable the music ingame
//but not the sounds
-(void) CheckIfOtherAudioIsPlaying;

// Designated initializer.
- (id)init;




// Plays the sound which is found with |aSoundKey| using the provided |aGain| and |aPitch|.
// |aLocation| is used to set the location of the sound source in relation to the listener
// and |aLoop| specifies if the sound should be continuously looped or not.
- (NSUInteger) playSoundWithKey:(NSString*)aSoundKey gain:(ALfloat)aGain pitch:(ALfloat)aPitch 
                       location:(Vector2f)aLocation shouldLoop:(BOOL)aLoop;

// Loads a sound with the supplied key, filename, file extension and frequency.  Frequenct
// Could be worked out from the file but this implementation takes it as an argument. If no
// sound is found with a matching key then nothing happens.
- (void)loadSoundWithKey:(NSString*)aSoundKey fileName:(NSString*)aFileName 
                 fileExt:(NSString*)aFileExt;

- (void)removeSoundWithKey:(NSString*)aSoundKey;
- (void)stopSoundWithKey:(NSString*)theSoundKey;
- (void) UnloadSounds;


//modified to work without that crap of nsdictionary 
- (void) LoadMusic:(NSString *)filemusic   Volume:(float)Volume;
- (void) PlayMusic;
- (void) PauseMusic;
- (void) UnLoadMusic;
- (void) StopMusic;
- (BOOL) GetPlayerPlaying;
- (void) SetVolume:(float)Volume;


// Shutsdown the SoundManager class and deallocates resources which have been assigned.
- (void)shutdownSoundManager;

// Stop/Start OpenAL
- (void)setActivated:(BOOL)aState;

#pragma mark -
#pragma mark Getters/Setters



// Sets the location of the OpenAL listener.
- (void)setListenerPosition:(Vector2f)aPosition;

- (void)setOrientation:(Vector2f)aPosition;

// Sets the volume for all sounds which are played.  This acts as a global FX volume for
// all sounds.
- (void)setFXVolume:(ALfloat)aVolume;

@end
