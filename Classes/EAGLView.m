//
//  EAGLView.m
//  
//
//  Created by Alejandro Perez Perez on 01/03/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"
#import "defines.h"



// A class extension to declare private methods
@interface EAGLView ()



@property (nonatomic, retain) EAGLContext *context;


- (void) update:(float)deltaTime;
- (void) initGame;
- (void) initOpenGL;

@end


@implementation EAGLView



@synthesize context;


// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
	
	if ((self = [super initWithCoder:coder])) {
		// Get the layer
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		eaglLayer.opaque = TRUE;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, nil];
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if (!context || ![EAGLContext setCurrentContext:context]) {
			[self release];
			return nil;
		}
		
		
		//detect ipad or iphone screen
		if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
		   UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			isIpad = YES;
		}
		else {
			isIpad = NO;
		}
		
		//start with no retina, we'll detect it later
		isRetinaDisplay = NO;
		
		
		// Get the bounds of the main screen
		//by default the screen is always in portrait
		//we want to override this values with the define LANDSCAPE
		//to choose the orientation we want and then update this value here
		viewport = [[UIScreen mainScreen] bounds];
		
		// Set up the ability to track multiple touches.
		[self setMultipleTouchEnabled:YES];
		
		// Go and initialise the game entities and graphics etc
		if(!GameInit) {
			[self initGame];
		}
		
		
		
		// Observe orientation change notifications
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
		
		
		
		
		glGenFramebuffersOES(1, &defaultFramebuffer);
		glGenRenderbuffersOES(1, &colorRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
		
		
	}
	return self;
}








- (void)initGame {
	
	// If OpenGL has not yet been initialised then go and initialise it
	if(!glInitialised) {
		[self initOpenGL];
	}
	//states
	States = [StateManager sharedStateManager];
	[States initStates:ISLANDSCAPE];
	States.isIpad = isIpad;
	States.isRetinaDisplay = isRetinaDisplay;
	States.screenBounds = Vector2fMake(viewport.size.width, viewport.size.height);
	
	//default values are loaded, so mark it
	GameInit = YES;
	
}











- (void)update:(float)deltaTime 
{
	// Create variables to hold the current time and calculated delta
	CFTimeInterval		time;
	
	// Get the current time and calculate the delta between the lasttime and now
	time = CACurrentMediaTime();
	delta = time - lastTime;
	
	//calculate movement speed
	States.SpeedFactor = delta;
	
	// Calculate the FPS
	_FPS += delta;
	if(_FPS > 1.0f) {
		_FPS = 0;
		float _fps = (1.0f / (States.SpeedFactor));
		// Set the FPS in the statemanager
		States._FPS = _fps;
	}
	
	// Set the lasttime to the current time ready for the next pass
	lastTime = time;
	
	[States updateScene:deltaTime];
	
}







- (void)renderScene 
{
	
	//update game
	[self update:delta];
	
	//draw our game
	[States DrawScene];
	
	//bind buffer and render to screen
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
	
}











- (void)initOpenGL {
	
    //  Modify the Projection matrix  
    glMatrixMode(GL_PROJECTION);  
    glLoadIdentity();  
	
    //  
    //  Orthof projection is used for 2d games. This sets the coordinates to  
    //  (0, 0) at the top left corner of the screen, and as you move downward  
    //  your y value will increase. As you move to the right, your x value will  
    //  increase.  
    //  (left, right, bottom, top, near, far)  
    //  
    //  If the game is going to be played in landscape mode, enable  
    //  it via the bool switch in the touches manager file.  
	if(	ISLANDSCAPE)
    {  
		if (isIpad)
			viewport = CGRectMake(0, 0, 1024, 768);
		else {
			viewport = CGRectMake(0, 0,  480, 320);
		}
		
		if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
			CGFloat scale = [[UIScreen mainScreen] scale];
			if (scale > 1.0) {
				glViewport(0, 0, viewport.size.height * scale, viewport.size.width * scale);  
				glRotatef(-90, 0, 0, 1);  
				glOrthof(0, viewport.size.width * scale, viewport.size.height * scale, 0, -1.0, 1.0);
				isRetinaDisplay = YES;
				screenScale = scale;
			}
			else {
				screenScale = scale;
				isRetinaDisplay = NO;
				glViewport(0, 0, viewport.size.height, viewport.size.width);  
				glRotatef(-90, 0, 0, 1);  
				glOrthof(0, viewport.size.width, viewport.size.height, 0, -1.0, 1.0);
			}
			
		}  
    }  
    else    //  Game is to be played in portrait  
    {  
		if (isIpad)
			viewport = CGRectMake(0, 0, 768, 1024);
		else {
			viewport = CGRectMake(0, 0, 320, 480);
		}
		
		if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
			CGFloat scale = [[UIScreen mainScreen] scale];
			if (scale > 1.0) {
				glViewport(0, 0, viewport.size.width * scale, viewport.size.height * scale);  
				glOrthof(0.0, viewport.size.width * scale, viewport.size.height * scale, 0.0, -1.0, 1.0); 
				isRetinaDisplay = YES;
				screenScale = scale;
			}
			else {
				isRetinaDisplay = NO;
				screenScale = scale;
				glViewport(0, 0, viewport.size.width, viewport.size.height);  
				glOrthof(0.0, viewport.size.width, viewport.size.height, 0.0, -1.0, 1.0);
			}
			
		}
    }    
	
	
    //  
    //  Setup Model view matrix  
    //  Load graphics settings  
    //  
    glMatrixMode(GL_MODELVIEW);  
    glDisable(GL_DEPTH_TEST);  
	
	
    //  needed to draw textures using Texture2D
	glEnable(GL_TEXTURE_2D);  
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);  
    glEnableClientState(GL_VERTEX_ARRAY);  
	glEnableClientState(GL_COLOR_ARRAY);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
    glLoadIdentity();  
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f); 
	
	
	// Mark OGL as initialised
	glInitialised = YES;
}


- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer
{	
	
	// Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
	
	
    return YES;
}


- (void) layoutSubviews
{
	[self resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self renderScene];
}


- (void)startAnimation:(UIApplication*)application {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	
	const double SecondsPerFrame = 1.0 / (((kFPS) > 60.0)? 60.0: (kFPS));
	const double OneMillisecond = 1.0 / 1000.0;
	for (;;)
	{
		double frameStartTime = (double)CFAbsoluteTimeGetCurrent();
		[self performSelectorOnMainThread:@selector(renderScene) withObject:nil waitUntilDone:YES]; 
		
		double secondsToProcessEvents = SecondsPerFrame - (((double)CFAbsoluteTimeGetCurrent()) - frameStartTime);
		// if we run considerably slower than desired framerate anyhow
		// then we should sleep for a while leaving OS some room to process events
		if (secondsToProcessEvents < -OneMillisecond)
			secondsToProcessEvents = OneMillisecond;
		if (secondsToProcessEvents > 0)
			[NSThread sleepForTimeInterval:secondsToProcessEvents];
	}
	
	
	[pool release];
	
}


-(void)StartGame
{
	[NSThread detachNewThreadSelector:@selector(startAnimation:) toTarget:self withObject:nil];
}





- (void)dealloc {
	
	
	// Tear down GL
	if (defaultFramebuffer)
	{
		glDeleteFramebuffersOES(1, &defaultFramebuffer);
		defaultFramebuffer = 0;
	}
	
	if (colorRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &colorRenderbuffer);
		colorRenderbuffer = 0;
	}
	
	// Tear down context
	if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
	[context release];
	context = nil;
	
	[super dealloc];
	
	
}




- (void) orientationChanged:(NSNotification *)notification {
	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	/*if (orientation == UIDeviceOrientationLandscapeRight) {
	 States.interfaceOrientation = UIInterfaceOrientationLandscapeRight;
	 States.input.isLandscape = YES;
	 States.input.upsideDown = NO;
	 glMatrixMode(GL_PROJECTION);  
	 glLoadIdentity();  
	 if (isIpad)
	 viewport = CGRectMake(0, 0, 1024, 768);
	 else {
	 viewport = CGRectMake(0, 0, 480, 320);
	 }
	 
	 if (isRetinaDisplay)
	 {
	 if (States)
	 States.screenBounds = Vector2fMake(viewport.size.width, viewport.size.height);
	 glViewport(0, 0, viewport.size.height * screenScale, viewport.size.width * screenScale);  
	 glRotatef(90, 0, 0, 1);  
	 glOrthof(0, viewport.size.width * screenScale, viewport.size.height * screenScale, 0, -1.0, 1.0);    
	 }
	 else {
	 if (States)
	 States.screenBounds = Vector2fMake(viewport.size.width, viewport.size.height);
	 glViewport(0, 0, viewport.size.height, viewport.size.width);  
	 glRotatef(90, 0, 0, 1);  
	 glOrthof(0, viewport.size.width, viewport.size.height, 0, -1.0, 1.0);
	 }
	 
	 glMatrixMode(GL_MODELVIEW);  
	 glLoadIdentity(); 
	 }
	 
	 if (orientation == UIDeviceOrientationLandscapeLeft) {
	 States.interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
	 States.input.isLandscape = YES;
	 States.input.upsideDown = NO;
	 glMatrixMode(GL_PROJECTION);  
	 glLoadIdentity();  
	 if (isIpad)
	 viewport = CGRectMake(0, 0, 1024, 768);
	 else {
	 viewport = CGRectMake(0, 0, 480, 320);
	 }
	 
	 if (isRetinaDisplay)
	 {
	 if (States)
	 States.screenBounds = Vector2fMake(viewport.size.width, viewport.size.height);
	 glViewport(0, 0, viewport.size.height * screenScale, viewport.size.width * screenScale);  
	 glRotatef(-90, 0, 0, 1);  
	 glOrthof(0, viewport.size.width * screenScale, viewport.size.height * screenScale, 0, -1.0, 1.0);    
	 }
	 else {
	 if (States)
	 States.screenBounds = Vector2fMake(viewport.size.width, viewport.size.height);
	 glViewport(0, 0, viewport.size.height, viewport.size.width);  
	 glRotatef(-90, 0, 0, 1);  
	 glOrthof(0, viewport.size.width, viewport.size.height, 0, -1.0, 1.0); 
	 }
	 
	 glMatrixMode(GL_MODELVIEW);  
	 glLoadIdentity(); 
	 
	 }
	 */
	
	
	
	if (orientation == UIDeviceOrientationPortrait) {
		States.interfaceOrientation = UIInterfaceOrientationPortrait;
		States.input.isLandscape = NO;
		States.input.upsideDown = NO;
		glMatrixMode(GL_PROJECTION);  
		glLoadIdentity(); 
		if (isIpad)
			viewport = CGRectMake(0, 0, 768, 1024);
		else {
			viewport = CGRectMake(0, 0, 320, 480);
		}
		
		if (isRetinaDisplay)
		{
			if (States)
				States.screenBounds = Vector2fMake(viewport.size.width, viewport.size.height);
			glViewport(0, 0, viewport.size.width * screenScale, viewport.size.height * screenScale);  
			glOrthof(0.0, viewport.size.width * screenScale, viewport.size.height * screenScale, 0.0, -1.0, 1.0); 
		}
		else {
			if (States)
				States.screenBounds = Vector2fMake(viewport.size.width, viewport.size.height);
			glViewport(0, 0, viewport.size.width, viewport.size.height ); 
			glOrthof(0.0, viewport.size.width, viewport.size.height , 0.0, -1.0, 1.0); 
		}
		
		glMatrixMode(GL_MODELVIEW);  
		glLoadIdentity(); 
	}
	
	if (orientation == UIDeviceOrientationPortraitUpsideDown) {
		States.interfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
		States.input.isLandscape = NO;
		States.input.upsideDown = YES;
		glMatrixMode(GL_PROJECTION);  
		glLoadIdentity(); 
		if (isIpad)
			viewport = CGRectMake(0, 0, 768, 1024);
		else {
			viewport = CGRectMake(0, 0, 320, 480);
		}
		
		if (isRetinaDisplay)
		{
			if (States)
				States.screenBounds = Vector2fMake(viewport.size.width, viewport.size.height);
			glViewport(0, 0, viewport.size.width * screenScale, viewport.size.height * screenScale);  
			glRotatef(-180, 0, 0, 1);  
			glOrthof(0, viewport.size.width * screenScale, viewport.size.height * screenScale, 0.0,  -1.0, 1.0); 
		}
		else {
			if (States)
				States.screenBounds = Vector2fMake(viewport.size.width, viewport.size.height);
			glViewport(0, 0, viewport.size.width, viewport.size.height);  
			glRotatef(-180, 0, 0, 1);  
			glOrthof(0, viewport.size.width, viewport.size.height, 0.0,  -1.0, 1.0);
		}
		
		glMatrixMode(GL_MODELVIEW);  
		glLoadIdentity(); 
		
	}
	
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    [States.input touchesBegan:touches withEvent:event InView:self];
	[States.joystick touchesBegan:touches withEvent:event view:self];
}  

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    [States.input touchesMoved:touches withEvent:event InView:self];  
	[States.joystick touchesMoved:touches withEvent:event view:self];

}  

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    [States.input touchesEnded:touches withEvent:event InView:self]; 
	[States.joystick touchesEnded:touches withEvent:event view:self];

}  

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    [States.input touchesCancelled:touches withEvent:event InView:self];  
}


@end
