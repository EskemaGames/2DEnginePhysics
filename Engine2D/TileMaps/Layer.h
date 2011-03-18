//
//  Layer.h
// 
//
//  Created by Michael Daley on 05/04/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//
//	Modified by Eskema 2011 for 2DEngine


#import "CommonEngine.h"

// Class which contains information about each layer defined within a tile map 
// configuration file.  This class is responsbile for storing information related
// to a layer in the tilemap and also for holding the tilemap data for each tile
// within the defined layer
//

@class Image;

@interface Layer : NSObject {
	
	int layerID;							// The layers index
	NSString *layerName;					// The layers name
	
	_Tiles **layerData;						//Array to hold the layer data
	
	int layerWidth;							// The width of the layer
	int layerHeight;						// The height of layer layer
	NSMutableDictionary *layerProperties;	// Layer properties
	
}

@property(nonatomic, readonly) int layerID;
@property(nonatomic, readonly) NSString *layerName;
@property(nonatomic, readonly) int layerWidth;
@property(nonatomic, readonly) int layerHeight;
@property(nonatomic, retain) NSMutableDictionary *layerProperties;
@property(nonatomic, readwrite) _Tiles **layerData;

// Designated selector which creates a new instance of the Layer class.
- (id)initWithName:(NSString*)aName layerID:(int)aLayerID layerWidth:(int)aLayerWidth layerHeight:(int)aLayerHeight;

// Adds tile details to the layer at a specified location within the tile map
- (void)addTileAt:(CGPoint)aTileCoord tileSetID:(int)aTileSetID tileID:(int)aTileID globalID:(int)aGlobalID value:(int)aValue;

// Returns the tileset for a tile at a given location within this layer
- (int)tileSetIDAtTile:(CGPoint)aTileCoord;

// Returns the Global Tile ID for a tile at a given location within this layer
- (int)globalTileIDAtTile:(CGPoint)aTileCoord;

// Returns the tile id for a tile at a given location within this layer
- (int)tileIDAtTile:(CGPoint)aTileCoord;

// Sets a general purpose int value for the tile specified by the coordinates
- (void)setValueAtTile:(CGPoint)aTileCoord value:(int)aValue;

// Gets the general purpose value for the tile specified by the coordinates
- (int)valueAtTile:(CGPoint)aTileCoord;


@end
