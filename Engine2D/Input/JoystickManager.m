//
//  JoystickManager.m
//  testingStuff
//
//  Created by Alejandro Perez Perez on 25/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JoystickManager.h"
#import "Image.h"
#import "StateManager.h"


@implementation JoystickManager

@synthesize isLandscape;
@synthesize joystickDistance;
@synthesize movementDirection;


- (id) initJoystickImage:(Image *)sprtImage 
		PosScreenAndSize:(CGRect)posscreenSize 
				 SizeCap:(CGSize)sizeCap
				AtlasPos:(CGSize)atlasPos 
			 AtlasPosCap:(CGSize)atlasPosCap
				   Alpha:(float)alphaValue
	 drawOnlyJoystickCap:(bool)drawjoystick
			   Landscape:(bool)landscape
{
	self = [super init];
	if (self != nil) {
		
		states = [StateManager sharedStateManager];
		isLandscape = landscape;
		
		//assign the image
		joystickImage = sprtImage;
		
		//we want to draw the base joystick too not only the cap
		DrawOnlyJoystickCap = drawjoystick;
		
		//how transparent we want the cap image
		AlphaValueCap = alphaValue;
		
		movementDirection = 0;
		joystickDistance = 0;
		
		touchLocation = CGPointMake(0, 0);
		touchCoordinate = CGPointMake(0,0);
		
		//size for joystick base and cap
		ImgPositionSize = posscreenSize;
		ImgSizeCap = sizeCap;
		Atlaspos = atlasPos;
		AtlasposCap = atlasPosCap;
		
		//temp values to avoid double calculations
		capWidth = (ImgSizeCap.width * 0.5f);
		capHeigth = (ImgSizeCap.height * 0.5f);
		
		// Setup the joypad
		joystickCenter = CGPointMake(ImgPositionSize.origin.x + (ImgPositionSize.size.width * 0.5f), ImgPositionSize.origin.y + (ImgPositionSize.size.height * 0.5f));
		
		//set the bounds to the cap and increase that area 5 pixels
		joystickBounds = CGRectMake(joystickCenter.x - (capWidth + 5), 
									joystickCenter.y - (capHeigth + 5), 
									ImgSizeCap.width + 5, 
									ImgSizeCap.height + 5);
		
		//bounds of the total area used by the joystick
		joystickBoundsArea = CGRectMake(ImgPositionSize.origin.x, 
									ImgPositionSize.origin.y, 
									ImgPositionSize.size.width, 
									ImgPositionSize.size.height);
		
		//radius for the cap and position
		joystickMaxRadius = ImgPositionSize.size.width * 0.5f;
		joystickCapPosition = CGPointMake(joystickCenter.x - capWidth, joystickCenter.y - capHeigth);
		
	}
	return self;
}


- (void) dealloc
{
	[super dealloc];
}











#pragma mark -
#pragma mark JoystickDraw

-(void)DrawJoystick
{
	if (DrawOnlyJoystickCap)
	{
		//joystick cap
		[joystickImage DrawImageColor:CGRectMake( joystickCapPosition.x, joystickCapPosition.y , ImgSizeCap.width, ImgSizeCap.height) 
						  OffsetPoint:CGPointMake(AtlasposCap.width, AtlasposCap.height)
						   ImageWidth:ImgSizeCap.width ImageHeight:ImgSizeCap.height
							   Colors:Color4fMake(255, 255, 255, AlphaValueCap)];
	}
	else {
		//joystick base
		[joystickImage DrawImageColor:CGRectMake(ImgPositionSize.origin.x, ImgPositionSize.origin.y, ImgPositionSize.size.width, ImgPositionSize.size.height)
						  OffsetPoint:CGPointMake(Atlaspos.width, Atlaspos.height)
						   ImageWidth:ImgPositionSize.size.width ImageHeight:ImgPositionSize.size.height
							   Colors:Color4fMake(255, 255, 255, 0.3f)];
		
		//joystick cap
		[joystickImage DrawImageColor:CGRectMake( joystickCapPosition.x, joystickCapPosition.y , ImgSizeCap.width, ImgSizeCap.height) 
						  OffsetPoint:CGPointMake(AtlasposCap.width, AtlasposCap.height)
						   ImageWidth:ImgSizeCap.width ImageHeight:ImgSizeCap.height
							   Colors:Color4fMake(255, 255, 255, AlphaValueCap)];
	}
}








#pragma mark -
#pragma mark Touch events
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
    int x = touchLocation.y;  
    int y = (touchLocation.x - states.screenBounds.y);  
	
    //  make sure we take the absolute value of y, since if we didn't  
    //  y would always be a negative number.  
    y = fabsf(y);  
	
    //  Since we were converting the current state, we need to update  
    //  the current touch location  
    touchCoordinate = CGPointMake( x, y );  
} 





- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
    
	for (UITouch *touch in touches) {
        // Get the point where the player has touched the screen
		touchLocation = [touch locationInView:aView];
 
        // As we have the game in landscape mode we need to switch the touches 
        // x and y coordinates
        [self convertCoordinatesToLandscape];
        
		if (CGRectContainsPoint(joystickBounds, touchCoordinate) && !isJoystickTouchMoving) {
			isJoystickTouchMoving = YES;
			joystickTouchHash = [touch hash];
			continue;
		}

		
	}
}



- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	
    // Loop through all the touches
	for (UITouch *touch in touches) {
        
		if ([touch hash] == joystickTouchHash && isJoystickTouchMoving) {
			
			// Get the point where the player has touched the screen
			touchLocation = [touch locationInView:aView];

			// As we have the game in landscape mode we need to switch the touches 
			// x and y coordinates
			[self convertCoordinatesToLandscape];
			
			//if we inside the bounds of the joystick area proceed with movement
			if (CGRectContainsPoint(joystickBoundsArea, touchCoordinate)) 
			{
				// Calculate the angle of the touch from the center of the joypad
				float dx = joystickCenter.x - touchCoordinate.x;
				float dy = joystickCenter.y - touchCoordinate.y;
				
				
				// Calculate the distance from the center of the joystick to the players touch.
				// Manhatten Distance
				joystickDistance = fabsf(touchCoordinate.x - joystickCenter.x) + fabsf(touchCoordinate.y - joystickCenter.y);
				
				// Calculate the new direction of the joystick and how far from the
				// center the joypad has been moved
				movementDirection = atan2f(dy, dx);
				
				
				// If the players finger is outside of the joystick, make sure the joycap is drawn at the joystick edge.
				if ( joystickDistance > joystickMaxRadius) 
				{
					// Set the location of the joypadcap from the center at the angle of the players touch as calculated
					// above
					joystickCapPosition = CGPointMake((joystickCenter.x - cosf(movementDirection) * joystickMaxRadius) - capWidth, 
													  (joystickCenter.y - sinf(movementDirection) * joystickMaxRadius) - capHeigth );
				} else {
					// Simply set the location of the joypad cap to the location of the players touch
					joystickCapPosition.x = touchCoordinate.x - capWidth;
					joystickCapPosition.y = touchCoordinate.y - capHeigth;
				}
				
				
			}
			else {
				[self touchesEnded:touches withEvent:event view:aView];
			}
		}
    }
}



- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
    
	isJoystickTouchMoving = NO;
	// Loop through the touches checking to see if the joypad touch has finished
	for (UITouch *touch in touches) {
		// If the hash for the joypad has reported that its ended, then set the
		// state as necessary
		if ([touch hash] == joystickTouchHash) {
			joystickTouchHash = 0;
			movementDirection = 0;
			joystickDistance = 0;
			joystickCapPosition = CGPointMake(joystickCenter.x - capWidth, joystickCenter.y - capHeigth);
			return;
		}
	}	
}



@end
