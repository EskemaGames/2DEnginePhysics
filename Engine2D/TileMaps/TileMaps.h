////////////////////////////////////////////////////////////////////
//
// TileMaps.h
// 
// class made to work with arrays maps of Mappy
//
// http://www.tilemap.co.uk/mappy.php
//
// this class load the levels, draw levels, and manage colisions
//
// Created by Eskema
//
////////////////////////////////////////////////////////////////////




#import <Foundation/Foundation.h> 
@class StateManager;
#import "Image.h"
#import "defines.h"
#import "SpriteBase.h"





//this class will handle the tiles with physics
//==============================================================================
@interface Tiles :  SpriteBase  
{  
	SpriteBase *tilesWithPhysics;	
}

@property (retain) SpriteBase *tilesWithPhysics;

@end









//==============================================================================
typedef struct Tiles2 {
	int     Tilenum;
	bool	visible;
	bool	nowalkable;
	bool	tileAnimated;
	bool	object;
	bool	physicsTile;
	int		totalFramesAnimation;
	int		*animated;
	int		delay, nextframe;
	int		delaySpeed;
} Tile_Struct;






//==============================================================================
@interface TileMaps : NSObject  
{  
	//array to add all the tiles with physics applied
	NSMutableArray *TilesWithPhysic;
	
	//define if we use physics in this level or not
	bool havePhysics;
	
	//simply pointer to get the actual physics world, needed to store a reference
	PhysicsWorld *myworld;
	
	//used to get the screen size
	StateManager *statesManager;
	
	//widht and height map in PIXELS = wide*TILESIZE
	int WideTotalMap;
	int HeighTotalMap;
	
	//columns and rows of our map in TILES 
	int MaxColumns;
	int MaxRows;
	
	//how many layers we have in maps
	int Layers;
	
	//the number of the collision and objects layer
	//used to get what is the layer to check collisions or objects
	//layertiles is the layer 0
	//layercollision is layer 1
	//layerobjects is layer 2
	int LayerTiles, LayerCollision, LayerObjects;
	
	//size of tiles
	int TileSize;
	
	//used for scroll map if we need it
	float indiceScroll;
	
	//float speed for automatic scroll map
	float speedScroll;
	
	//our struct tilemap dynamic
	Tile_Struct ***level;
	
	// a copy of the struct, used to read the values from the xml file
	// after the file is readed and processed on ProcessTiles() we destroy
	// it to free the memory wasted
	Tile_Struct *tmpLevel;
	
	//the map .CSV name, we store a reference here to parse it during the init process
	NSString *mapName;

	
	//tiles X,Y
	int tilesX, tilesY;
	float CameraY;
	float CameraX;
	bool ScrollX, ScrollY;
	bool ScrollXForward, ScrollYForward;
	
	//image reference to store the spritesheet to work with
	Image *mapImg;
	// Array used to store texture coords and vertices info for rendering
	Quad2f *cachedTexture;
	Quad2f *textureCoordinates;
	Quad2f *mvertex;
}
	
	





//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================



//reset all values to 0
-(void) CleanLevel;


//copy the tmp map to our level
//-(void) ReadLevel:(struct map *)ourmap Layer:(int)Layer;
-(void)ReadLevel:(NSString *)filemap Layer:(int)Layer;

//init the tilesheet and values for map
-(void) LoadLevel:(Image *)ImageDraw  ConfigFile:(NSString *)filename Physic:(PhysicsWorld*)world;

//assign the properties to each tile in our map
-(void) ProcessTiles;
//get the tile index to draw that tile
- (int) getSpriteIndeX:(int)X Y:(int)Y Layer:(int)Layer;


//normal maps can use physics or not
//draw level
-(void) DrawLevelCameraX:(float)Camerax  CameraY:(float)Cameray  Layer:(int)Layer   Colors:(Color4f)_colors;


//update scroll
-(void) UpdateScroll:(float)GameSpeed;

//scrolled maps DON'T have physics
//turn now to draw the level, choose between an automatic scroll or a fixed map with movement controlled by the player
-(void) DrawLevelWithScrollLayer:(int)Layer Colors:(Color4f)_colors;

//convert map coords in pixels coords in x,y
//remember levels start at position 0,0
-(int) SetPosLevelX:(int)x;
-(int) SetPosLevelY:(int)y;
-(int) GetTileNum:(int)x y:(int)y Layer:(int)l;
-(bool) CollisionTile:(int) x y:(int) y  Layer:(int)l;
-(bool) CollisionObjects:(int)x y:(int)y tilenum:(int)tilenum  Layer:(int)l;
-(bool) CollisionObjects:(int)x y:(int)y Layer:(int)l;
-(void) GetObjects:(int)x y:(int) y  Layer:(int)l;
-(void) RemoveObject:(int) x y:(int) y  Layer:(int)l;

@end
	






