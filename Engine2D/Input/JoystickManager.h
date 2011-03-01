//
//  JoystickManager.h
//  testingStuff
//
//  Created by Alejandro Perez Perez on 25/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Image;
@class StateManager;

@interface JoystickManager : NSObject {

	//manager
	StateManager *states;
	
	//Image
	Image *joystickImage;
	
	//atlas position of the joystick image (base and cap)
	CGRect ImgPositionSize;
	CGSize ImgSizeCap;
	CGSize Atlaspos;
	CGSize AtlasposCap;
	bool DrawOnlyJoystickCap;
	
	//alpha value to draw the cap
	float AlphaValueCap;
	
	//movement direction based on input
	float movementDirection;
	
	//store the touched coordinate
	CGPoint touchCoordinate;
	CGPoint touchLocation; 
	
	// Bounds of the rectangle in which a touch is classed as activating the joystick
	CGRect joystickBounds;
	
	//bounds of the total area for the joystick including movement, useful to check if the finger
	//is outside the joystick area and stop the movement
	CGRect joystickBoundsArea;
	
	// Center of the joystick
	CGPoint joystickCenter;	
	
	// Distance the joystick has been moved from its center
	float joystickDistance;		
	
	// Holds the unique hash value given to a touch on the joystick  
	int joystickTouchHash;		
	
	// This allows us to track the same touch during touchesMoved events
	BOOL isJoystickTouchMoving;	
	
	float joystickMaxRadius;
	CGPoint joystickCapPosition;
	float capWidth, capHeigth;
	
	//the game is landscape?
	bool isLandscape;  
}

@property (nonatomic, readwrite) bool isLandscape;  
@property (nonatomic, readwrite) float joystickDistance;
@property (nonatomic, readwrite) float movementDirection;

- (id) initJoystickImage:(Image *)sprtImage 
		PosScreenAndSize:(CGRect)posscreenSize 
				 SizeCap:(CGSize)sizeCap
				AtlasPos:(CGSize)atlasPos 
			 AtlasPosCap:(CGSize)atlasPosCap  
				   Alpha:(float)alphaValue
	 drawOnlyJoystickCap:(bool)drawjoystick
			   Landscape:(bool)landscape;

- (void)DrawJoystick;

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;

@end
