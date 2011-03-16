//
//  TileSet.h
//  
//
//  Created by Michael Daley on 05/04/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//
//	Modified by Eskema 2011 for 2DEngine

#import "CommonEngine.h"
@class Image;


// Class used to hold tilesets that are defined within a tile map configuration file.  This class
// is responsible for holding the tileset sprite sheet as well as information about the global
// id's used within the tilset and details of the tilesets dimensions.
//
@interface TileSet : NSObject {

	Image *tiles;
	// Array used to store texture coords and vertices info for rendering
	Quad2f *cachedTexture;
	Quad2f *textureCoordinates;
	Quad2f *mvertex;
	


	/////////////////// Class iVars
	int tileSetID;			// ID of tile set
	NSString *name;			// Name of the tile set
	int firstGID;			// First global id for this tile set	
	int lastGID;			// last gloabl ID for this tile set
	int tileWidth;			// Width of the tiles in this tile set
	int tileHeight;			// Height of the tiles in this tile set
	int spacing;			// Tile spacing
	int margin;				// Tile margin
	int horizontalTiles;	// Horizontal tiles
	int verticalTiles;		// Vertical tiles
	
}

@property (nonatomic, readonly) int tileSetID;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) int firstGID;
@property (nonatomic, readonly) int lastGID;
@property (nonatomic, readonly) int tileWidth;
@property (nonatomic, readonly) int tileHeight;
@property (nonatomic, readonly) int spacing;
@property (nonatomic, readonly) int margin;
@property (nonatomic, readonly) Image *tiles;
@property (readwrite) Quad2f *cachedTexture;
@property (readwrite) Quad2f *textureCoordinates;
@property (readwrite) Quad2f *mvertex;



// Designated selector used to initialize a new tileset instance.
- (id)initWithImageNamed:(Image*)aImageFileName name:(NSString*)aTileSetName 
			   tileSetID:(int)tsID firstGID:(int)aFirstGlobalID 
				tileSize:(CGSize)aTileSize 
				 spacing:(int)aSpacing margin:(int)aMargin 
				ImgWidth:(int)imgWidth ImgHeight:(int)imgHeight; 

// Checks to see if the |aGlobalID| exists within this tileset and returns YES if it does
- (BOOL)containsGlobalID:(int)aGlobalID;

// Returns the Y location within the tilsset sprite sheet of a given tile given the tiles
// |aTileID|
- (int)getTileY:(int)aTileID;

// Returns the X location within the tilsset sprite sheet of a given tile given the tiles
// |aTileID|
- (int)getTileX:(int)aTileID;

@end
