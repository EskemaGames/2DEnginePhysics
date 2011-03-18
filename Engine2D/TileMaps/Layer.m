//
//  Layer.m
//  
//
//  Created by Michael Daley on 05/04/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//
//	Modified by Eskema 2011 for 2DEngine


#import "Layer.h"

@implementation Layer

@synthesize layerID;
@synthesize layerName;
@synthesize layerWidth;
@synthesize layerHeight;
@synthesize layerProperties;
@synthesize layerData;


- (void)dealloc {
	
	//free level array	
	if (layerData)
	{
		for (int i = 0; i < layerHeight; i++) {
			free(layerData[i]);
		}
		free(layerData);
	}
	
	
	[super dealloc];
}


- (id)initWithName:(NSString*)aName layerID:(int)aLayerID layerWidth:(int)aLayerWidth layerHeight:(int)aLayerHeight {
	if(self != nil) {
		layerName = aName;
		layerID = aLayerID;
		layerWidth = aLayerWidth;
		layerHeight = aLayerHeight;
		
		//the layerdata array will be created based on the layer size
		//this will reduce a bit the memory needed
		layerData = (_Tiles **)malloc(layerHeight * sizeof(_Tiles *));
		for (int i = 0; i < layerHeight; ++i) {
			layerData[i] = (_Tiles *)malloc(layerWidth * sizeof(_Tiles));
		}
	}
	return self;
}



- (int)tileIDAtTile:(CGPoint)aTileCoord {
	return layerData[(int)aTileCoord.y][(int)aTileCoord.x].TileID;
}


- (int)globalTileIDAtTile:(CGPoint)aTileCoord {
	return layerData[(int)aTileCoord.y][(int)aTileCoord.x].GlobalID;
}


- (int)tileSetIDAtTile:(CGPoint)aTileCoord {
	return layerData[(int)aTileCoord.y][(int)aTileCoord.x].TilesetID;
}


- (void)addTileAt:(CGPoint)aTileCoord tileSetID:(int)aTileSetID tileID:(int)aTileID globalID:(int)aGlobalID value:(int)aValue {
	layerData[(int)aTileCoord.y][(int)aTileCoord.x].TilesetID = aTileSetID;
	layerData[(int)aTileCoord.y][(int)aTileCoord.x].TileID = aTileID;
	layerData[(int)aTileCoord.y][(int)aTileCoord.x].GlobalID = aGlobalID;
	layerData[(int)aTileCoord.y][(int)aTileCoord.x].Value = aValue;
}

- (void)setValueAtTile:(CGPoint)aTileCoord value:(int)aValue {
	layerData[(int)aTileCoord.y][(int)aTileCoord.x].Value = aValue;
}

- (int)valueAtTile:(CGPoint)aTileCoord {
	return layerData[(int)aTileCoord.y][(int)aTileCoord.x].Value;
}

@end
