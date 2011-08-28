//
//  ActionPoint.m
// 
//
//  Created by Alejandro Perez Perez on 16/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionPoint.h"


@implementation ActionPoint

@synthesize m_speed;
@synthesize m_entityPoint;

@synthesize _duration;
@synthesize oldDuration;
@synthesize distX, distY;
@synthesize from_;
@synthesize to_;
@synthesize delta_;


- (id) init
{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}


- (void) dealloc
{
	[super dealloc];
}



@end
