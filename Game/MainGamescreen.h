//
//  
//  
//
//  Created by Eskema on 16/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>




@class StateManager;
@class Fonts;
@class SoundManager;
@class LenguageManager;
@class Camera;
@class ParticleEmitter;
@class TileMaps_Mappy;
@class PlayerShip;
@class Widgets;
@class PhysicsWorld;
@class Image;

@interface MainGameScreen : NSObject 
{
	
	//lenguage manager
	LenguageManager *MainGameText;
	
	
	//game sprites
	Image *SpriteGame;
	Image *tilesImage;
	
	//game states
	StateManager *gameState;
	
	
	//physics world
	PhysicsWorld *physicWorld;
	
	//buttons for menus like pause game, and then return to game, exit, save,etc
	CGRect exitgamebutton;
	CGRect saveexitbutton;
	CGRect touchContinue;
	

	Widgets *pauseButton;
	Widgets *fireButton;
	
	//fonts
	Fonts *font1;

	//player, enemies, etc,etc
	TileMaps_Mappy *testMap;
	PlayerShip *Mainplayer;
	PlayerShip *Mainplayer2;
	
	
	//some flags for touches
	bool touched;
	bool pausedgame;
	bool exitScreen;
	//Touch in screen for enemies;
	CGPoint touchLocation;

}




///////////////////////
///
///	 GENERAL FUNCTIONS
///
///////////////////////

- (void) loadContent;
- (void) unloadContent;
- (void) handleInput;
- (void) update:(float)deltaTime;
- (void) draw;




//////////////////////
///
///	FUNCTIONS IN GAME
///
/////////////////////
-(void) InitGame;
-(void) DrawLevelGame;
-(void) ExitGame;






@end
