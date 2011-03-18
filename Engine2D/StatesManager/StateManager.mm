//
//  StateManager.m
//  
//
//  Created by Eskema on 02/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "StateManager.h"
//include image to handle the fade image
#import "Image.h"

//screens
#import "MenuScreen.h"
#import "MainGamescreen.h"
#import "MainGameWithoutPhysics.h"
#import "TiledSceneGame.h"



@implementation StateManager

@synthesize isIpad;
@synthesize isRetinaDisplay;
@synthesize sharedSoundManager;
@synthesize interfaceOrientation;
@synthesize input;
@synthesize joystick;
@synthesize screenBounds;
@synthesize sceneInitialised;
@synthesize fadecompleted, fadeOut, alpha, alphaOut, TimeAlpha, TimeAlphaOut, counteralpha, counteralphaOut;
@synthesize blanktexture, _FPS, SpeedFactor,  TotalVolume, VolumeGlobal;


// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(StateManager);


- (id)init {
    self = [super init];
    if(self != nil) {
		
    }
    return self;
}


- (void) initStates:(bool)landscapeView
{  
	StateOption = MENU;

	isIpad = NO;
	isRetinaDisplay = NO;
	
	//flag to change between scenes, always start to NO
	sceneInitialised = NO;

	fadeOut = NO;
	fadecompleted = NO;
	counteralphaOut = 0;
	
	//for transitions
	alpha = 1.0f;
	alphaOut = 0.0f;
	TimeAlpha = 10;
	TimeAlphaOut = 10;
	counteralpha = 0;

	
	//volume
	VolumeGlobal = 5;
	TotalVolume = 0.5;
	
	//for fps counter
	_FPS = 0;
	
	//gamespeed
	SpeedFactor = 0;
	
	//texture for transitions between screens
	blanktexture  = [[Image alloc] initWithTexture:@"Blank.png"  filter:GL_LINEAR Use32bits:YES TotalVertex:12];
	

	// Init sound and load a sound
	sharedSoundManager = [SoundManager sharedSoundManager];
	//[sharedSoundManager loadSoundWithKey:@"soundtest" fileName:@"click" fileExt:@"wav" ];

	
	// Set the orientation of the device
	interfaceOrientation = UIInterfaceOrientationPortrait;
	
	//init the touches system
	//and set the property to the screen orientation
	input = [[InputManager alloc] init];
	if (landscapeView)
    input.isLandscape = YES;
	else input.isLandscape = NO;
	 
}



// release resources when they are no longer needed.
- (void)dealloc
{	
	[sharedSoundManager shutdownSoundManager];
	[blanktexture release];
	[input release];
	[super dealloc];
}




-(int) GetState
{
    return StateOption;
}




-(void) ChangeStates:(options)optionselected
{
	StateOption = optionselected;
	[self ResetScene];
    
}



//call this each time you change the scene
-(void)ResetScene
{
	sceneInitialised = NO;
	fadecompleted = NO;
	fadeOut = NO;
	alphaOut = 0.0f;
}




//the counter alpha value is some value that fit may needs
//you can change this to modify the speed of the transitions (fade out/in)
-(void) UpdateScreenTransition
{
	
	if( !( counteralpha%5 ) ) 
	{
		TimeAlpha--;
		
		if (alpha > 0.0f)
		{
			alpha -=0.1f;
		}
	}
	counteralpha++;
	
	if (TimeAlpha <= 0)
	{
		fadecompleted = YES;
		alpha = 1.0f;
		TimeAlpha = 10;
		counteralpha = 0;
	}
}


-(void) UpdateTransitionOut
{
	
	if( !( counteralphaOut%7 ) ) //7 its some value that fit my needs
	{
		TimeAlphaOut--;
		
		if (alphaOut < 1.0f)
		{
			alphaOut +=0.1f;
		}
	}
	counteralphaOut++;
	
	if (TimeAlphaOut <= 0)
	{
		fadeOut = YES;
		alphaOut = 1.0f; 
		TimeAlphaOut = 10;
		counteralphaOut = 0;
	}
}




- (void) fadeBackBufferToBlack:(double)alpha1  
{  
    glColor4f(alpha1, alpha1, alpha1, alpha1);  
	[blanktexture  drawInEntireRect:CGRectMake(0, 0, screenBounds.x, screenBounds.y)];
	
} 





//update the scene based on the current state
- (void)updateScene:(float)deltaTime 
{	
	
	//update the input 
    //[input update];
	
	switch ( [self GetState] )
	{
			//scene PLAY
		case PLAY:
			if (!fadecompleted)
			{
				[self UpdateScreenTransition];
			}
			else{
				[MainGame handleInput];
				[MainGame update:deltaTime];
			}
			break;
			
		case PLAYNOPHYSICS:
			if (!fadecompleted)
			{
				[self UpdateScreenTransition];
			}
			else{
				[MainGameNoPhysics handleInput];
				[MainGameNoPhysics update:deltaTime];
			}
			break;
			
			
		case PLAYTILEDMAP:
			if (!fadecompleted)
			{
				[self UpdateScreenTransition];
			}
			else{
				[_Tiledgame handleInput];
				[_Tiledgame update:deltaTime];
			}
			break;
			
		
			//scene MENU
		case MENU:
			if (!fadecompleted)
			{
				[self UpdateScreenTransition];
			}
			else{
				[MainMenu handleInput];
				[MainMenu update:deltaTime];
			}
			break;	
				
	};

	//update the input 
    [input update];
	
}











- (void)DrawScene {

	
	switch ( [self GetState] )
	{
			//scene MENU
		case MENU:
			if (!sceneInitialised)
			{
				MainMenu = [[MenuScreen alloc] init];
				sceneInitialised = YES;
			}
			else
				[MainMenu draw];
			
			if (!fadecompleted)
			{
				[self fadeBackBufferToBlack:alpha];
			}
			break;
			
			
		//scene PLAY
		case PLAY:
		if (!sceneInitialised) 
		{
			MainGame = [[MainGameScreen alloc] init];
			sceneInitialised = YES;
		}
		else
		[MainGame draw];
		
		if (!fadecompleted)
		{
			[self fadeBackBufferToBlack:alpha];
		}
		break;

			
		case PLAYNOPHYSICS:
			if (!sceneInitialised)
			{
				MainGameNoPhysics = [[MainGameWithoutPhysics alloc] init];
				sceneInitialised = YES;
			}
			else
				[MainGameNoPhysics draw];
			
			if (!fadecompleted)
			{
				[self fadeBackBufferToBlack:alpha];
			}
		break;
		
			
		case PLAYTILEDMAP:
			if (!sceneInitialised)
			{
				sceneInitialised = YES;
				_Tiledgame = [[TiledSceneGame alloc] init];
				sceneInitialised = YES;
			}
			else
				[_Tiledgame draw];
			
			if (!fadecompleted)
			{
				[self fadeBackBufferToBlack:alpha];
			}
			break;
			
	};

}


@end
