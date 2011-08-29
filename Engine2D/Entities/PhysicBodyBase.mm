//
//  PhysicBodyBase.mm
//  Engine2D
//
//  Created by Alejandro Perez Perez on 23/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicBodyBase.h"
#import "SpriteBase.h"


@implementation PhysicBodyBase

@synthesize bodyDef;
@synthesize body;
@synthesize dynamicBox;
@synthesize circle;


//values for this init method
//possible definition for bodies
//-b2_kinematicBody
//-b2_dynamicBody
//-b2_staticBody
//cgrect body size and position of this physic body
//handlerclass, the class that holds the information for this body, all bodies are sprites
//physicworld, the master class to handle all the physics world
- (id) init:(b2BodyType)bodydef TypeShape:(bodyTpes)typeshape FixedRotation:(bool)fixedrotation BodySizeAndPos:(CGRect)bodysizeandpos HandlerClass:(SpriteBase *)handlerClass Physic:(PhysicsWorld*)world
{
	self = [super init];
	if (self != nil) {
		//
		//physics part
		//
		// Create a body definition and set it to be a dynamic body
		bodyDef.type = bodydef;
		
		// position must be converted to meters and centered to the sprite, sprites anchor point start always in 0,0 (top-left)
		bodyDef.position = [world toMeters:CGPointMake(bodysizeandpos.origin.x + bodysizeandpos.size.width/2, bodysizeandpos.origin.y + bodysizeandpos.size.height/2)];
        
		// assign the sprite as userdata so it's easy to get to the sprite when working with the body
		bodyDef.userData = handlerClass;
		
		//this body will have always a fixed rotation or not
		bodyDef.fixedRotation = fixedrotation;
		
		//assign the body to the world
		body = world._world->CreateBody(&bodyDef);
		
		float tileInMetersX = 0;
		float tileInMetersY = 0;
		b2FixtureDef fixtureDef;
		
		switch (typeshape) {
			case BOX:
				// Define a box shape for our dynamic body.
				tileInMetersX = bodysizeandpos.size.width / PTM_RATIO;
				tileInMetersY = bodysizeandpos.size.height / PTM_RATIO;
				dynamicBox.SetAsBox(tileInMetersX*0.5f, tileInMetersY*0.5f);
				
				// Define the dynamic body fixture
				fixtureDef.shape = &dynamicBox;	
				fixtureDef.density = 2.0f;
				fixtureDef.friction = 0.4f;
				fixtureDef.restitution = 0.1f;
				body->CreateFixture(&fixtureDef);
				break;
				
			case CIRCLE:
				circle.m_radius = bodysizeandpos.size.width/PTM_RATIO;
				fixtureDef.shape = &circle;	
				fixtureDef.density = 1.0f;
				fixtureDef.friction = 0.3f;
				fixtureDef.restitution = 0.8f;
				body->CreateFixture(&fixtureDef);
				break;
				
			default:
				break;
		}
		
	}
	return self;
}



// release resources when they are no longer needed.
- (void)dealloc
{
	[super dealloc];
}




@end

