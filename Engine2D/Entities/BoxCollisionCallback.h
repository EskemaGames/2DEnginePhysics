//
//  BoxCollisionCallback.mm
//  Engine2D
//
//  Created by Alejandro Perez Perez on 22/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"

class BoxCollisionCallback : public b2ContactListener
{
private:
	void BeginContact(b2Contact* contact);
	void EndContact(b2Contact* contact);
};