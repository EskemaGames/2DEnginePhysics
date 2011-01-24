//
//  PhysicsWorld.h
//  Engine2D
//
//  Created by Alejandro Perez Perez on 22/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StateManager.h"
#import "Box2D.h"
#import "BoxCollisionCallback.h"


@interface PhysicsWorld : NSObject {

	//game states needed to get screen resolution
	StateManager *gameState;
	
	//physics world
	b2World* world;
	
	//collisions
	BoxCollisionCallback *collisions;
}


@property (readwrite) b2World *world;
@property (readwrite) BoxCollisionCallback *collisions;


//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================
-(id) init:(StateManager *)States_ SleepBodies:(bool)SleepBodies;
-(void)Update;
-(b2Vec2) toMeters:(CGPoint)point;
-(CGPoint) toPixels:(b2Vec2)vec;

@end
