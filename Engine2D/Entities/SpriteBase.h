//
//  SpriteBase.h
//  Engine2D
//
//  Created by Alejandro Perez Perez on 23/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "PhysicBodyBase.h"


@interface SpriteBase : NSObject {

	PhysicBodyBase *physicBody;
	
	//enable or not physics
	bool physicsEnabled;
	
	//variables
	Vector2f position;
	Vector2f size;
	
	float speed; //speed to move sprite
	
	int flip; //used to flip sprite left/right/up/down
	float rotation; //maybe we want to rotate the sprite
	
	// Array used to store texture coords and vertices info for rendering
	Quad2f *cachedTexture;
	Quad2f *textureCoordinates;
	Quad2f *mvertex;
}


@property (nonatomic, readwrite) Quad2f *cachedTexture;
@property (nonatomic, readwrite) Quad2f *textureCoordinates;
@property (nonatomic, readwrite) Quad2f *mvertex;

@property (retain) PhysicBodyBase *physicBody;
@property (nonatomic, readwrite) Vector2f position, size;
@property (nonatomic, readwrite) int flip;
@property (nonatomic, readwrite) float rotation, speed;
@property (nonatomic, readwrite) bool physicsEnabled;

//each derived class must implement this values as they wish
//this is only a base to handle a sprite reference


@end
