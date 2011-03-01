////////////////////////////////////////////////////////////////////
//
// BaseActor.h
// this class controls all the actor in a game, like player, enemies
//npcs, bosses,etc.
//
////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h> 


#import "StateManager.h"
#import "Animations.h"
#import "SpriteBase.h"

@interface BaseActor : SpriteBase  
{  
	//access the statemanager for all actors derived from this class
	StateManager *m_states;
	
	//pointers to classes
	Animations *Animation; //create a animation for our actor	


	//vector to hold the direction for movement
	Vector2f m_direction;
	
	//store all the frames number for this sprite
	int TotalFramesAnimation;
	
	//used for physics, a character with fixed rotation
	//will never rotate due the physics forces
	//we don't want our player rotating when he falls from a ledge
	bool FixedRotation;
	
	//define the type of this actor (player, enemy, boss,etc,etc)
	TypeActor _typeActor;
	
}




@property (nonatomic, retain) Animations *Animation;
@property (readwrite) TypeActor _typeActor;




//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================

-(void) InitActorImage:(Image *)Spriteimage FileName:(NSString *)_filename;
-(void) Draw:(Color4f)_colors;
-(void) MoveXSpeed:(float)GameSpeed;
-(void) MoveYSpeed:(float)GameSpeed;
-(void)Update;

@end
