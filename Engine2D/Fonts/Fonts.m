//
//  Fonts.m
//  
//
//  Created by Eskema on 11/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Fonts.h"
#import "Image.h"

@implementation Fonts




//init function, load font with the image given and the font file to parse the texture atlas for the font
- (id) LoadFont:(Image *)ImageDraw  FileFont:(NSString *)fileFont
{
	self = [super init];
	if (self != nil) {

		//init the values as usual, a calloc will put all values to 0
		textureCoordinates = calloc( 1, sizeof( Quad2f ) );
		vertices = calloc( 1, sizeof( Quad2f ) );
		
		//we have 256 chars on the unicode table
		cachedTexture = calloc((256), sizeof(Quad2f));
		
		//call parsefont to fill all the quads array
		[self parseFont:fileFont ImageArray:ImageDraw];
		
	}
	return self;
	
	
}



- (void) dealloc
{	
	free(cachedTexture);
	free(textureCoordinates);
	free(vertices);
	[super dealloc];
}
















//draw text centered on a position given
//and a width, for example to center text
//inside a button or a square for text
//==============================================================================
-(void) DrawTextCenteredPosX:(Image *)Surf_Draw  Width:(float)Width X:(float)X  Y:(float)Y  Scale:(float)scale  Text:(NSString *)Text 
{
	[self DrawTextCenteredPosX:Surf_Draw Width:Width X:X Y:Y Scale:scale Colors:Color4fMake(255.0, 255.0, 255.0, 1.0) Text:Text];
	
}

//draw text centered on a position given
//and a width, for example to center text
//inside a button or a square for text
//colored version
//==============================================================================
-(void) DrawTextCenteredPosX:(Image *)Surf_Draw  Width:(float)Width X:(float)X  Y:(float)Y  Scale:(float)scale  Colors:(Color4f)_colors Text:(NSString *)Text 
{
	
	//get the width of the text
	//needed to split the text in various lines
	int widthtext =  [self  GetTextWidth:Text Scale:scale];
	float pos = X + ((Width/2) - (widthtext/2));
	
	
	float dx = pos;
	float dy;
	float widetext;
	float offsetY;
	int fontlineskip = 0;
	
	unsigned char red = _colors.red * 1.0f;
	unsigned char green = _colors.green * 1.0f;
	unsigned char blue = _colors.blue * 1.0f;
	unsigned char shortAlpha = _colors.alpha * 255.0f;
	
	
	//	pack all of the color data bytes into an unsigned int
	unsigned _color = (shortAlpha << 24) | (blue << 16) | (green << 8) | (red << 0);
	
	for(int i=0; i<[Text length]; i++) 
	{
		// Grab the unicode value of the current character
		unichar charID = [Text characterAtIndex:i];
		
		if (charID == '\n') {
			//calculate the size to center text on Y axis, based on its scale
			fontlineskip += [self GetTextHeight:scale];
			dx = pos;
		}
		else {
			//calculate the size to center text on Y axis, based on its scale
			offsetY = arrayFonts[charID].offsety * scale;
			dy = Y + offsetY + fontlineskip;
		}
		
		
		Quad2f tex = [Surf_Draw getTextureCoordsForSpriteAt:charID  CachedTextures:cachedTexture];
		Quad2f vert = *[Surf_Draw getVerticesForSpriteAtrect:CGRectMake(dx, dy, arrayFonts[charID].w * scale, arrayFonts[charID].h * scale) Vertices:vertices Flip:1];
		
		// Triangle #1
		[Surf_Draw _addVertex:vert.tl_x  Y:vert.tl_y  UVX:tex.tl_x  UVY:tex.tl_y  Color:_color];
		[Surf_Draw _addVertex:vert.tr_x  Y:vert.tr_y  UVX:tex.tr_x  UVY:tex.tr_y  Color:_color];
		[Surf_Draw _addVertex:vert.bl_x  Y:vert.bl_y  UVX:tex.bl_x  UVY:tex.bl_y  Color:_color];
		
		// Triangle #2
		[Surf_Draw _addVertex:vert.tr_x  Y:vert.tr_y  UVX:tex.tr_x  UVY:tex.tr_y  Color:_color];
		[Surf_Draw _addVertex:vert.bl_x  Y:vert.bl_y  UVX:tex.bl_x  UVY:tex.bl_y  Color:_color];
		[Surf_Draw _addVertex:vert.br_x  Y:vert.br_y  UVX:tex.br_x  UVY:tex.br_y  Color:_color];
	
		
		//calculate the size to advance, based on its scale
		widetext = (arrayFonts[charID].xadvance  * scale);
		
		//advance the position to draw the next letter
		dx +=  widetext + arrayFonts[charID].offsetx;
		
	}//end for	
	
}




//draw text centered on screen based on
//landscape value
//==============================================================================
-(void) DrawTextCentered:(Image *)Surf_Draw  Lanscape:(bool)landsCape Y:(float)Y  Scale:(float)scale  Text:(NSString *)Text 
{
	[self DrawTextCentered:Surf_Draw Lanscape:landsCape Y:Y Scale:scale Colors:Color4fMake(255.0, 255.0, 255.0, 1.0) Text:Text];
}



//draw text centered on screen based on
//landscape value
//colored version
//==============================================================================
-(void) DrawTextCentered:(Image *)Surf_Draw  Lanscape:(bool)landsCape Y:(float)Y  Scale:(float)scale  Colors:(Color4f)_colors Text:(NSString *)Text 
{
	float pos;
	
	int widthtext =  [self GetTextWidth:Text Scale:scale];
	if (landsCape) {
		pos = 240 - (widthtext/2);
	}
	else {
		pos = 160 - (widthtext/2);
	}
	
	
	float dx = pos;
	float dy;
	float widetext;
	float offsetY;
	
	int fontlineskip = 0;
	
	unsigned char red = _colors.red * 1.0f;
	unsigned char green = _colors.green * 1.0f;
	unsigned char blue = _colors.blue * 1.0f;
	unsigned char shortAlpha = _colors.alpha * 255.0f;
	
	
	//	pack all of the color data bytes into an unsigned int
	unsigned _color = (shortAlpha << 24) | (blue << 16) | (green << 8) | (red << 0);
	
	for(int i=0; i<[Text length]; i++) {
		
		
		// Grab the unicode value of the current character
		unichar charID = [Text characterAtIndex:i];
		
		if (charID == '\n') {
			//calculate the size to center text on Y axis, based on its scale
			fontlineskip += [self GetTextHeight:scale];
			dx = pos;
		}
		else {
			//calculate the size to center text on Y axis, based on its scale
			offsetY = arrayFonts[charID].offsety * scale;
			dy = Y + offsetY + fontlineskip;
		}
		
		
		Quad2f tex = [Surf_Draw getTextureCoordsForSpriteAt:charID  CachedTextures:cachedTexture];
		Quad2f vert = *[Surf_Draw getVerticesForSpriteAtrect:CGRectMake(dx, dy, arrayFonts[charID].w * scale, arrayFonts[charID].h * scale) Vertices:vertices Flip:1];
		
		// Triangle #1
		[Surf_Draw _addVertex:vert.tl_x  Y:vert.tl_y  UVX:tex.tl_x  UVY:tex.tl_y  Color:_color];
		[Surf_Draw _addVertex:vert.tr_x  Y:vert.tr_y  UVX:tex.tr_x  UVY:tex.tr_y  Color:_color];
		[Surf_Draw _addVertex:vert.bl_x  Y:vert.bl_y  UVX:tex.bl_x  UVY:tex.bl_y  Color:_color];
		
		// Triangle #2
		[Surf_Draw _addVertex:vert.tr_x  Y:vert.tr_y  UVX:tex.tr_x  UVY:tex.tr_y  Color:_color];
		[Surf_Draw _addVertex:vert.bl_x  Y:vert.bl_y  UVX:tex.bl_x  UVY:tex.bl_y  Color:_color];
		[Surf_Draw _addVertex:vert.br_x  Y:vert.br_y  UVX:tex.br_x  UVY:tex.br_y  Color:_color];

		
		//calculate the size to advance, based on its scale
		widetext = (arrayFonts[charID].xadvance  * scale);
		
		//advance the position to draw the next letter
		dx +=  widetext + arrayFonts[charID].offsetx;

	}//end for	
	
}















//==============================================================================
-(void) DrawText:(Image *)Surf_Draw X:(float)X  Y:(float)Y  Scale:(float)scale  Text:(NSString *)Text 
{
	[self DrawText:Surf_Draw X:X Y:Y Scale:scale Colors:Color4fMake(255.0, 255.0, 255.0, 1.0) Text:Text];
}


//the basic render font function, with basic parameters
//just supply the text, the positions, scale and other values
//==============================================================================
-(void) DrawText:(Image *)Surf_Draw X:(float)X  Y:(float)Y  Scale:(float)scale  Colors:(Color4f)_colors  Text:(NSString *)Text 
{
	
	
	float dx = X;
	float dy;
	float widetext;
	float offsetY;
	
	
	int fontlineskip = 0;
	
	unsigned char red = _colors.red * 1.0f;
	unsigned char green = _colors.green * 1.0f;
	unsigned char blue = _colors.blue * 1.0f;
	unsigned char shortAlpha = _colors.alpha * 255.0f;
	
	
	//	pack all of the color data bytes into an unsigned int
	unsigned _color = (shortAlpha << 24) | (blue << 16) | (green << 8) | (red << 0);
	
	for(int i=0; i<[Text length]; i++) {
		
		
		// Grab the unicode value of the current character
		unichar charID = [Text characterAtIndex:i];
		
		if (charID == '\n') {
			//calculate the size to center text on Y axis, based on its scale
			fontlineskip += [self GetTextHeight:scale];
			dx = X;
		}
		else {
			//calculate the size to center text on Y axis, based on its scale
			offsetY = arrayFonts[charID].offsety * scale;
			dy = Y + offsetY + fontlineskip;
		}

		
		//get the texture coordinate for the letter, this value is cached to speed up things
		Quad2f tex = [Surf_Draw getTextureCoordsForSpriteAt:charID  CachedTextures:cachedTexture];
		//get the coordinates on screen for the quad to render the font
		//flip 1 means normal position, no rotation applied
		Quad2f vert = *[Surf_Draw getVerticesForSpriteAtrect:CGRectMake(dx, dy, arrayFonts[charID].w * scale, arrayFonts[charID].h * scale) Vertices:vertices Flip:1];
		
		// Triangle #1
		[Surf_Draw _addVertex:vert.tl_x  Y:vert.tl_y  UVX:tex.tl_x  UVY:tex.tl_y  Color:_color];
		[Surf_Draw _addVertex:vert.tr_x  Y:vert.tr_y  UVX:tex.tr_x  UVY:tex.tr_y  Color:_color];
		[Surf_Draw _addVertex:vert.bl_x  Y:vert.bl_y  UVX:tex.bl_x  UVY:tex.bl_y  Color:_color];
		
		// Triangle #2
		[Surf_Draw _addVertex:vert.tr_x  Y:vert.tr_y  UVX:tex.tr_x  UVY:tex.tr_y  Color:_color];
		[Surf_Draw _addVertex:vert.bl_x  Y:vert.bl_y  UVX:tex.bl_x  UVY:tex.bl_y  Color:_color];
		[Surf_Draw _addVertex:vert.br_x  Y:vert.br_y  UVX:tex.br_x  UVY:tex.br_y  Color:_color];

		
		//calculate the size to advance, based on its scale
		widetext = (arrayFonts[charID].offsetx * scale);// xadvance  * scale);
		
		//advance the position to draw the next letter
		dx +=  widetext + arrayFonts[charID].xadvance;// offsetx;
		
	}//end for	
	
}




//==============================================================================
//function to get the pixels wide from the text given
-(int) GetTextWidth:(NSString *)text Scale:(float)scale
{
	
	int linelength = 0;
	
	for(int i=0; i<[text length]; i++) {
		
		// Grab the unicode value of the current character
		unichar charID = [text characterAtIndex:i];
		if (charID == '\n') {
			return linelength;
		}else {
			linelength += arrayFonts[charID].w * scale;
		}		
	}
	
    return linelength;
	
}




//==============================================================================
-(int) GetTextHeight:(float) scale
{
	//return "M" wich usually it's
	//the biggest char on the font
	//plus 7 pixels more to get text
	//a little bit more spaced
	return (arrayFonts[77].h + 7) * scale; 
}

-(int) GetTextHeight:(float) scale myChar:(NSString *)mychar
{
	//return "M" wich usually it's
	//the biggest char on the font
	//plus 7 pixels more to get text
	//a little bit more spaced
	unichar charID = [mychar characterAtIndex:0];
	return (arrayFonts[charID].h) * scale; 
}

//parse the font and fill the cached quad array with texture coordinates
//this is done only once and improves the performace a lot
- (void)parseFont:(NSString*)controlFile  ImageArray:(Image *)imageArray{
	
	// Read the contents of the file into a string
	NSString *contents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:controlFile ofType:nil] encoding:NSUTF8StringEncoding error:nil];
	
	// Move all lines in the string, which are denoted by \n, into an array
	NSArray *lines = [[NSArray alloc] initWithArray:[contents componentsSeparatedByString:@"\n"]];
	
	// Create an enumerator which we can use to move through the lines read from the control file
	NSEnumerator *nse = [lines objectEnumerator];
	
	// Create a holder for each line we are going to work with
	NSString *line;
	
	// Loop through all the lines in the lines array processing each one
	while(line = [nse nextObject]) {
		// Check to see if the start of the line is something we are interested in
		if([line hasPrefix:@"char"]) {

			[self parseCharacterDefinition:line  ImageArray:imageArray];
		}
	}
	// Finished with lines so release it
	[lines release];
}



- (void)parseCharacterDefinition:(NSString*)line  ImageArray:(Image *)imageArray{
	
	int idNum;
	
	// Break the values for this line up using =
	NSArray *values = [line componentsSeparatedByString:@"="];
	
	// Get the enumerator for the array of components which has been created
	NSEnumerator *nse = [values objectEnumerator];
	
	// We are going to place each value we read from the line into this string
	NSString *propertyValue;
	
	// We need to move past the first entry in the array before we start assigning values
	[nse nextObject];
	
	// Character ID
	propertyValue = [nse nextObject];
	idNum = [propertyValue intValue];

	// Character x
	propertyValue = [nse nextObject];
	arrayFonts[idNum].posX = [propertyValue intValue];
	
	// Character y
	propertyValue = [nse nextObject];
	arrayFonts[idNum].posY = [propertyValue intValue];
	
	// Character width
	propertyValue = [nse nextObject];
	arrayFonts[idNum].w = [propertyValue intValue];
	
	// Character height
	propertyValue = [nse nextObject];
	arrayFonts[idNum].h = [propertyValue intValue];

	// Character xoffset
	propertyValue = [nse nextObject];
	arrayFonts[idNum].offsetx =[propertyValue intValue];
	
	// Character yoffset
	propertyValue = [nse nextObject];
	arrayFonts[idNum].offsety = [propertyValue intValue];
	
	// Character xadvance
	propertyValue = [nse nextObject];
	arrayFonts[idNum].xadvance = [propertyValue intValue];

	
	//call the cache function to fill the array with the positions of this letter
	//when we end parsing the file, we have a full array with cached quad texture coordinates
	[imageArray cacheTexCoords:arrayFonts[idNum].w
			  SubTextureHeight:arrayFonts[idNum].h  
			 CachedCoordinates:textureCoordinates 
				CachedTextures:cachedTexture
					   Counter:idNum
						  PosX:arrayFonts[idNum].posX
						  PosY:arrayFonts[idNum].posY];
	
}





@end

