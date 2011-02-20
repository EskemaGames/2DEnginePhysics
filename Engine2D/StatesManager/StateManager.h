//
//  StateManager.h
//  
//
//  Created by Eskema on 02/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h> 
@class Image;



//touchs and sound manager
#import "InputManager.h"
#import "SoundManager.h"

//common defines
#import "defines.h"



//game screens forward declaration
@class MenuScreen;
@class MainGameScreen;
@class MainGameWithoutPhysics;



@interface StateManager : NSObject 
{

	//enum for states
    options StateOption;
	
	//for transitions fade in/out
	Image *blanktexture;
	

	//sounds
	float TotalVolume; //our game and sounds volume
	int VolumeGlobal; //our volume and sounds display
	

	//for transitions fade in/out
	bool fadecompleted, fadeOut;
	float alpha, alphaOut;
	int counteralpha, counteralphaOut, TimeAlpha, TimeAlphaOut;
	
	
	//flag for transitions between screeens
	bool menuinitialised, gameinitialised, gamenophysics;

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
	
	//game screens
	MenuScreen *MainMenu;
	MainGameScreen *MainGame;
	MainGameWithoutPhysics *MainGameNoPhysics;
	
	
}

@property (nonatomic, retain) SoundManager *sharedSoundManager;
@property (nonatomic, readwrite) Vector2f screenBounds;
@property (nonatomic, retain) InputManager *input;
@property (nonatomic, retain) Image *blanktexture;
@property (readwrite) bool menuinitialised, gameinitialised, gamenophysics;

@property (readwrite) bool fadecompleted, fadeOut;
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
-(id)initStates:(bool)landscapeView;
- (int) GetState;
- (void) ChangeStates:(options)optionselected;
- (void) UpdateScreenTransition;
- (void) UpdateTransitionOut;
- (void) fadeBackBufferToBlack:(double)alpha1;
- (void) updateScene:(float)deltaTime; 
- (void) DrawScene;





@end

