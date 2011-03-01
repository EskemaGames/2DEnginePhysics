//
//  Image.h
//  
//
//
//  Created by Eskema on 04/03/2009.
//  Copyright 2009 Eskema. All rights reserved.
//







#import <Foundation/Foundation.h>
#import "CommonEngine.h"
#import "Texture2D.h"
#import "GameTextureBound.h"






@interface Image : NSObject {
	
 @private

	// Texture Bind State
	GameTextureBound *_sharedTexture;
   	
    
 @protected
	Texture2D		*texture;	
	NSUInteger		textureWidth;
	NSUInteger		textureHeight;
	float			texWidthRatio;
	float			texHeightRatio;
	
@public
	int verticesCounter;

	//our vertex array
	TileVert *_interleavedVerts;

}


@property(nonatomic, readwrite) int verticesCounter;
@property(nonatomic, retain) Texture2D *texture;
@property(nonatomic, readonly) NSUInteger textureWidth;
@property(nonatomic, readonly) NSUInteger textureHeight;
@property(nonatomic, readonly) float texWidthRatio;
@property(nonatomic, readonly) float texHeightRatio;




//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================

-(void) _addVertex:(float)x  Y:(float)y  UVX:(float)uvx  UVY:(float)uvy Color:(unsigned) color;

// Initializers
- (id)initWithTexture:(NSString *)image  filter:(GLenum)Filter Use32bits:(BOOL)use32bits   TotalVertex:(int)totalvertex;
- (id)initWithPVR: (const void*)data   HasAlpha:(bool)hasAlpha  length:(int)length  filter:(GLenum)Filter TotalVertex:(int)totalvertex;



//add sprites into vertex array to draw all at once
-(void) DrawImageColor:(CGRect)rect  OffsetPoint:(CGPoint)offsetpoint ImageWidth:(int)Width  ImageHeight:(int)Height  Colors:(Color4f)_colors;
-(void) DrawImage:(CGRect)rect OffsetPoint:(CGPoint)offsetPoint ImageWidth:(int)Width ImageHeight:(int)Height;
-(void) DrawSprites:(CGRect)rect  OffsetPoint:(CGPoint)offsetPoint  ImageWidth:(int)Width  ImageHeight:(int)Height  Flip:(int)_flip   Colors:(Color4f)_colors  Rotation:(GLfloat)rotation;
-(void) RenderToScreenActiveBlend:(BOOL)ActiveBlend;


// draw methods without vertex array cache
- (void)drawInEntireRect:(CGRect)rect;





//used for font functions and other caching functions like tilemaps
// Gets the offset of a subimage within the sprite sheet based on the location provided
- (CGPoint)getOffsetForSpriteAtX:(int)x y:(int)y  SubTextureWidth:(GLuint)SubTextureWidth SubTextureHeight:(GLuint)SubTextureHeight;
-(void)calculateTexCoordsAtOffset:(CGPoint)aOffsetPoint TexCoords:(Quad2f *)texCoords SubTextureWidth:(GLuint)SubTextureWidth SubTextureHeight:(GLuint)SubTextureHeight;
// Gets the vertices for a sprite at the coordinates provided.
- (Quad2f*)getVerticesForSpriteAtrect:(CGRect)aRect Vertices:(Quad2f *)Vertices Flip:(int)flip;
- (void)calculateVerticesAtRect:(CGRect)rect Vertices:(Quad2f *)Vertices  Flip:(int)flip; 
- (Quad2f)getTextureCoordsForSpriteAt:(int)sizeX   CachedTextures:(Quad2f *)cached;
- (void)cacheTexCoords:(GLuint)SubTextureWidth 
	  SubTextureHeight:(GLuint)SubTextureHeight 
	 CachedCoordinates:(Quad2f *)cachedCoordinates 
		CachedTextures:(Quad2f *)cached
			   Counter:(int)counter
				  PosX:(int)posX
				  PosY:(int)posY;
@end







