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
#import "GLES-Render.h"


@interface PhysicsWorld : NSObject {
	
	GLESDebugDraw *_debugDraw;
	
	
	//game states needed to get screen resolution
	StateManager *gameState;
	
	//physics world
	b2World* _world;
	
	//collisions
	BoxCollisionCallback *_collisions;
}


@property (readwrite) b2World *_world;
@property (readwrite) BoxCollisionCallback *_collisions;


//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================
-(id) initSleepBodies:(bool)SleepBodies;
-(void)Update;
-(void) draw;
-(b2Vec2) toMeters:(CGPoint)point;
-(CGPoint) toPixels:(b2Vec2)vec;

@end
