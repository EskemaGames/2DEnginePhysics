//
//  BoxCollisionCallback.mm
//  Engine2D
//
//  Created by Alejandro Perez Perez on 22/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BoxCollisionCallback.h"
#import "SpriteBase.h"


//
// you must customize these callbacks in order to apply
// the desired effect for the collisions, like loose one life or whatever
//
void BoxCollisionCallback::BeginContact(b2Contact* contact)
{
	b2Body* bodyA = contact->GetFixtureA()->GetBody();
	b2Body* bodyB = contact->GetFixtureB()->GetBody();
	SpriteBase *actor1 = (SpriteBase*)bodyA->GetUserData();
	SpriteBase *actor2 = (SpriteBase*)bodyB->GetUserData();

	
	if (actor1 != NULL && actor2 != NULL)
	{
		NSLog(@"touched");
	}
	 
}


void BoxCollisionCallback::EndContact(b2Contact* contact)
{
	b2Body* bodyA = contact->GetFixtureA()->GetBody();
	b2Body* bodyB = contact->GetFixtureB()->GetBody();
	SpriteBase *actor1 = (SpriteBase*)bodyA->GetUserData();
	SpriteBase *actor2 = (SpriteBase*)bodyB->GetUserData();
	
	if (actor1 != NULL && actor2 != NULL)
	{
		NSLog(@"end touched");
	}
	 
}
