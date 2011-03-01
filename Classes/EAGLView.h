//
//  EAGLView.h
//  
//
//  Created by Alejandro Perez Perez on 01/03/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>




#import "StateManager.h"
#import "InputManager.h"


/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
 This class only use cadisplay link, and this will only work on sdk 3.1 and superior
*/
@interface EAGLView : UIView {
    
@private
	EAGLContext *context;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint backingWidth;
	GLint backingHeight;
	
	//set the flag to control the screen resolution
	bool isIpad;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer, colorRenderbuffer;
	

	
	NSInteger animationFrameInterval;
	// Use of the CADisplayLink class is the preferred method for controlling your animation timing.
	// CADisplayLink will link to the main display and fire every vsync when added to a given run-loop.
	// The NSTimer class is used only as fallback when running on a pre 3.1 device where CADisplayLink
	// isn't available.
	id displayLink;
	
	BOOL animating;
	
	// Time since the last frame was rendered 
	CFTimeInterval lastTime;
	

	// State to define if OGL has been initialised or not 
	bool glInitialised;
	bool GameInit; 
	
	// Bounds of the current screen 
	CGRect viewport;
	

	float delta;
	//FPS counter
	float _FPS;
	
	
	//game states
	StateManager *States;

	
}





@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;
- (void)startAnimation;
- (void)stopAnimation;
- (void)renderScene;


//  
//  Touches events  
//  
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;  
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;  
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;  
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event; 



@end
