//
//  MainGameWithoutPhysics.m
//  Engine2D
//
//  Created by Alejandro Perez Perez on 24/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainGameWithoutPhysics.h"


//main classes
#import "StateManager.h"
#import "Fonts.h"
#import "LenguageManager.h"
#import "ParticleEmitter.h"
#import "TileMaps_Mappy.h"
#import "PlayerShip.h"
#import "Widgets.h"
#import "Image.h"



@implementation MainGameWithoutPhysics

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
	
	exitScreen = NO;
	pausedgame = NO;
	
	
	// IMAGE for the whole game
	SpriteGame		= [[Image alloc] initWithTexture:@"spritesheet.png"  filter:GL_LINEAR Use32bits:NO TotalVertex:4000];

	
	//init the font
	font1 = [[Fonts alloc] LoadFont:SpriteGame FileFont:@"gunexported.fnt"];
	
	
	//player
	Mainplayer = [[PlayerShip alloc] initImage:SpriteGame FileName:@"PlayershipConfig.xml" Physic:nil TypeShape:BOX];

	
	//tilemaps class init
	testMap = [[TileMaps_Mappy alloc] init];
	
	//tilemap with automatic scroll
	[testMap LoadLevel:SpriteGame ConfigFile:@"LevelScroll.xml" Physic:nil];
	
	
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
	
	
	// Init particle emitter with explosion	
	shiptrail = [[ParticleEmitter alloc] initParticleEmitterWithFile:@"TrailEffect.pex"];
	[shiptrail setDuration:-1.0f];
	
	
	[self InitGame];
	
}  




- (void) unloadContent  
{ 
	[MainGameText release];
	[font1 release];
	[testMap release];
	[SpriteGame release];
	[Mainplayer release];
	
	[shiptrail release];
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
			pausedgame = YES;
			gameState.alphaOut = 0.0f;
			gameState.fadeOut = NO;
			gameState.gamenophysics = NO;
			gameState.fadecompleted = NO;
			[self unloadContent];
		}
		
	}
	
	//game is not paused? then update player and camera position/animation
	if (!pausedgame)
	{
		//update map scroll
		[testMap UpdateScroll:deltaTime];
		
		//update our player animations and movements
		[Mainplayer Update:deltaTime Touchlocation:touchLocation];
		

		//update trail for the player ship
		shiptrail.sourcePosition = Vector2fMake((Mainplayer.position.x+16), (Mainplayer.position.y+36));
		[shiptrail updateWithDelta:deltaTime];
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

	//background map
	[testMap DrawLevelWithScrollLayer:0 Colors:Color4fInit];



	//a placeholder for the bottom of the screen
	[SpriteGame DrawImage:CGRectMake(0, gameState.screenBounds.y-32, gameState.screenBounds.x, 32) 
			  OffsetPoint:CGPointMake(288, 0)
			   ImageWidth:32 ImageHeight:32];
	
	[SpriteGame RenderToScreenActiveBlend:NO];
	
	
	
	
	//
	//now start another batch with alpha sprites
	//
	
	//player
	[Mainplayer Draw:Color4fInit];
	
	
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
	
	
	
	
	//render particles after everything to be on top of everything
	[shiptrail renderParticles];
	
	
	
	//if we are exiting to main menu draw the transition screen
	if(exitScreen)
		[gameState fadeBackBufferToBlack:gameState.alphaOut];
	
	
	
}





-(void) ExitGame
{
	[self unloadContent];
}



@end








