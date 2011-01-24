//
//  PhysicBodyBase.h
//  Engine2D
//
//  Created by Alejandro Perez Perez on 23/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



/*
 *
 *
 for now this class is limited to boxes
 in a future I will add more shapes
 *
 *
 */



#import <Foundation/Foundation.h>
#import "PhysicsWorld.h"
@class SpriteBase;

@interface PhysicBodyBase : NSObject   
{  

	//definition of the physic body
	//the body itself
	//and the shape
	b2BodyDef bodyDef;
	b2Body* body;
	b2PolygonShape dynamicBox;
	b2CircleShape circle;
}


- (id) init:(b2BodyType)bodydef TypeShape:(bodyTpes)typeshape FixedRotation:(bool)fixedrotation BodySizeAndPos:(CGRect)bodysizeandpos HandlerClass:(SpriteBase *)handlerClass Physic:(PhysicsWorld*)world;


@property (readwrite) b2BodyDef bodyDef;
@property (readwrite) b2Body *body;
@property (readwrite) b2PolygonShape dynamicBox;
@property (readwrite) b2CircleShape circle;

@end
