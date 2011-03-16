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

- (void)dealloc {

	//free level array
	for (int a = 0; a < 4; ++a) 
	{
		for (int b = 0; b < layerHeight; ++b) 
		{
			free(layerData[a][b]);
		}
		free(layerData[a]);
	}
	free(layerData);
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
		int a,b;
		layerData = (int ***)malloc(4 * sizeof(int **));
		for (a = 0; a < 4; a++){
			layerData[a] = (int **)malloc(layerHeight * sizeof(int *));
			for (b = 0; b < layerHeight; b++)
				layerData[a][b] =
				(int *)malloc(layerWidth *sizeof(int));
		}
	}
	return self;
}



- (int)tileIDAtTile:(CGPoint)aTileCoord {
	return layerData[1][(int)aTileCoord.y][(int)aTileCoord.x];
}


- (int)globalTileIDAtTile:(CGPoint)aTileCoord {
	return layerData[2] [(int)aTileCoord.y][(int)aTileCoord.x];
}


- (int)tileSetIDAtTile:(CGPoint)aTileCoord {
	return layerData[0][(int)aTileCoord.y][(int)aTileCoord.x];
}


- (void)addTileAt:(CGPoint)aTileCoord tileSetID:(int)aTileSetID tileID:(int)aTileID globalID:(int)aGlobalID value:(int)aValue {
	layerData[0][(int)aTileCoord.y][(int)aTileCoord.x] = aTileSetID;
	layerData[1][(int)aTileCoord.y][(int)aTileCoord.x] = aTileID;
	layerData[2][(int)aTileCoord.y][(int)aTileCoord.x] = aGlobalID;
	layerData[3][(int)aTileCoord.y][(int)aTileCoord.x] = aValue;
}

- (void)setValueAtTile:(CGPoint)aTileCoord value:(int)aValue {
	layerData[3][(int)aTileCoord.y][(int)aTileCoord.x] = aValue;
}

- (int)valueAtTile:(CGPoint)aTileCoord {
	return layerData[3][(int)aTileCoord.y][(int)aTileCoord.x];
}

@end
