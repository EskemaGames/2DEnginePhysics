////////////////////////////////////////////////////////////////////
//
// BaseActor.h
// this class controls all the actor in a game, like player, enemies
//npcs, bosses,etc.
//
////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h> 


#import "Image.h"
#import "Animations.h"
#import "SpriteBase.h"

@interface BaseActor : SpriteBase  
{  
	//pointers to classes
	Animations *Animation; //create a animation for our actor	

	//pointer to image and caches
	Image *baseImg;

	//vector to hold the direction for movement
	Vector2f m_direction;
	
	//store all the frames number for this sprite
	int TotalFramesAnimation;
	
	//used for physics, a character with fixed rotation
	//will never rotate due the physics forces
	//we don't want our player rotating when he falls from a ledge
	bool FixedRotation;
	
}




@property (nonatomic, retain) Animations *Animation;
@property (nonatomic, retain) Image *baseImg;



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
