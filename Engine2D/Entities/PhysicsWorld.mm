//
//  PhysicsWorld.m
//  Engine2D
//
//  Created by Alejandro Perez Perez on 22/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsWorld.h"
#import "SpriteBase.h"
#import "BaseActor.h"


@implementation PhysicsWorld

@synthesize world;
@synthesize collisions;


- (id) init:(StateManager *)States_ SleepBodies:(bool)SleepBodies
{  
	self = [super init];
	if (self != nil) {
		
		gameState = States_;
		
		//opengl have coordinates 0,0 from bottom left corner, I'm using 0,0 in top left corner
		//so gravity must be inverted, 10 means down, -10 means up
		b2Vec2 gravity = b2Vec2(0.0f, 10.0f);

		world = new b2World(gravity, SleepBodies);
		
		//set the collisions callback
		collisions = new BoxCollisionCallback(); 
		world->SetContactListener(collisions);
		
		// Define the static container body, which will provide the collisions at screen borders.
		b2BodyDef containerBodyDef;
		b2Body* containerBody = world->CreateBody(&containerBodyDef);
		
		// for the ground body we'll need these values
		float widthInMeters = gameState.screenBounds.x / PTM_RATIO;
		float heightInMeters = gameState.screenBounds.y / PTM_RATIO;
		b2Vec2 lowerLeftCorner = b2Vec2(0, heightInMeters);
		b2Vec2 lowerRightCorner = b2Vec2(widthInMeters, heightInMeters);
		b2Vec2 upperLeftCorner = b2Vec2(0,0); 
		b2Vec2 upperRightCorner = b2Vec2(widthInMeters, 0);
		
		// Create the screen box' sides by using a polygon assigning each side individually.
		b2PolygonShape screenBoxShape;
		int density = 0;
		
		// bottom
		screenBoxShape.SetAsEdge(lowerLeftCorner, lowerRightCorner);
		containerBody->CreateFixture(&screenBoxShape, density);
		
		// top
		screenBoxShape.SetAsEdge(upperLeftCorner, upperRightCorner);
		containerBody->CreateFixture(&screenBoxShape, density);
		
		// left side
		screenBoxShape.SetAsEdge(upperLeftCorner, lowerLeftCorner);
		containerBody->CreateFixture(&screenBoxShape, density);
		
		// right side
		screenBoxShape.SetAsEdge(upperRightCorner, lowerRightCorner);
		containerBody->CreateFixture(&screenBoxShape, density);
		
	}
	return self;
}



-(void)Update
{
	//update the physics world
	float timeStep = 0.03f;
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	world->Step(timeStep, velocityIterations, positionIterations);
	
	// for each body, get its assigned sprite and update the sprite's position
	for (b2Body* body = world->GetBodyList(); body != nil; body = body->GetNext())
	{

		SpriteBase *actor = (SpriteBase*)body->GetUserData();
		if (actor != NULL)
		{
			// update the sprite's position to where their physics bodies are
			CGPoint t_point = [self toPixels:body->GetPosition()];
			actor.position = Vector2fMake(t_point.x, t_point.y);
			float angle = body->GetAngle();
			actor.rotation = RADIANS_TO_DEGREES(angle) * -1;
		}	
	}
}

// convenience method to convert a CGPoint to a b2Vec2
-(b2Vec2) toMeters:(CGPoint)point
{
	return b2Vec2(point.x / PTM_RATIO, point.y / PTM_RATIO);
}

// convenience method to convert a b2Vec2 to a CGPoint
-(CGPoint) toPixels:(b2Vec2)vec
{
	Vector2f tmp = Vector2fMultiply(Vector2fMake(vec.x, vec.y), PTM_RATIO);
	CGPoint t1 = CGPointMake(tmp.x, tmp.y);
	return t1;
	
}

- (void) dealloc
{
	delete collisions;
	delete world;
	[super dealloc];
}




@end