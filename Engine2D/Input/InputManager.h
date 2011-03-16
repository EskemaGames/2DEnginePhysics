//
//  InputManager.h
//
//  Created by Eskema on 05/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//  
//  The input manager is a helper class that houses any input  
//  that can be obtained by the game engine. As a touch is detected  
//  on screen, it will send a message to the input helper. The input  
//  helper will then hold onto that message and filter it into the  
//  current state on the next game loop. The current state is moved  
//  to the previous state, and any incoming touches are then put  
//  back into the query state, waiting to be updated.  
//  
//  This method of updating lets the game filter updates to the top-most  
//  game screen and not have to worry about un-focused screens handling  
//  input that was not intended for them.  
//  
//  Created by Craig Giles on 1/3/09.  
//  Modified by Eskema 2009


#import <Foundation/Foundation.h>  
#import "InputState.h"  
@class StateManager;


@interface InputManager : NSObject  
{  
	StateManager *touchStateManager;
@private  
    bool isLandscape;  
	bool upsideDown;
    InputState *currentState;  
    InputState *previousState;  
    InputState *queryState;  
	
}  


@property (nonatomic, readwrite) bool isLandscape;  
@property (nonatomic, readwrite) bool upsideDown; 
@property (nonatomic, readonly) InputState *currentState;  
@property (nonatomic, readonly) InputState *previousState;  




//  
//  Touch events  
//  
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event InView:(UIView *)view;  
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event InView:(UIView *)view;  
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event InView:(UIView *)view;  
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event InView:(UIView *)view;  


//  
//  Helper Methods  
//  
- (void) update;
- (bool) isButtonPressed:(CGRect)rect Active:(bool)active; 
- (bool) isButtonHeld:(CGRect)rect Active:(bool)active;
- (void) convertCoordinatesToLandscape;  
- (void) convertCoordinatesToPortraitUpsideDown;
//  
//  Class methods  
//  
+ (bool) doesRectangle:(CGRect)rect ContainPoint:(CGPoint)point;  


@end 
