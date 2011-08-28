//
//  StateManager.h
//  
//
//  Created by Eskema on 02/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h> 
@class EAGLView;
@class Image;



//touchs and sound manager
#import "InputManager.h"
#import "SoundManager.h"
#import "JoystickManager.h"

//common defines
#import "defines.h"



//game screens forward declaration
@class MenuScreen;
@class MainGameScreen;
@class MainGameWithoutPhysics;
@class TiledSceneGame;


@interface StateManager : NSObject 
{
    //added to control uikit views
    EAGLView *eaglView;
	UIInterfaceOrientation interfaceOrientation;
	
	//enum for states
    options StateOption;
	
	//for transitions fade in/out
	Image *blanktexture;
	
	//change coordinates and everything is the game is running on ipad
	bool isIpad;
	
	//check retina display
	bool isRetinaDisplay;
	
	//sounds
	float TotalVolume; //our game and sounds volume
	int VolumeGlobal; //our volume and sounds display
	

	//for transitions fade in/out
	bool fadecompleted, fadeOut;
	float alpha, alphaOut;
	int counteralpha, counteralphaOut, TimeAlpha, TimeAlphaOut;
	
	
	//flag for transitions between screeens
	bool sceneInitialised;

	//store FPS
	float _FPS;
	
	//gamespeed delta
	float SpeedFactor;
	
	//the screen size
	Vector2f screenBounds;
	
	//sound
	SoundManager *sharedSoundManager;

	//touches
	InputManager *input;
	JoystickManager *joystick;
	
	//game screens
	MenuScreen *MainMenu;
	MainGameScreen *MainGame;
	MainGameWithoutPhysics *MainGameNoPhysics;
	TiledSceneGame *_Tiledgame;
	
	
}

@property (readwrite) bool isIpad;
@property (nonatomic, retain) SoundManager *sharedSoundManager;
@property (nonatomic, retain) EAGLView *eaglView;
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic, readwrite) Vector2f screenBounds;
@property (nonatomic, retain) InputManager *input;
@property (nonatomic, retain) JoystickManager *joystick;
@property (nonatomic, retain) Image *blanktexture;
@property (readwrite) bool sceneInitialised;

@property (readwrite) bool fadecompleted, fadeOut, isRetinaDisplay;
@property (readwrite) float alpha, alphaOut, _FPS, SpeedFactor, TotalVolume;
@property (readwrite) int counteralpha, counteralphaOut, TimeAlpha, TimeAlphaOut, VolumeGlobal;


// Class method to return an instance of GameController.  This is needed as this
// class is a singleton class
+ (StateManager *)sharedStateManager;


//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================
- (void)initStates:(bool)landscapeView;
- (int) GetState;
- (void)ResetScene;
- (void) ChangeStates:(options)optionselected;
- (void) UpdateScreenTransition:(float)deltaTime;
- (void) UpdateTransitionOut:(float)deltaTime;
- (void) fadeBackBufferToBlack:(double)alpha1;
- (void) updateScene:(float)deltaTime; 
- (void) DrawScene;





@end

