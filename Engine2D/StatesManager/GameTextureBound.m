//
//  
//  
//
//  Created by Eskema on 16/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameTextureBound.h"

@implementation GameTextureBound

@synthesize currentlyBoundTexture;

// This var will hold our Singleton class instance that will be handed to anyone who asks for it
static GameTextureBound *sharedGameStateInstance = nil;

// Class method which provides access to the shareGameStateInstance var.
+ (GameTextureBound *)sharedGameStateInstance {
	
	// synchronized is used to lock the object and handle multiple threads accessing this method at
	// the same time
	@synchronized(self) {
		
		// If the sharedGameStateInstance var is nil then we need to allocate it.
		if(sharedGameStateInstance == nil) {
			// Allocate and initialize an instance of this class
			sharedGameStateInstance = [[self alloc] init];
		}
	}
	
	// Return the sharedGameStateInstance
	return sharedGameStateInstance;
}

// This is called when you alloc an object.  To protect against instances of this class being
// allocated outside of the sharedGameStateInstance method, this method checks to make sure
// that the sharedGameStateInstance is nil before allocating and initializing it.  If it is not
// nil then nil is returned and the instance would need to be obtained through the sharedGameStateInstance method
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedGameStateInstance == nil) {
            sharedGameStateInstance = [super allocWithZone:zone];
            return sharedGameStateInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
} 

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end


