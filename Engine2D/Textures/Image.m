//
//  Image.h
//  
//
//
//  Created by Eskema on 04/03/2009.
//  Copyright 2009 Eskema. All rights reserved.
//

#import "Image.h"





#pragma mark -
#pragma mark Public implementation

@implementation Image



@synthesize texture;
@synthesize textureWidth;
@synthesize textureHeight;
@synthesize texWidthRatio;
@synthesize texHeightRatio;

@synthesize verticesCounter;





//our main init method, we create a opengl texture from here
//this is the list of parameters
// name: we pass the name of the image resource
//
// filter: gl_nearest or gl_linear, gl_nearest means low quality but high speed to render
// gl_linear means the best quality but slow to render
//
// use32bits: select if you want a 32bits texture or 16bits, using 16bits texture you can
// save a lot of ram, and the quality is pretty decent
//
// totalvertex: this is the tricky part, this is our vertex array, how many vertex we gonna render?
// for a single image we use 12 vertex, working with openglES means that we work with triangles
// so to draw a square image we need 2 triangles, each triangle is made with 3 vertex, and each vertex has
// 2 positions (x,y), so 6*2=12 vertex per quad/square/image call it whatever ;)
// if you gonna draw only one image, then set the value to 12, but if you gonna render more images
// like this is a texture atlas, you must calculate an approximate size, let's suppose you want to render
// 40 sprites, then simply calculate, 40*12 = 480 vertex in total
//==============================================================================
- (id)initWithTexture:(NSString *)image  filter:(GLenum)Filter Use32bits:(BOOL)use32bits  TotalVertex:(int)totalvertex{
	self = [super init];
	if (self != nil) {
		texture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:image] filter:Filter Use32bits:use32bits];
		
		//init to 0 our vertex counter
		verticesCounter = 0;
		
		//reserve memory to hold the vertex array
		_interleavedVerts  = (TileVert *) calloc( totalvertex, sizeof( TileVert ) ); 
		
		//init the bound texture manager to hold textureID
		_sharedTexture = [GameTextureBound sharedGameStateInstance];
		
		
		//take the size of the texture, used to render only pieces of the image
		textureWidth = texture.pixelsWide;
		textureHeight = texture.pixelsHigh;
		
		texWidthRatio = 1.0f / textureWidth;
		texHeightRatio = 1.0f / textureHeight;
	}
	return self;
}












//==============================================================================
-(id)initWithPVR: (const void*)data   HasAlpha:(bool)hasAlpha  length:(int)length  filter:(GLenum)Filter TotalVertex:(int)totalvertex{
	self = [super init];
	if (self != nil) {
		
		texture = [[Texture2D alloc] initWithPVRTCData:data  HasAlpha:hasAlpha  length:length  filter:Filter];
		
		//init to 0 our vertex counter
		verticesCounter = 0;
		
		//reserve memory to hold the vertex array
		_interleavedVerts  = (TileVert *) calloc( totalvertex, sizeof( TileVert ) ); 
		
		//init the bound texture manager to hold textureID
		_sharedTexture = [GameTextureBound sharedGameStateInstance];
		
		
		//take the size of the texture, used to render only pieces of the image
		textureWidth = texture.pixelsWide;
		textureHeight = texture.pixelsHigh;
		
		texWidthRatio = 1.0f / textureWidth;
		texHeightRatio = 1.0f / textureHeight;
		
	}
	return self;
}	










//simply dealloc all the resources taken for the texture
//==============================================================================
- (void)dealloc {
	[_sharedTexture release];
	free(_interleavedVerts);
	[texture release];
	[super dealloc];
}



//this is the function to add vertex to the array cache
//for each image to draw on screen, we can send the vertex to the array cache
// and then draw all the images with one single opengl call, this improves a 
// lot your render routine, and the benefit is really high, instead of draw 40 sprites
// one by one you draw all in one
//
// the parameters are very simple
//
// x position of the vertex
// y position of the vertex
// uvx position of the texture
// uvy position of the texture
// color we can add color to the texture
//==============================================================================
-(void) _addVertex:(float)x  Y:(float)y  UVX:(float)uvx  UVY:(float)uvy Color:(unsigned) color
{
	TileVert *vert = &_interleavedVerts[verticesCounter];
	vert->v[0] = x;
    vert->v[1] = y;
    vert->uv[0] = uvx;
    vert->uv[1] = uvy;
    vert->color = color;
    verticesCounter++;
}







//these are 2 helper functions, you don't need to call the DrawSprites method unless you need all the parameters
//if you don't need rotation or color, you simply call one of those functions
//==============================================================================
-(void) DrawImage:(CGRect)rect OffsetPoint:(CGPoint)offsetPoint ImageWidth:(int)Width ImageHeight:(int)Height
{
	[self DrawSprites:rect OffsetPoint:offsetPoint ImageWidth:Width ImageHeight:Height Flip:1 Colors:Color4fInit Rotation:0.0f];
	
}



//==============================================================================
-(void) DrawImageColor:(CGRect)rect  OffsetPoint:(CGPoint)offsetPoint ImageWidth:(int)Width  ImageHeight:(int)Height  Colors:(Color4f)_colors
{
	[self DrawSprites:rect OffsetPoint:offsetPoint ImageWidth:Width ImageHeight:Height Flip:1 Colors:_colors Rotation:0.0f];
	
}



//this is the core function to draw any sprite optimized to the screen, this function
//sends all the vertex to the array cache, so later we can draw all of them in one pass
// parameters
//
// rect: this is the position and width & height of your image, for example cgrectmake(100, 0, 64, 64)
// using this rect you can scale your image, for example, your image is 64x64, so you can put
// cgrectmake(100,0, 128, 32), and now your image is 128x32, simply huh?
//
// offsetpoint: this is for texture atlas, this defines on what part of the image is the sprite
// we want to take, for example our sprite could be at 250,100, so that's the value we pass here
//
// imagewidth and height: your "real" image size, we talked about scale your image using the rect parameter
// but here you must put your real size, in this case 64x64
//
// flip: the image can be flipped in 4 directions, up,down,right,left
// 1 normal position
// 2 flipped vertical
// 3 flipped horizontal
// 4 flipped vertical and horizontal
//
// colors: we can color our image through vertex, the values are between 0 and 1.0, and it takes 4 values
// 3 colors, and a 4 value for alpha
//
// rotation: in degrees, what rotation you want for the sprite
//==============================================================================
-(void) DrawSprites:(CGRect)rect  OffsetPoint:(CGPoint)offsetPoint  ImageWidth:(int)Width  ImageHeight:(int)Height  Flip:(int)_flip   Colors:(Color4f)_colors Rotation:(GLfloat)Rotation
{
	
	GLfloat cx = texWidthRatio * offsetPoint.x;	// X Position of sprite in texture atlas
	GLfloat cy = texHeightRatio * offsetPoint.y; // Y Position of sprite in texture atlas
	
	
	//temp variables to hold vertex and texture coordinates
	float vertexTL_x;
	float vertexTL_y;
	float vertexTR_x;
	float vertexTR_y;
	float vertexBL_x;
	float vertexBL_y;	
	float vertexBR_x;
	float vertexBR_y;
	
	float texCoordTL_x; 
	float texCoordTL_y;
	float texCoordTR_x; 
	float texCoordTR_y; 
	float texCoordBL_x; 
	float texCoordBL_y; 
	float texCoordBR_x; 
	float texCoordBR_y;
	
	
	
	//calculate the rotation for the image (if any)
	if (Rotation != 0.0f)
	{
		//flip 1 normal position
		if (_flip == 1)
		{
			//leave texture coords upside-down
			texCoordTL_x = cx;
			texCoordTL_y = (texHeightRatio * Height) + cy;
			texCoordTR_x = (texWidthRatio * Width) + cx;
			texCoordTR_y = (texHeightRatio * Height) + cy;
			texCoordBL_x = cx;
			texCoordBL_y = cy;
			texCoordBR_x = (texWidthRatio * Width) + cx;
			texCoordBR_y = cy;
		}
		//flip 2 horizontal
		if (_flip == 2) {
			texCoordTL_x = (texWidthRatio * Width) + cx;
			texCoordTL_y = (texHeightRatio * Height) + cy;
			texCoordTR_x = cx;
			texCoordTR_y = (texHeightRatio * Height) + cy;
			texCoordBL_x = (texWidthRatio * Width) + cx;
			texCoordBL_y = cy;
			texCoordBR_x = cx;
			texCoordBR_y = cy;
		}
		
		//flip 3 invert vertical
		if (_flip == 3) {
			texCoordTL_x = cx;
			texCoordTL_y = cy;
			texCoordTR_x = (texWidthRatio * Width) + cx;
			texCoordTR_y = cy;
			texCoordBL_x = cx;
			texCoordBL_y = (texHeightRatio * Height) + cy;
			texCoordBR_x = (texWidthRatio * Width) + cx;
			texCoordBR_y = (texHeightRatio * Height) + cy;
		}
		
		//flip 4 vertical and horizontal
		if (_flip == 4) {
			texCoordTL_x = (texWidthRatio * Width) + cx;
			texCoordTL_y = cy;
			texCoordTR_x = cx;
			texCoordTR_y = cy;
			texCoordBL_x = (texWidthRatio * Width) + cx;
			texCoordBL_y = (texHeightRatio * Height) + cy;
			texCoordBR_x = cx;
			texCoordBR_y = (texHeightRatio * Height) + cy;
		}
		
		
		//rotate the quad using coregraphics functions
		CGPoint topleft = CGPointMake(rect.origin.x, rect.origin.y);
		CGPoint topright = CGPointMake(rect.origin.x + Width, rect.origin.y);
		CGPoint bottomleft = CGPointMake(rect.origin.x, rect.origin.y + Height);
		CGPoint bottomright = CGPointMake(rect.origin.x + Width, rect.origin.y + Height);
		
		CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(rect.origin.x+(Width*0.5f), rect.origin.y+(Height*0.5f));
		float degrees = DEGREES_TO_RADIANS(Rotation);
		CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(degrees);
		CGAffineTransform customRotation = CGAffineTransformConcat(CGAffineTransformConcat( CGAffineTransformInvert(translateTransform), rotationTransform), translateTransform);
		
		CGPoint rotatedtl = CGPointApplyAffineTransform(topleft, customRotation);
		CGPoint rotatedtr = CGPointApplyAffineTransform(topright, customRotation);
		CGPoint rotatedbl = CGPointApplyAffineTransform(bottomleft, customRotation);
		CGPoint rotatedbr = CGPointApplyAffineTransform(bottomright, customRotation);
		
		
		//	Convert the colors into bytes
		unsigned char red = _colors.red * 1.0f;
		unsigned char green = _colors.green * 1.0f;
		unsigned char blue = _colors.blue * 1.0f;
		unsigned char shortAlpha = _colors.alpha * 255.0f;
		
		//	pack all of the color data bytes into an unsigned int
		unsigned _color = (shortAlpha << 24) | (blue << 16) | (green << 8) | (red << 0);
		
		//now add the triangles to the vertex array cache
		// Triangle #1
		[self _addVertex:rotatedtl.x  Y:rotatedtl.y  UVX:texCoordTL_x  UVY:texCoordTL_y  Color:_color];
		[self _addVertex:rotatedtr.x  Y:rotatedtr.y  UVX:texCoordTR_x  UVY:texCoordTR_y  Color:_color];
		[self _addVertex:rotatedbl.x  Y:rotatedbl.y  UVX:texCoordBL_x  UVY:texCoordBL_y  Color:_color];
		
		// Triangle #2
		[self _addVertex:rotatedtr.x  Y:rotatedtr.y  UVX:texCoordTR_x  UVY:texCoordTR_y  Color:_color];
		[self _addVertex:rotatedbl.x  Y:rotatedbl.y  UVX:texCoordBL_x  UVY:texCoordBL_y  Color:_color];
		[self _addVertex:rotatedbr.x  Y:rotatedbr.y  UVX:texCoordBR_x  UVY:texCoordBR_y  Color:_color];
	}
	//the image don't have rotation, draw normally
	else{
		
		//opengl inverts texture upside-down so we flip texture here
		texCoordTL_x = cx;
		texCoordTL_y = cy;
		texCoordTR_x = (texWidthRatio * Width) + cx;
		texCoordTR_y = cy;
		texCoordBL_x = cx;
		texCoordBL_y = (texHeightRatio * Height) + cy;
		texCoordBR_x = (texWidthRatio * Width) + cx;
		texCoordBR_y = (texHeightRatio * Height) + cy;
		
		
		//normal
		if (_flip == 1)
		{
			vertexTL_x =  rect.origin.x;
			vertexTL_y =  rect.origin.y;
			
			vertexTR_x =  rect.origin.x + rect.size.width;
			vertexTR_y =  rect.origin.y;
			
			vertexBL_x =  rect.origin.x;
			vertexBL_y =  rect.origin.y + rect.size.height;
			
			vertexBR_x = rect.origin.x + rect.size.width;
			vertexBR_y = rect.origin.y + rect.size.height;
			
		}
		//horizontal inverted
		if (_flip == 2){
			
			vertexTL_x =  rect.origin.x + rect.size.width;
			vertexTL_y =  rect.origin.y;
			
			vertexTR_x =  rect.origin.x;
			vertexTR_y =  rect.origin.y;
			
			vertexBL_x =  rect.origin.x + rect.size.width;
			vertexBL_y =  rect.origin.y + rect.size.height;
			
			vertexBR_x = rect.origin.x;
			vertexBR_y = rect.origin.y + rect.size.height;
			
		}
		
		
		//vertical up
		if (_flip == 3){
			
			vertexTL_x =  rect.origin.x;
			vertexTL_y =  rect.origin.y + rect.size.height;
			
			vertexTR_x =  rect.origin.x + rect.size.width;
			vertexTR_y =  rect.origin.y + rect.size.height;
			
			vertexBL_x =  rect.origin.x;
			vertexBL_y =  rect.origin.y;
			
			vertexBR_x = rect.origin.x + rect.size.width;
			vertexBR_y = rect.origin.y;
			
		}
		
		//vertical down
		if (_flip == 4){
			
			vertexTL_x =  rect.origin.x + rect.size.width;
			vertexTL_y =  rect.origin.y + rect.size.height;
			
			vertexTR_x =  rect.origin.x;
			vertexTR_y =  rect.origin.y + rect.size.height;
			
			vertexBL_x =  rect.origin.x + rect.size.width;
			vertexBL_y =  rect.origin.y;
			
			vertexBR_x = rect.origin.x;
			vertexBR_y = rect.origin.y;
			
		}
		
		
		//	Convert the colors into bytes
		unsigned char red = _colors.red * 1.0f;
		unsigned char green = _colors.green * 1.0f;
		unsigned char blue = _colors.blue * 1.0f;
		unsigned char shortAlpha = _colors.alpha * 255.0f;
		
		//	pack all of the color data bytes into an unsigned int
		unsigned _color = (shortAlpha << 24) | (blue << 16) | (green << 8) | (red << 0);
		
		
		// Triangle #1
		[self _addVertex:vertexTL_x  Y:vertexTL_y  UVX:texCoordTL_x  UVY:texCoordTL_y  Color:_color];
		[self _addVertex:vertexTR_x  Y:vertexTR_y  UVX:texCoordTR_x  UVY:texCoordTR_y  Color:_color ];
		[self _addVertex:vertexBL_x  Y:vertexBL_y  UVX:texCoordBL_x  UVY:texCoordBL_y  Color:_color];
		
		// Triangle #2
		[self _addVertex:vertexTR_x  Y:vertexTR_y  UVX:texCoordTR_x  UVY:texCoordTR_y  Color:_color];
		[self _addVertex:vertexBL_x  Y:vertexBL_y  UVX:texCoordBL_x  UVY:texCoordBL_y  Color:_color];
		[self _addVertex:vertexBR_x  Y:vertexBR_y  UVX:texCoordBR_x  UVY:texCoordBR_y  Color:_color];
	}
	
	
}








//once we are done drawing images/sprites it's time to render all in screen
//the functions above don't display anything on screen, simply increases the vertex
// array, now this function is responsible to draw all sprites on screen
// and you choose if you want ALL your sprites with alpha or without alpha
//==============================================================================	
-(void) RenderToScreenActiveBlend:(BOOL)ActiveBlend
{
	//	Texture Blending fuctions
	if (ActiveBlend)
		glEnable(GL_BLEND);
	
	// Bind to the texture that is associated with this image.  This should only be done if the
	// texture is not currently bound
	if([texture name] != [_sharedTexture currentlyBoundTexture]) {
		[_sharedTexture setCurrentlyBoundTexture:[texture name]];
		glBindTexture(GL_TEXTURE_2D, [texture name]);
	}
	
	
	glVertexPointer(2, GL_SHORT, sizeof(TileVert), &_interleavedVerts[0].v);
	glTexCoordPointer(2, GL_FLOAT, sizeof(TileVert), &_interleavedVerts[0].uv);
	glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(TileVert), &_interleavedVerts[0].color);
	glDrawArrays(GL_TRIANGLES, 0, verticesCounter);
	
	verticesCounter = 0;
	
	if (ActiveBlend)
		glDisable(GL_BLEND);
	
}








//if you want to draw any image WITHOUT vertex array cache, this is your function
//this function draws a image with all the content, simply pass a cgrect with
// the position x,y,width,height and the image will be drawed inmediately
//==============================================================================
//draw without vertex cache
-(void)drawInEntireRect:(CGRect)rect
{
	GLfloat	 coordinates[] = {  0,		texture.maxT,
		texture.maxS,	texture.maxT,
		0,		0,
		texture.maxS,	0  };
	
	GLfloat	vertices1[] = {	rect.origin.x,		rect.origin.y + rect.size.height,							
		rect.origin.x + rect.size.width,		rect.origin.y + rect.size.height,							
		rect.origin.x,							rect.origin.y ,		
		rect.origin.x + rect.size.width,		rect.origin.y  };
	
	glDisableClientState(GL_COLOR_ARRAY);
	
	// Bind to the texture that is associated with this image.  This should only be done if the
	// texture is not currently bound
	if([texture name] != [_sharedTexture currentlyBoundTexture]) {
		[_sharedTexture setCurrentlyBoundTexture:[texture name]];
		glBindTexture(GL_TEXTURE_2D, [texture name]);
	}
	
	glVertexPointer(2, GL_FLOAT, 0, vertices1);
	glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
	
	// Enable blending as we want the transparent parts of the image to be transparent
	glEnable(GL_BLEND);
	
	//glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);  
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glEnableClientState(GL_COLOR_ARRAY);
	// Now we are done drawing disable blending
	glDisable(GL_BLEND);
}













///for use with fonts functions
- (Quad2f*)getVerticesForSpriteAtrect:(CGRect)aRect Vertices:(Quad2f *)Vertices Flip:(int)flip {
	[self calculateVerticesAtRect:aRect Vertices:Vertices  Flip:flip];
	return Vertices;
}


//calculate all the vertex for the image given
- (void)calculateVerticesAtRect:(CGRect)rect Vertices:(Quad2f *)Vertices  Flip:(int)flip {
	
	if (flip == 1)
	{
		Vertices[0].tl_x =  rect.origin.x;
		Vertices[0].tl_y =  rect.origin.y;
		
		Vertices[0].tr_x =  rect.origin.x + rect.size.width;
		Vertices[0].tr_y =  rect.origin.y;
		
		
		Vertices[0].bl_x =  rect.origin.x;
		Vertices[0].bl_y =  rect.origin.y + rect.size.height;
		
		
		Vertices[0].br_x = rect.origin.x + rect.size.width;
		Vertices[0].br_y = rect.origin.y + rect.size.height;
	}
	
	//horizontal inverted
	if (flip == 2){
		
		Vertices[0].tl_x =  rect.origin.x + rect.size.width;
		Vertices[0].tl_y =  rect.origin.y;
		
		Vertices[0].tr_x =  rect.origin.x;
		Vertices[0].tr_y =  rect.origin.y;
		
		
		Vertices[0].bl_x =  rect.origin.x + rect.size.width;
		Vertices[0].bl_y =  rect.origin.y + rect.size.height;
		
		
		Vertices[0].br_x = rect.origin.x;
		Vertices[0].br_y = rect.origin.y + rect.size.height;
	}
	
	
	//vertical inverted
	if (flip == 3){
		Vertices[0].tl_x =  rect.origin.x;
		Vertices[0].tl_y =  rect.origin.y + rect.size.height;
		
		Vertices[0].tr_x =  rect.origin.x + rect.size.width;
		Vertices[0].tr_y =  rect.origin.y + rect.size.height;
		
		
		Vertices[0].bl_x =  rect.origin.x;
		Vertices[0].bl_y =  rect.origin.y;
		
		
		Vertices[0].br_x = rect.origin.x + rect.size.width;
		Vertices[0].br_y = rect.origin.y;
	}
	
	//vertical inverted
	if (flip == 4){
		
		Vertices[0].tl_x =  rect.origin.x + rect.size.width;
		Vertices[0].tl_y =  rect.origin.y + rect.size.height;
		
		Vertices[0].tr_x =  rect.origin.x;
		Vertices[0].tr_y =  rect.origin.y + rect.size.height;
		
		
		Vertices[0].bl_x =  rect.origin.x + rect.size.width;
		Vertices[0].bl_y =  rect.origin.y;
		
		
		Vertices[0].br_x = rect.origin.x;
		Vertices[0].br_y = rect.origin.y;
	}
}


- (CGPoint)getOffsetForSpriteAtX:(int)x y:(int)y SubTextureWidth:(GLuint)SubTextureWidth SubTextureHeight:(GLuint)SubTextureHeight{
	return CGPointMake(x * SubTextureWidth, y * SubTextureHeight);
}


//calculate the texture coordinates
-(void)calculateTexCoordsAtOffset:(CGPoint)aOffsetPoint TexCoords:(Quad2f *)texCoords SubTextureWidth:(GLuint)SubTextureWidth SubTextureHeight:(GLuint)SubTextureHeight  {
	
	
	// Calculate the texture coordinates using the offset point from which to start the image and then using the width and height
	// passed in
	GLfloat cx = texWidthRatio * aOffsetPoint.x ;	// X Position of sprite
	GLfloat cy = texHeightRatio * aOffsetPoint.y; // Y Position of sprite
	
	// Work out the texture coordinates 
	//Quad2f tempTexCoords;
	texCoords[0].tl_x = cx;
	texCoords[0].tl_y = cy;
	texCoords[0].tr_x = (texWidthRatio * SubTextureWidth) + cx;
	texCoords[0].tr_y = cy;
	texCoords[0].bl_x = cx;
	texCoords[0].bl_y = (texHeightRatio * SubTextureHeight) + cy;
	texCoords[0].br_x = (texWidthRatio * SubTextureWidth) + cx;
	texCoords[0].br_y = (texHeightRatio * SubTextureHeight) + cy;
	
	
}




- (Quad2f)getTextureCoordsForSpriteAt:(int)index   CachedTextures:(Quad2f *)cached{
	
    // Return the coordinates at the specified location
	return cached[index];
}



//fill the cache array with texture coordinates
- (void)cacheTexCoords:(GLuint)SubTextureWidth 
	  SubTextureHeight:(GLuint)SubTextureHeight  
	 CachedCoordinates:(Quad2f *)cachedCoordinates 
		CachedTextures:(Quad2f *)cached
			   Counter:(int)counter
				  PosX:(int)posX
				  PosY:(int)posY
{
    // Loop through the rows and columns of the spritsheet calculating the texture coordinates
    // These coordinates are stored and returned when required to help performance
	CGPoint spritePoint = CGPointMake(posX, posY);
	[self calculateTexCoordsAtOffset:spritePoint TexCoords:cachedCoordinates SubTextureWidth:SubTextureWidth SubTextureHeight:SubTextureHeight];
	Quad2f t = *cachedCoordinates;
	cached[counter] = t;
	
}


@end
