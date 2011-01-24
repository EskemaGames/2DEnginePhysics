//
//  Inputstates.m
//  
//
//  Created by Eskema on 15/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InputState.h"


//  
//  Implementation of InputState  
//  
@implementation InputState  

@synthesize isBeingTouched;  
@synthesize touchLocation;  

- (id) init  
{  
    self = [super init];  
    if (self != nil) {  
        isBeingTouched = NO;  
        touchLocation = CGPointMake(0, 0);  
    }  
    return self;  
}  

@end
