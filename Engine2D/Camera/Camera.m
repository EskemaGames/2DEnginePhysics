//
//
//  Camera.m
//  
//
//  Created by Eskema.
//  Copyright Eskema 2009. All rights reserved.
//




#import "Camera.h"
#import "StateManager.h"


@implementation Camera

@synthesize CameraX, CameraY;

//----------------------------------------------------------------------------
- (id) init  
{  
    self = [super init];  
    if (self != nil)  
    {  
		states = [StateManager sharedStateManager];
		CameraX = CameraY = 0;

	}
	return self;
}



//----------------------------------------------------------------------------
- (void) dealloc
{
	
	[super dealloc];
}



//move the camera along a position, this function is only to apply a camera for tilemaps
//position X,Y
//smoothmove = how smooth will be the movement
//totalmapwidth, height = the tilemap in pixels
-(void) MoveCamera2DX:(float)objx  Y:(float)objy  SmoothMove:(int)smoothmove  TotalMapWidth:(int)totalmap  TotalMapHeight:(int)totalmapHeight  TileSize:(int)TileSize
{

	CameraX += (objx - CameraX + (TileSize/2) - (states.screenBounds.x * 0.5f)) / smoothmove;
	CameraY += (objy - CameraY + (TileSize/2) - (states.screenBounds.y * 0.5f)) / smoothmove;
	
	
	if (CameraX <= 0){
		CameraX = 0;
	}
	
	if (CameraX >= totalmap - states.screenBounds.x){
		CameraX = totalmap - states.screenBounds.x;
	}
	
	if (CameraY <= 0){
		CameraY = 0;
	}
	
	if (CameraY >= totalmapHeight - states.screenBounds.y){
		CameraY = totalmapHeight - states.screenBounds.y;
	}

}





@end
