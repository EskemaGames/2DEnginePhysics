//
//  
//  
//
//  Created by Eskema on 16/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>

@interface GameTextureBound : NSObject {

	//Currently bound texture
	GLuint currentlyBoundTexture;
}

@property (nonatomic, assign) GLuint currentlyBoundTexture;

+ (GameTextureBound*)sharedGameStateInstance;



@end
