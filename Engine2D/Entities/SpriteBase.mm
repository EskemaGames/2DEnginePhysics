//
//  SpriteBase.mm
//  Engine2D
//
//  Created by Alejandro Perez Perez on 23/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpriteBase.h"


@implementation SpriteBase

@synthesize cachedTexture;
@synthesize textureCoordinates;
@synthesize mvertex;
@synthesize physicBody;
@synthesize physicsEnabled;
@synthesize position, size, offset;
@synthesize speed, flip;
@synthesize rotation;



- (id) init
{
	self = [super init];
	if (self != nil) {
	}
	return self;
}




// release resources when they are no longer needed.
- (void)dealloc
{
	sprtImg = nil;
	[physicBody release];
	free(cachedTexture);
	free(textureCoordinates);
	free(mvertex);
	[super dealloc];
}



@end

