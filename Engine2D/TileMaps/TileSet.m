//
//  TileSet.m
//  
//
//  Created by Michael Daley on 05/04/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//
//	Modified by Eskema 2011 for 2DEngine


#import "TileSet.h"
#import "Image.h"


@implementation TileSet

@synthesize tileSetID;
@synthesize name;
@synthesize firstGID;
@synthesize lastGID;
@synthesize tileWidth;
@synthesize tileHeight;
@synthesize spacing;
@synthesize margin;
@synthesize tiles;
@synthesize cachedTexture;
@synthesize textureCoordinates;
@synthesize mvertex;

- (void)dealloc {

	if (tiles)
		tiles = nil;

	[super dealloc];
}
- (id)initWithImageNamed:(Image*) aImageFileName name:(NSString*)aTileSetName 
			   tileSetID:(int)tsID firstGID:(int)aFirstGlobalID 
				tileSize:(CGSize)aTileSize 
				 spacing:(int)aSpacing margin:(int)aMargin
				ImgWidth:(int)imgWidth ImgHeight:(int)imgHeight
{
	self = [super init];
	if (self != nil) {
	
		//set the image to use in this tileset
		tiles = aImageFileName;
		
	
		// Set up the classes properties based on the info passed into the method
		tileSetID = tsID;
		name = aTileSetName;
		firstGID = aFirstGlobalID;
		tileWidth = aTileSize.width;
		tileHeight = aTileSize.height;
		spacing = aSpacing;
		margin = aMargin;
		
		//calculate image coords size, basically how many rows and columns are in that image
		horizontalTiles = imgWidth / tileWidth;
		verticalTiles = imgHeight / tileHeight;
		
		
		// Calculate the lastGID for this tile set based on the number of sprites in the image
		// and the firstGID
		lastGID = horizontalTiles * verticalTiles + firstGID - 1;
		
	

		//init image class to hold this tileset
		textureCoordinates = (Quad2f*)calloc(1, sizeof( Quad2f ) );
		mvertex = (Quad2f*)calloc( 1, sizeof( Quad2f ) );
		cachedTexture = (Quad2f*)calloc((horizontalTiles * verticalTiles), sizeof(Quad2f));
		
		//now loop the tileset and cache all the texture coordinates
		//this will speed up things a lot
		int spriteSheetCount = 0;
		for(int i=0; i<verticalTiles; i++) {
			for(int j=0; j<horizontalTiles; j++) {
				[tiles cacheTexCoords:tileWidth 
					  SubTextureHeight:tileHeight  
					 CachedCoordinates:textureCoordinates 
						CachedTextures:cachedTexture
							   Counter:spriteSheetCount
								 PosX:(j * (tileWidth + spacing)) + margin
								 PosY:(i * (tileHeight + spacing)) + margin];
				
				spriteSheetCount++;			
			}
		}
	}
	return self;
}


- (BOOL)containsGlobalID:(int)aGlobalID {
	// If the global ID which has been passed is within the global IDs in this
	// tileset then return YES
	return (aGlobalID >= firstGID) && (aGlobalID <= lastGID);
}


- (int)getTileX:(int)aTileID {
	return aTileID % horizontalTiles;
}


- (int)getTileY:(int)aTileID {
	return aTileID / horizontalTiles;
}

@end
