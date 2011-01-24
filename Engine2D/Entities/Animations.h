////////////////////////////////////////////////////////////
//
// Animations.h
// this class controls all the animations added to any sprite
//
/////////////////////////////////////////////////////////////

//this class needs to be some refactoring code
//instead of this classic animation system is better to improve it
//to allow more types of animation, usually saving the frame rects position
//to use it later to conform animations


#import "defines.h"
#import "Common.h"

#import <Foundation/Foundation.h>  




//now our class
@interface Animations : NSObject  
{  
	//create a sprite array to hold all the animations
	_AnimationSprite **SpriteFrames;
	
    int frame;				//actual frame to calculate
	int frametoDisplay;		//actual frame to display
    int step;				//counter to increase frame
    state status;			//the animation states
    int delay;				//establish time between frames 
}  




@property (nonatomic, readwrite) int frame;  
@property (nonatomic, readwrite) int frametoDisplay;  
@property (nonatomic, readwrite) int step;
@property (nonatomic, readwrite) int delay;



//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================
-(void)InitArray:(state)states Number:(int)num;
-(void) LoadAnimation:(state)states   AnimationValues:(CGRect)Animationvalues Speed:(int)speed frames_number:(int)frames EndAnimation:(int)endAnimation CachedNum:(int)cachedNum;
-(int) NextAnimationFrame;
-(void) SelectFrame:(int) frames;
-(int) GetActualFrame;
-(int)GetFrameSizeWidth;
-(int)GetFrameSizeHeight;
-(int) GetState;

//States
-(void) ChangeStates:(state) Status;
-(void) ChangeStatesAndResetAnim:(state) State;
-(void) RefreshStates;


@end  


