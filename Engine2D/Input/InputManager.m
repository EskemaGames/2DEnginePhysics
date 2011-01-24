//
//  InputManager.m
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
//  Modifications made by Eskema 2009
//  


#import "InputManager.h"  
#import "StateManager.h"


@implementation InputManager  

//  
//  Getters / Setters  
//  
@synthesize isLandscape;  
@synthesize currentState;  
@synthesize previousState;  


//  
//  Initialization  
//  
- (id) init:(StateManager *)states_ 
{  
    self = [super init];  
    if (self != nil)  
    {
		touchStateManager = states_;
		
        //  
        //  Allocate memory for all of the possible states  
        //  
        currentState = [[InputState alloc] init];  
        previousState = [[InputState alloc] init];  
        queryState = [[InputState alloc] init];  
		
        //  
        //  Set the initial coords for the touch locations.  
        //  
        currentState.touchLocation = CGPointMake(0, 0);  
        previousState.touchLocation = CGPointMake(0, 0);  
        queryState.touchLocation = CGPointMake(0, 0);  
    }  
    return self;  
}  

//  
//  Deallocation  
//  
- (void) dealloc  
{  
    [currentState release];  
    [previousState release];  
    [queryState release];  
    [super dealloc];  
}  

//  
//  Update the input manager. This method will take the  
//  values in updateState and apply them to the current state.  
//  in essence, this method will "query" the current state  
//  
- (void) update  
{  
    //  Sets previous state to current state  
    previousState.isBeingTouched = currentState.isBeingTouched;  
    previousState.touchLocation = currentState.touchLocation;  
	
    //  Sets the current state to the query state  
    currentState.isBeingTouched = queryState.isBeingTouched;  
    currentState.touchLocation = queryState.touchLocation;  
	
    //  converts the coordinate system if the game is in landscape mode  
    [self convertCoordinatesToLandscape];  
}  



//  
//  Touch events  
//  
//  These events are filtered into the input manager as they occur.  
//  Since we want to control how our input, we are going to use a  
//  queryState as the "Live" state, while our current and previous  
//  states are updated every loop. For this reason, we are always  
//  modifying the queryState when these touch events are detected,  
//  and the current state is only modified on [self update:deltaTime];  
//  

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event InView:(UIView *)view
{
	queryState.isBeingTouched = YES;
	queryState.touchLocation = [[touches anyObject] locationInView:view];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event InView:(UIView *)view
{

	queryState.isBeingTouched = YES;  
    queryState.touchLocation = [[touches anyObject] locationInView:view];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event InView:(UIView *)view 
{
	queryState.isBeingTouched = NO;  
    queryState.touchLocation = [[touches anyObject] locationInView:view];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event InView:(UIView *)view  
{  
    queryState.isBeingTouched = NO;  
}  







//  
//  When in landscape mode, the touch screen still records input  
//  as if it were in portrait mode. To get around this, if we  
//  are writing a game in landscape we need to adjust the coordinate  
//  system on the touchscreen to match that of our world.  
//  
- (void) convertCoordinatesToLandscape  
{  
    //  If we are not in landscape mode, don't convert anything  
    if ( !isLandscape )  
        return;  
	
    //  Otherwise, we will need to take the current touch location  
    //  swap the x and y values (since in landscape, the portrait  
    //  coordinate system means x will point up / down instead of  
    //  left / right) and move the y position to match our origin  
    //  point of (0,0) in the upper left corner.  
    int x = currentState.touchLocation.y;  
    int y = (currentState.touchLocation.x - touchStateManager.screenBounds.y);  
	
    //  make sure we take the absolute value of y, since if we didn't  
    //  y would always be a negative number.  
    y = abs(y);  
	
    //  Since we were converting the current state, we need to update  
    //  the current touch location  
    currentState.touchLocation = CGPointMake( x, y );  
}  

//  
//  Looks at the previous state, and the current state to determine  
//  weather or not the button (rectangle) was just pressed and released.  
//  
- (bool) isButtonPressed:(CGRect)rect Active:(bool)active
{  
    //  
    //  If the current state is not being touched  
    //  and the previous state is being touched, the  
    //  user just released their touch. This is  
    //  personal preference really, But i've found with  
    //  my XNA programming, that its better to detect if  
    //  a button was just released rather than if it was  
    //  just pressed in when determining a button press.  
    //  
	if (active)
	{
		if ( !currentState.isBeingTouched &&  
			previousState.isBeingTouched )  
		{  
			return  [InputManager doesRectangle:rect ContainPoint:currentState.touchLocation];  
		}
	}
	
    return NO;  
}  

//  
//  Looks at the previous state, and the current state to determine  
//  weather or not the button (rectangle) is being held down.  
//  
- (bool) isButtonHeld:(CGRect)rect Active:(bool)active
{  
    //  
    //  If the current state and the previous states  
    //  are being touched, the user is holding their  
    //  touch on the screen.  
    //  
	if (active)
	{
		if ( currentState.isBeingTouched &&  
			previousState.isBeingTouched )  
		{  
			return  [InputManager doesRectangle:rect ContainPoint:currentState.touchLocation];  
		}
	}
	
    return NO;  
}  

//  
//  Helper method for determining if a rectangle contains a point.  
//  Unsure if this will stay in the input helper or be moved to some  
//  sort of "RectangleHelper" class in the future, but for now this  
//  is a good spot for it. Remember, this works with our current coord  
//  system. If your engine uses a different coord system (IE: (0,0) is at  
//  the bottom left of the screen) you'll need to modify this method.  
//  
+ (bool) doesRectangle:(CGRect)rect ContainPoint:(CGPoint)point  
{  
    //  
    //  If the rectangle contains the given point, return YES  
    //  Otherwise, the point is outside the rectangle, return NO  
    //  
    if (point.x > rect.origin.x &&  
        point.x < rect.origin.x + rect.size.width &&  
        point.y > rect.origin.y &&  
        point.y < rect.origin.y + rect.size.height)  
    {  
        return YES;  
    }  
	
    return NO;  
}  




@end 
