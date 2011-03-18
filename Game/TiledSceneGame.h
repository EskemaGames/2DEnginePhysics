//
//  TiledSceneGame.h
//  Engine2D
//
//  Created by Alejandro Perez Perez on 18/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StateManager;
@class Fonts;
@class SoundManager;
@class LenguageManager;
@class Camera;
@class ParticleEmitter;
@class TiledMap;
@class PlayerShip;
@class Widgets;
@class Image;


@interface TiledSceneGame : NSObject {
	
	//lenguage manager
	LenguageManager *MainGameText;
	
	
	//game sprites
	Image *SpriteGame;
	Image *tilesImage;
	
	//game states
	StateManager *gameState;

	
	//buttons for menus like pause game, and then return to game, exit, save,etc
	CGRect exitgamebutton;
	CGRect saveexitbutton;
	CGRect touchContinue;
	
	
	Widgets *pauseButton;
	Widgets *fireButton;
	
	//fonts
	Fonts *font1;
	
	//player, enemies, etc,etc
	TiledMap *testMap;
	PlayerShip *Mainplayer;

	
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
