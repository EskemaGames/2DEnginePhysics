//
//  ParticleEmitter.h
//  
//
//  Created by Michael Daley on 17/04/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "CommonEngine.h"
#import "Image.h"
#import "GameTextureBound.h"

// Particle type
enum kParticleTypes {
	kParticleTypeGravity,
	kParticleTypeRadial
};



#define MAXIMUM_UPDATE_RATE 90.0f	// The maximum number of updates that occur per frame


@protocol ParticleManagerProtocol

-(void) onEmitterEnded;

@end







// The particleEmitter allows you to define parameters that are used when generating particles.
// These particles are OpenGL particle sprites that based on the parameters provided each have
// their own characteristics such as speed, lifespan, start and end colors etc.  Using these
// particle emitters allows you to create organic looking effects such as smoke, fire and 
// explosions.
//
// The design for this particle emitter was influenced by the point sprite particle system
// used in the Cocos2D game engine
//
@interface ParticleEmitter : NSObject {
	
	/////////////////// Singleton Managers
	GameTextureBound *_sharedTexture;
	
	
	/////////////////// Particle iVars
	Image *texture;
	
	/////////////////// Particle iVars
    int emitterType;												
	Vector2f sourcePosition, sourcePositionVariance;			
	GLfloat angle, angleVariance;								
	GLfloat speed, speedVariance;	
    GLfloat radialAcceleration, tangentialAcceleration;
    GLfloat radialAccelVariance, tangentialAccelVariance;
	Vector2f gravity;	
	GLfloat particleLifespan, particleLifespanVariance;			
	Color4f startColor, startColorVariance;						
	Color4f finishColor, finishColorVariance;
	GLfloat startParticleSize, startParticleSizeVariance;
	GLfloat finishParticleSize, finishParticleSizeVariance;
	GLuint maxParticles;
	GLint particleCount;
	GLfloat emissionRate;
	GLfloat emitCounter;	
	GLfloat elapsedTime;
	GLfloat duration;
    
	int blendFuncSource, blendFuncDestination;
	
	//////////////////// Particle ivars only used when a maxRadius value is provided.  These values are used for
	//////////////////// the special purpose of creating the spinning portal emitter
	GLfloat maxRadius;						// Max radius at which particles are drawn when rotating
	GLfloat maxRadiusVariance;				// Variance of the maxRadius
	GLfloat radiusSpeed;					// The speed at which a particle moves from maxRadius to minRadius
	GLfloat minRadius;						// Radius from source below which a particle dies
	GLfloat rotatePerSecond;				// Numeber of degress to rotate a particle around the source pos per second
	GLfloat rotatePerSecondVariance;		// Variance in degrees for rotatePerSecond
	
	//////////////////// Particle Emitter iVars
	BOOL active;
	BOOL useTexture;
	GLint particleIndex;		// Stores the number of particles that are going to be rendered
	
	
	///////////////////// Render
	GLuint verticesID;			// Holds the buffer name of the VBO that stores the color and vertices info for the particles
	Particle *particles;		// Array of particles that hold the particle emitters particle details
	PointSprite *vertices;		// Array of vertices and color information for each particle to be rendered
	
	id<ParticleManagerProtocol> delegate;
	
	
}

@property(nonatomic, retain) id<ParticleManagerProtocol> delegate;
@property(nonatomic, assign) Vector2f sourcePosition;
@property(nonatomic, assign) GLint particleCount;
@property(nonatomic, assign) BOOL active;
@property(nonatomic, assign) GLfloat duration;
//@property(nonatomic, readwrite) GLfloat angle;

// Initialises a particle emitter using configuration read from a file
- (id)initParticleEmitterWithFile:(NSString*)aFileName;

// Renders the particles for this emitter to the screen
- (void)renderParticles;

// Updates all particles in the particle emitter
- (void)updateWithDelta:(GLfloat)aDelta;
- (void)updateWithDelta:(GLfloat)aDelta CameraPosition:(Vector2f)_camerapos;

// Stops the particle emitter
- (void)stopParticleEmitter;

@end




