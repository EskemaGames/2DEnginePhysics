//
//  EngineAppDelegate.m
//  
//
//  Created by Alejandro Perez Perez on 01/03/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "EngineAppDelegate.h"
#import "EAGLView.h"

@implementation EngineAppDelegate

@synthesize window;
@synthesize glView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
	
	[glView startAnimation];
}




- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

@end
