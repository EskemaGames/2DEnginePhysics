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
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
		
		
		animating = FALSE;
		displayLink = nil;
		
		
		glGenFramebuffersOES(1, &defaultFramebuffer);
		glGenRenderbuffersOES(1, &colorRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
		glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
		glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);

	}
	return self;
}








- (void)initGame {
	
	// If OpenGL has not yet been initialised then go and initialise it
	if(!glInitialised) {
		[self initOpenGL];
	}
	//states
	States = [[StateManager alloc] initStates:LANDSCAPE];
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
	if(	LANDSCAPE)
    {  
        viewport = CGRectMake(0, 0, 480, 320);  
        glViewport(0, 0, viewport.size.height, viewport.size.width);  
        glRotatef(-90, 0, 0, 1);  
        glOrthof(0, viewport.size.width, viewport.size.height, 0, -1.0, 1.0);    
		
    }  
    else    //  Game is to be played in portrait  
    {  
        viewport = CGRectMake(0, 0, 320, 480);  
        glViewport(0, 0, viewport.size.width, viewport.size.height);  
        glOrthof(0.0, viewport.size.width, viewport.size.height, 0.0, -1.0, 1.0);     
		
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
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }

	
    return YES;
}


- (void) layoutSubviews
{
	[EAGLContext setCurrentContext:context];
	[self resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self renderScene];
}




- (void)startAnimation {
	if (!animating)
	{
		// CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
		// if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
		// not be called in system versions earlier than 3.1.
		displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(renderScene)];
		[displayLink setFrameInterval:animationFrameInterval];
		[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		
		animating = TRUE;
	}
	
	
	
}


- (void)stopAnimation {
	if (animating)
	{
		[displayLink invalidate];
		displayLink = nil;
		
		animating = FALSE;
	}
	
	
}



- (NSInteger) animationFrameInterval
{
	return animationFrameInterval;
}

- (void) setAnimationFrameInterval:(NSInteger)frameInterval
{
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
	if (frameInterval >= 1)
	{
		animationFrameInterval = frameInterval;
		
		if (animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
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
	if (orientation == UIDeviceOrientationLandscapeRight) {
		glMatrixMode(GL_PROJECTION);  
		glLoadIdentity();  
		viewport = CGRectMake(0, 0, 480, 320);  
        glViewport(0, 0, viewport.size.height, viewport.size.width);   
		glOrthof(0, viewport.size.width, viewport.size.height, 0, -1.0, 1.0);    
        glRotatef(90, 0, 0, 1);  
        glOrthof(0, viewport.size.width, viewport.size.height, 0, -1.0, 1.0);    
		glMatrixMode(GL_MODELVIEW);  
		glLoadIdentity(); 
	}
	
	if (orientation == UIDeviceOrientationLandscapeLeft) {
		glMatrixMode(GL_PROJECTION);  
		glLoadIdentity();  
		viewport = CGRectMake(0, 0, 480, 320);  
        glViewport(0, 0, viewport.size.height, viewport.size.width);    
		glOrthof(0, viewport.size.width, viewport.size.height, 0, -1.0, 1.0);    
        glRotatef(-90, 0, 0, 1);  
        glOrthof(0, viewport.size.width, viewport.size.height, 0, -1.0, 1.0);    
		glMatrixMode(GL_MODELVIEW);  
		glLoadIdentity(); 
		
	}
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    [States.input touchesBegan:touches withEvent:event InView:self];  
}  

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    [States.input touchesMoved:touches withEvent:event InView:self];  
}  

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    [States.input touchesEnded:touches withEvent:event InView:self];  
}  

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    [States.input touchesCancelled:touches withEvent:event InView:self];  
}


@end
