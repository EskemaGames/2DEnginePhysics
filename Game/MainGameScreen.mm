//
//  
//  
//
//  Created by Eskema on 16/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainGamescreen.h"

//main classes
#import "StateManager.h"
#import "Fonts.h"
#import "LenguageManager.h"
#import "ParticleEmitter.h"
#import "TileMaps.h"
#import "PlayerShip.h"
#import "Widgets.h"
#import "PhysicsWorld.h"
#import "Image.h"






@implementation MainGameScreen


//  
//  Initialize the ingame screen  
//  
-(id) init
{  
    self = [super init];
	if (self != nil)  
    {  
		gameState = [StateManager sharedStateManager];
		[self loadContent]; 

	}
	return self;
}




- (void) dealloc
{
	[super dealloc];
}






- (void) loadContent  
{

	//init the physics world
	physicWorld = [[PhysicsWorld alloc] initSleepBodies:YES];
	
	
	exitScreen = NO;
	pausedgame = NO;
	
	
	
	// IMAGE for the whole game
	SpriteGame		= [[Image alloc] initWithTexture:@"spritesheet.png"  filter:GL_LINEAR Use32bits:NO TotalVertex:4000];
	tilesImage		= [[Image alloc] initWithTexture:@"tileset.png"  filter:GL_NEAREST Use32bits:NO TotalVertex:4000];

	
	//init the font
	font1 = [[Fonts alloc] LoadFont:SpriteGame FileFont:@"gunexported.fnt"];
	

	//player
	Mainplayer = [[PlayerShip alloc] initImage:SpriteGame FileName:@"PlayershipConfig.xml" Physic:physicWorld TypeShape:BOX];
	Mainplayer2 = [[PlayerShip alloc] initImage:SpriteGame FileName:@"PlayershipConfig2.xml" Physic:physicWorld TypeShape:BOX];

	
	
	//tilemaps class init
	testMap = [[TileMaps alloc] init];
	
	//normal tilemap
	[testMap LoadLevel:tilesImage ConfigFile:@"Level.xml" Physic:physicWorld];

	
	//touch attack;
	touched = NO;

	
	
	//text resources
	MainGameText = [[LenguageManager alloc] init];
	[MainGameText LoadText:@"game"];

	//button for pause game
	pauseButton = [[Widgets alloc] initWidget:Vector2fMake(gameState.screenBounds.x - 32, 5.0f)
									 Size:Vector2fMake(64.0f, 64.0f)
								 LocAtlas:Vector2fMake(0.0f, 192.0f)
									Color:Color4fInit 
									Scale:Vector2fMake(0.5f, 0.5f)
								 Rotation:0.0f 
								   Active:YES
									Image:SpriteGame];
	
	fireButton = [[Widgets alloc] initWidget:Vector2fMake(gameState.screenBounds.x - 32, gameState.screenBounds.y - 64.0f)
										Size:Vector2fMake(64.0f, 64.0f)
									LocAtlas:Vector2fMake(0.0f, 192.0f)
									   Color:Color4fInit 
									   Scale:Vector2fMake(0.5f, 0.5f)
									Rotation:0.0f 
									  Active:YES
									   Image:SpriteGame];
	


	[self InitGame];
	
}  




- (void) unloadContent  
{ 
	[MainGameText release];
	[font1 release];
	[testMap release];
	[SpriteGame release];
	[Mainplayer release];
	[Mainplayer2 release];

	[physicWorld release];
	[fireButton release];
	[pauseButton release];
	[self dealloc];
}  




//update touches ingame
//this code is only a skeleton, and based on a specific game
//you need to delete this and create your touch code for you joystick or whatever
- (void) handleInput
{  
	//touches to move the player ship, this simply control when a touch is detected
	//the player class will handle the touch
	if ( gameState.input.currentState.isBeingTouched )
	{
		touchLocation = gameState.input.currentState.touchLocation;
	}
	
	
	//if game is paused, unpause, if not pause game
	if ([gameState.input isButtonPressed:pauseButton.touch Active:YES] && pausedgame == YES)  
	{ 
		pausedgame = NO;
	} else if ([gameState.input isButtonPressed:pauseButton.touch Active:YES]  && pausedgame == NO){
		pausedgame = YES;
	}

	
	//if you are in pause and press the button, exit to main menu
	if (pausedgame == YES)
	{
		if ([gameState.input isButtonPressed:fireButton.touch Active:YES])    
		{
			exitScreen = YES;
		}
	}

	
	//release all touches
	if ( !gameState.input.currentState.isBeingTouched )
	{
		touched = NO;
	}
	
} 



- (void) update:(float)deltaTime
{  
	//update transition to exit
	if (exitScreen)
	{
		if (!gameState.fadeOut)
		{
			[gameState UpdateTransitionOut];
		}
		else{
			[gameState ChangeStates:MENU];
			gameState.alphaOut = 0.0f;
			gameState.fadeOut = NO;
			gameState.gameinitialised = NO;
			gameState.fadecompleted = NO;
			[self unloadContent];
		}
		
	}
	
	//game is not paused? then update player and camera position/animation
	if (!pausedgame)
	{
		//update our player animations and movements
		[Mainplayer Update:deltaTime Touchlocation:touchLocation];
		
		[Mainplayer2 Update:deltaTime Touchlocation:touchLocation];
		
		//update physics
		[physicWorld Update];
		
	}
	
}  




- (void) draw
{
	[self DrawLevelGame];
}  










//////////////////////////////////////////////
/////
////
////    MAIN GAME PERSONALIZED CODE
////
////
/////////////////////////////////////////////

-(void) InitGame
{
	exitScreen = NO;
	pausedgame = NO;
}
	 


-(void) DrawLevelGame
{
	[SpriteGame DrawImage:CGRectMake(0, 0, gameState.screenBounds.x, gameState.screenBounds.y) 
			  OffsetPoint:CGPointMake(256, 0)
			   ImageWidth:32 ImageHeight:32];
	
	//a placeholder for the bottom of the screen
	[SpriteGame DrawImage:CGRectMake(0, gameState.screenBounds.y-32, gameState.screenBounds.x, 32) 
			  OffsetPoint:CGPointMake(288, 0)
			   ImageWidth:32 ImageHeight:32];
	
	//draw these 2 images as a batch
	[SpriteGame RenderToScreenActiveBlend:NO];
	
	
	
	//background map
	[testMap DrawLevelCameraX:0.0f CameraY:0.0f Layer:0 Colors:Color4fInit];

	//the tilemap don't have any alpha sprite, so draw this batch right now
	[tilesImage RenderToScreenActiveBlend:NO];

	
	
	
	
	//
	//now start another batch with alpha sprites
	//

	//player
	[Mainplayer Draw:Color4fInit];
	[Mainplayer2 Draw:Color4fInit];
	
	
	//draw buttons on top of the other sprites
	[pauseButton DrawWidget];
	[fireButton DrawWidget];
	
	//now draw text in another batch because this is an alpha material
	//more text drawn at the bottom
	[font1 DrawTextX:gameState.screenBounds.x - [font1 GetTextWidth:@"scores down here" Scale:1.0f]  Y:gameState.screenBounds.y - [font1 GetTextHeight:1.0]  Scale:1.0  Text:@"scores down here"];

	
	
	//we want to draw fps?
	if(FPS)
	{
		[font1 DrawTextX:0 Y:gameState.screenBounds.y - [font1 GetTextHeight:1.0f] Scale:1.0f Text:[NSString stringWithFormat: @"FPS %.1f", gameState._FPS]];
	}
	
	
	//draw all the sprites with alpha blend active, needed for transparency
	[SpriteGame RenderToScreenActiveBlend:YES];
	
	
	
	//if we are exiting to main menu draw the transition screen
	if(exitScreen)
		[gameState fadeBackBufferToBlack:gameState.alphaOut];
	
		

}
 




-(void) ExitGame
{
	[self unloadContent];
}



@end








