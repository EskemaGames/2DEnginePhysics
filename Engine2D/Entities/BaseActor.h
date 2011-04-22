////////////////////////////////////////////////////////////////////
//
// BaseActor.h
// this class controls all the actor in a game, like player, enemies
//npcs, bosses,etc.
//
////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h> 


#import "Animations.h"
#import "SpriteBase.h"
#import "StateManager.h"

@interface BaseActor : SpriteBase  
{  
	
	
	StateManager *m_states;
	
	
	//pointers to classes
	Animations *_Animation; //create a animation for our actor	
	
	//vector to hold the direction for movement
	Vector2f _m_direction;
	
	//store all the frames number for this sprite
	int _TotalFramesAnimation;
	
	//used for physics, a character with fixed rotation
	//will never rotate due the physics forces
	//we don't want our player rotating when he falls from a ledge
	bool _FixedRotation;
	
	//define the type of this actor (player, enemy, boss,etc,etc)
	TypeActor _typeActor;
	
	CGRect _boundigxBox;
	
	Vector2f _cameraPosition;
}




@property (nonatomic, retain) Animations *_Animation;
@property (readwrite) TypeActor _typeActor;
@property (nonatomic, readwrite) Vector2f _m_direction;
@property (nonatomic, readwrite) CGRect _boundigxBox;

//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================

-(void) InitActorImage:(Image *)Spriteimage FileName:(NSString *)_filename;
-(void) Draw:(Color4f)_colors;
-(void) MoveXSpeed:(float)GameSpeed;
-(void) MoveYSpeed:(float)GameSpeed;
-(void)SetDirectionX:(float)direction;
-(void)SetDirectionY:(float)direction;
-(float)GetDirectionX;
-(Vector2f)GetDirection;
-(void)SetCameraPosition:(Vector2f)camerapos;

-(void)Update;
-(int)DetectCollision:(BaseActor *)sprCollision Actor2:(BaseActor *)thisActor CustomCollision:(bool)centered;
-(void) drawBoundigBox:(CGRect) aRect;
-(void)UpdateBoundingBox;

@end
