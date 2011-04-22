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
@synthesize _position, _size, _offset, _scale;
@synthesize _speed, _flip;
@synthesize _rotation;



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
	[sprtImg release];
	physicBody = nil;
	[physicBody release];
	free(cachedTexture);
	free(textureCoordinates);
	free(mvertex);
	[super dealloc];
}














@end

