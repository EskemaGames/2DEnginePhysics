//
//  SpriteBase.h
//  Engine2D
//
//  Created by Alejandro Perez Perez on 23/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonEngine.h"
#import "PhysicBodyBase.h"
#import "Image.h"


@interface SpriteBase : NSObject {
	
	PhysicBodyBase *physicBody;
	
	//enable or not physics
	bool physicsEnabled;
	
	//variables
	Vector2f _position;
	Vector2f _size;
	Vector2f _offset;
	float _speed; //speed to move sprite
	Vector2f _scale;
	
	int _flip; //used to flip sprite left/right/up/down
	float _rotation; //maybe we want to rotate the sprite
	
	//image for all sprites derived from this class
	Image *sprtImg;
	
	// Array used to store texture coords and vertices info for rendering
	Quad2f *cachedTexture;
	Quad2f *textureCoordinates;
	Quad2f *mvertex;
}


@property (nonatomic, readwrite) Quad2f *cachedTexture;
@property (nonatomic, readwrite) Quad2f *textureCoordinates;
@property (nonatomic, readwrite) Quad2f *mvertex;

@property (retain) PhysicBodyBase *physicBody;
@property (nonatomic, readwrite) Vector2f _position, _size, _offset, _scale;
@property (nonatomic, readwrite) int _flip;
@property (nonatomic, readwrite) float _rotation, _speed;
@property (nonatomic, readwrite) bool physicsEnabled;

//each derived class must implement this values as they wish
//this is only a base to handle a sprite reference


@end
