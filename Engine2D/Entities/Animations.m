
#import "Animations.h"


@implementation Animations


@synthesize frame;
@synthesize frametoDisplay;
@synthesize step;
@synthesize delay;
@synthesize EndAnimation;
@synthesize AnimationActive;

- (id) init 
{  
    self = [super init];  
	delay = 0;
	step = 0;
	frame = 0;
	frametoDisplay = 0;
	EndAnimation = NO;
	AnimationActive = NO;
	//create a sprite array to hold all the animations and states
	//init only half array, the other part will be initiated
	//when you parse the xml file with the proper size
	SpriteFrames = (_AnimationSprite **)malloc(_TOTALSTATES * sizeof(_AnimationSprite *));
	
    return self;  
}



// release resources when they are no longer needed.
- (void)dealloc
{	
	//free the sprites
	free(SpriteFrames);
	[super dealloc];
}


//init the array with the proper size to hold the frames for this animation state
-(void)InitArray:(state)states Number:(int)num
{
	//alloc size for this animation
	SpriteFrames[states] = (_AnimationSprite *)malloc(num * sizeof(_AnimationSprite));
}



//this is the "core" of this class, we load each animation per separately
//we have the same animations as states, so if the player/enemy/whatever has 3 states
//we normally load 3 animations, one per state
///load our animation based in states and number of frames
-(void) LoadAnimation:(state)states AnimationValues:(CGRect)Animationvalues 
				Speed:(int)speed 
		frames_number:(int)frames_number  
		 EndAnimation:(int)endAnimation 
			CachedNum:(int)cachedNum
			  OffsetX:(int)offsetx
			  OffsetY:(int)offsety
		LoopAnimation:(bool)loopAnimation
{	
	//size and position on the spritesheet of this sprite frame
	SpriteFrames[states][frames_number].speed = speed;
	SpriteFrames[states][frames_number].posX = Animationvalues.origin.x;
	SpriteFrames[states][frames_number].posY = Animationvalues.origin.y;
	SpriteFrames[states][frames_number].w = Animationvalues.size.width;
	SpriteFrames[states][frames_number].h = Animationvalues.size.height;
	SpriteFrames[states][frames_number].offsetX = offsetx;
	SpriteFrames[states][frames_number].offsetY = offsety;
	SpriteFrames[states][frames_number].loopAnimation = loopAnimation;
	if (endAnimation != -1)
		SpriteFrames[states][frames_number].frame = frames_number;
	else {
		SpriteFrames[states][frames_number].frame = END_ANIMATION;
	}
	
	SpriteFrames[states][frames_number].cachedFrameNum = cachedNum;
}





//increase our frame animation, setting the delay we want
-(int) NextAnimationFrame
{
	
	if (delay < 0) //if delay < 0, change to next frame and reset delay counter
	{
		step ++;
		frame = SpriteFrames[status][step].frame;
		delay = SpriteFrames[status][step].speed;  //reset delay counter to value asigned
		
		//check the end of animation
		if (frame == END_ANIMATION)
		{
			//the animation will loop?
			if (!SpriteFrames[status][0].loopAnimation)
			{
				AnimationActive = NO;
				EndAnimation = YES;
				return 1;
			}
			//yes we loop the animation
			else {
				AnimationActive = YES;
				EndAnimation = YES;
				step = 0;
				frame = SpriteFrames[status][0].frame;
				return 1;
			}
		}
	}
	else delay --;
	
	
	return 0;
}


-(bool)ReturnLoopAnimation
{
	return SpriteFrames[status][0].loopAnimation;
}

//select the frame we want to show
-(void) SelectFrame:(int) frames
{
	step = frames;
	frame = SpriteFrames[status][step].frame;
}



//return our actual frame in an animation
-(int) GetActualFrame
{
	return SpriteFrames[status][step].cachedFrameNum;
}

-(int)GetActualFrameValueX
{
	return SpriteFrames[status][step].posX;
}

-(int)GetActualFrameValueY
{
	return SpriteFrames[status][step].posY;
}


//return the values for this animation
-(int)GetFrameSizeWidth
{
	return SpriteFrames[status][step].w;
}

-(int)GetFrameSizeHeight
{
	return SpriteFrames[status][step].h; 
}

-(int)GetFrameOffsetX
{
	return SpriteFrames[status][step].offsetX;
}

-(int)GetFrameOffsetY
{
	return SpriteFrames[status][step].offsetY;
}


//return our state to know in wich state we are
-(int) GetState
{
	return status;
}




/////////////////////
////////////////////
/// STATES
///////////////////
//////////////////


//change our animation state
-(void) ChangeStates:(state) Status
{
	EndAnimation = NO;
	AnimationActive = YES;
	status = Status;
}



//change our state and reset the animation to its first frame
-(void) ChangeStatesAndResetAnim:(state) State
{
	if (status != State)
	{
		EndAnimation = NO;
		AnimationActive = YES;
		status = State;
		step = 0;
	}
}



//refresh the animation to know what frame we need to draw
-(void) RefreshStates
{
	//the animation is not active, skip this
	if (!AnimationActive)
		return;
	
	[self NextAnimationFrame];
}




@end

