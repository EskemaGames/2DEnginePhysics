//
//  Texture2D.h
//  
//	Based on Apple's code
//
//  Created by Eskema on 04/03/2009.
//  Copyright 2009 Eskema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>



//CLASS INTERFACES:


@interface Texture2D : NSObject
{
	
	GLuint						_name;
	CGSize						_size;
	NSUInteger					_width,
	_height;
	GLfloat						_maxS,
	_maxT;
	
}


@property(readonly) NSUInteger pixelsWide;
@property(readonly) NSUInteger pixelsHigh;
@property(readonly) GLuint name;
@property(readonly, nonatomic) CGSize contentSize;
@property(readonly) GLfloat maxS;
@property(readonly) GLfloat maxT;


- (id) initWithData:(const void*)data  pixelsWide:(NSUInteger)width pixelsHigh:(NSUInteger)height contentSize:(CGSize)size   filter:(GLenum)filter Use32bits:(bool)use32bits;
- (id) initWithImage:(UIImage *)uiImage  filter:(GLenum)filter  Use32bits:(bool)use32bits;
@end




@interface Texture2D (PVRTC)
//Initializes a texture from a PVRTC buffer 
-(id) initWithPVRTCData: (const void*)data  HasAlpha:(bool)hasAlpha  length:(int)length  filter:(GLenum)filter;

@end

