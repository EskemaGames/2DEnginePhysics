//
//
//  Camera.m
//  
//
//  Created by Eskema.
//  Copyright Eskema 2009. All rights reserved.
//


#define SCREENX 768
#define SCREENY 1024

#import "Camera.h"


@implementation Camera

@synthesize CameraX, CameraY;

//----------------------------------------------------------------------------
- (id) init  
{  
    self = [super init];  
    if (self != nil)  
    {  
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
	
	
	CameraX += (objx - CameraX + (TileSize/2) - SCREENX/2) / smoothmove;
	CameraY += (objy - CameraY + (TileSize/2) - SCREENY/2) / smoothmove;
	
	
	if (CameraX <= 0){
		CameraX = 0;
	}
	
	if (CameraX >= totalmap - SCREENX){
		CameraX = totalmap - SCREENX ;
	}
	
	if (CameraY <= 0){
		CameraY = 0;
	}
	
	if (CameraY >= totalmapHeight - SCREENY){
		CameraY = totalmapHeight - SCREENY ;
	}
	
	
	
}





@end
