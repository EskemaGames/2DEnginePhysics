//
//  Texture2D.h
//  
//	Based on Apple's code
//
//  Created by Eskema on 04/03/2009.
//  Copyright 2009 Eskema. All rights reserved.
//




#import <OpenGLES/ES1/glext.h>

#import "Texture2D.h"



// remember the
// maxtexturesize = 1024x1024
#define kMaxTextureSize		1024

@implementation Texture2D


@synthesize contentSize=_size, pixelsWide=_width, pixelsHigh=_height, name=_name, maxS=_maxS, maxT=_maxT;


//create a texture and choose between 16 or 32bits texture
//16bits should reduce the ram used for your game 
- (id) initWithData:(const void*)data  pixelsWide:(NSUInteger)width pixelsHigh:(NSUInteger)height contentSize:(CGSize)size   filter:(GLenum)filter Use32bits:(bool)use32bits
{
	
	
	GLint					saveName;
	if((self = [super init])) {
		glGenTextures(1, &_name);
		glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
		glBindTexture(GL_TEXTURE_2D, _name);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter);
		
		
		if (use32bits)
		{
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data); //32 bit texture alpha
		}else{
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_SHORT_5_5_5_1, data); //16 bits texture alpha
		}
		
		glBindTexture(GL_TEXTURE_2D, saveName);
		
		_size = size;
		_width = width;
		_height = height;
		_maxS = size.width / (float)width;
		_maxT = size.height / (float)height;
		
	}
	
	return self;
}












- (id) initWithImage:(UIImage *)uiImage  filter:(GLenum)filter  Use32bits:(bool)use32bits
{
	NSUInteger				width,
	height,
	i;
	CGContextRef			context = nil;
	void*					data = nil;
	CGColorSpaceRef			colorSpace;
	void*					tempData;
	
	CGAffineTransform		transform;
	CGSize					imageSize;
	
	CGImageRef				image;
	BOOL					sizeToFit = NO;
	
	
	image = [uiImage CGImage];
	
	
	if(image == NULL) {
		[self release];
		NSLog(@"Image is Null");
		return nil;
	}

	imageSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
	transform = CGAffineTransformIdentity;
	
	width = imageSize.width;
	
	//if the image is more than 1024x1024 resize it
	//calculate the texture size and make it power of two
	//ex:if the texture is 90x57 this function
	//will convert the texture into 128x64 and pad the image to fill the empty space
	if((width != 1) && (width & (width - 1))) {
		i = 1;
		while((sizeToFit ? 2 * i : i) < width)
			i *= 2;
		width = i;
	}
	height = imageSize.height;
	if((height != 1) && (height & (height - 1))) {
		i = 1;
		while((sizeToFit ? 2 * i : i) < height)
			i *= 2;
		height = i;
	}
	while((width > kMaxTextureSize) || (height > kMaxTextureSize)) {
		width /= 2;
		height /= 2;
		transform = CGAffineTransformScale(transform, 0.5, 0.5);
		imageSize.width *= 0.5;
		imageSize.height *= 0.5;
	}
	
	
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
	data = malloc(height * width * 4);
	context = CGBitmapContextCreate(data, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	
	
	CGContextClearRect(context, CGRectMake(0, 0, width, height));
	CGContextTranslateCTM(context, 0, height - imageSize.height);
	
	if(!CGAffineTransformIsIdentity(transform))
		CGContextConcatCTM(context, transform);
	CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
	
	//with the context created it's time to decide if the image will be 16 bits or not
	if (!use32bits)
	{
		//Convert "RRRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA" to "RRRRRGGGGGBBBBBA"  RGB5A1
		tempData = malloc(height * width * 2);
		unsigned int* inPixel32 = (unsigned int*)data;
		unsigned short* outPixel16 = (unsigned short*)tempData;
		for(int i = 0; i < width * height; ++i, ++inPixel32)
			*outPixel16++ =  
			((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) | // R
			((((*inPixel32 >> 8) & 0xFF) >> 3) << 6) | // G
			((((*inPixel32 >> 16) & 0xFF) >> 3) << 1) | // B
			((((*inPixel32 >> 24) & 0xFF) >> 7) << 0); // A
		
		
		free(data);
		data = tempData;

		
	}
	
	
	
	self = [self initWithData:data  pixelsWide:width pixelsHigh:height contentSize:imageSize  filter:filter  Use32bits:use32bits];
	
	CGContextRelease(context);
	free(data);
	
	return self;
}








- (void) dealloc
{
	if(_name)
		glDeleteTextures(1, &_name);
	
	[super dealloc];
}





@end






//PVRTC textures are only good for 3D or lower image requirement
//the quality looks like crap, usually for 2D you will never be using this
@implementation Texture2D (PVRTC)
-(id) initWithPVRTCData:(const void*)data  HasAlpha:(bool)hasAlpha length:(int)length  filter:(GLenum)filter
{
	GLint					saveName;
	
	if((self = [super init])) {
		glGenTextures(1, &_name);
		glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
		glBindTexture(GL_TEXTURE_2D, _name);
		
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter);
		
		
		GLsizei size = length * length * 4 / 8;
		
		if(size < 32) {
			size = 32;
		}
		
		if (hasAlpha)
		{
			glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG, length, length, 0, size, data);
		}else {
			glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG, length, length, 0, size, data);
		}
		

		glBindTexture(GL_TEXTURE_2D, saveName);
		
		_size = CGSizeMake(length, length);
		_width = length;
		_height = length;
		_maxS = 1.0f;
		_maxT = 1.0f;
	}					
	return self;
}



@end
























