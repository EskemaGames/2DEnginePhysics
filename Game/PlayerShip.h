//
//  PlayerShip.h
//  test
//
//  Created by Alejandro Perez Perez on 05/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseActor.h"

//forward declaration for physics class
@class PhysicsWorld;


@interface PlayerShip : BaseActor {

	bool MoveLeft, MoveRight, MoveUp, MoveDown;
}



//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================
-(id) initImage:(Image *)Spriteimage FileName:(NSString *)_filename Physic:(PhysicsWorld*)world TypeShape:(bodyTpes)typeshape;
-(void) Update:(float)deltaTime Touchlocation:(CGPoint)Touchlocation;
-(void) Draw:(Color4f)_colors;

-(void) StateStopped;
-(void) StateWalking;

@end
