//
//
//Created by Eskema
//
//

#import "TileMaps.h"
#import "StateManager.h"
#import "TBXML.h"


@implementation Tiles
@synthesize tilesWithPhysics;
@end






@implementation TileMaps

- (id) init:(StateManager *)states_
{  
    self = [super init];
	statesManager = states_;
	WideTotalMap = HeighTotalMap = MaxColumns = MaxRows  = Layers = TileSize = indiceScroll = speedScroll = 0;
	havePhysics = NO;
	return self;  
}



// release resources when they are no longer needed.
- (void)dealloc
{	
	
	//this was previously deallocated
	//but maybe the user hit the exit button
	//before this one is destroyed
	//so check it and proceed
	if (tmpLevel)
		free(tmpLevel);
	
	
	//free level array
	for (int a = 0; a < Layers; ++a) 
	{
		for (int b = 0; b < MaxRows; ++b) 
		{
			free(level[a][b]);
		}
		free(level[a]);
	}
	free(level);

	
	//free image
	mapImg = nil;
	
	[mapName release];
	
	[super dealloc];
}



//init the tileset with the image, usually a texture atlas
//layers = how many layers will have this level
//columns = how many columns are in the map file
//rows = how many rows are in the map file
//tilesize = size of the tiles all tiles must be equal
//landscape = our game is played in landscape or portrait
//imagesizeX = the size of the image, or the size within the texture atlas
//imagesizeY = the size of the image, or the size within the texture atlas
//=============================================================================
-(void) LoadLevel:(Image *)ImageDraw  ConfigFile:(NSString *)filename Physic:(PhysicsWorld*)world
{

	if (world != nil)
	myworld = world;
	
	mapImg = ImageDraw;
	
	int ImageSizeX, ImageSizeY;
	int ImageSizeTileX, ImageSizeTileY;
	
	///// LOAD ALL THE LEVEL CONFIG FROM THE XML FILE
	TBXML *tbxml = [[TBXML alloc] initWithXMLFile:filename fileExtension:nil];
	
	// Obtain root element
	TBXMLElement * root = tbxml.rootXMLElement;
	
	// if root element is valid
	if (root) {
		// search for the first element within the root element's children
		TBXMLElement * property = [TBXML childElementNamed:@"Values" parentElement:root];
		
		TBXMLElement * object;
		NSString *name;
		
		// next element
		object = [TBXML childElementNamed:@"ImagesizeX" parentElement:property];
		name = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		ImageSizeX = [name intValue];
		
		// next element
		object = [TBXML childElementNamed:@"ImagesizeY" parentElement:property];
		name = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		ImageSizeY = [name intValue];
		
		// next element
		object = [TBXML childElementNamed:@"TileSize" parentElement:property];
		name = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		TileSize = [name intValue];

		
		// next element
		object = [TBXML childElementNamed:@"MaxRows" parentElement:property];
		name = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		MaxRows = [name intValue];
		
		// next element
		object = [TBXML childElementNamed:@"MaxColumns" parentElement:property];
		name = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		MaxColumns = [name intValue];
		
		// next element
		object = [TBXML childElementNamed:@"Layers" parentElement:property];
		name = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		Layers = [name intValue];
		
		//init the tmp level to hold the xml config for all the tiles
		object = [TBXML childElementNamed:@"TotalTiles" parentElement:property];
		name = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		tmpLevel = (Tile_Struct *)calloc([name intValue], sizeof(Tile_Struct));

		// next element
		object = [TBXML childElementNamed:@"MapName" parentElement:property];
		name = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		mapName = [[NSString alloc] initWithString:name];
		
		// next element
		object = [TBXML childElementNamed:@"LayerTiles" parentElement:property];
		name = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		LayerTiles = [name intValue];
		
		object = [TBXML childElementNamed:@"LayerCollision" parentElement:property];
		name = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		LayerCollision = [name intValue];
		
		// next element
		object = [TBXML childElementNamed:@"LayerObjects" parentElement:property];
		name = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		LayerObjects = [name intValue];
		
		// next element
		object = [TBXML childElementNamed:@"HavePhysics" parentElement:property];
		name = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		havePhysics = [name boolValue];
		
		
		//parse the tile properties like rotation, name, walkable,etc,etc
		TBXMLElement * TileProperties = [TBXML childElementNamed:@"TileProperties" parentElement:property];
		
		unsigned int i=0;
		// if the tileproperties was found
		while (TileProperties != nil) {
			
			NSString *value = [TBXML valueOfAttributeNamed:@"value" forElement:TileProperties];
			tmpLevel[i].Tilenum = [value intValue]; 
			
			value = [TBXML valueOfAttributeNamed:@"Visible" forElement:TileProperties];
			tmpLevel[i].visible = [value boolValue];
			
			value = [TBXML valueOfAttributeNamed:@"PhysicsTile" forElement:TileProperties];
			tmpLevel[i].physicsTile = [value boolValue];
			
			value = [TBXML valueOfAttributeNamed:@"Nowalkable" forElement:TileProperties];
			tmpLevel[i].nowalkable = [value boolValue];
			
			value = [TBXML valueOfAttributeNamed:@"TileAnimated" forElement:TileProperties];
			tmpLevel[i].tileAnimated = [value boolValue];
			
			value = [TBXML valueOfAttributeNamed:@"AnimatedFrames" forElement:TileProperties];
			tmpLevel[i].totalFramesAnimation = [value intValue];
			tmpLevel[i].animated = (int *)calloc(tmpLevel[i].totalFramesAnimation, sizeof(int));
			
			value = [TBXML valueOfAttributeNamed:@"Object" forElement:TileProperties];
			tmpLevel[i].object = [value boolValue];
			
			value = [TBXML valueOfAttributeNamed:@"DelaySpeed" forElement:TileProperties];
			tmpLevel[i].delaySpeed = [value intValue];
			tmpLevel[i].delay = 0;
			tmpLevel[i].nextframe = 0;

			
			// search the animation's child elements for this animation state
			TBXMLElement * props = [TBXML childElementNamed:@"propertiesAnimation" parentElement:TileProperties];
			
			int a = 0;
			// animation elements
			while (props != nil) {
				
				NSString *Num = [TBXML valueOfAttributeNamed:@"TileNum" forElement:props];
				tmpLevel[i].animated[a] = [Num intValue];
	
				//increase counter
				++a;
				
				// find the next sibling element
				props = [TBXML nextSiblingNamed:@"propertiesAnimation" searchFromElement:props];
			}
			
			//increase counter
			++i;
			
			// find the next sibling element
			TileProperties = [TBXML nextSiblingNamed:@"TileProperties" searchFromElement:TileProperties];
		}//end animation
	}
	
	//release the xml object
	[tbxml release];
	
	
	WideTotalMap = MaxColumns*TileSize; //we can take minus 1 to "fake" the limits off map
	HeighTotalMap = MaxRows*TileSize; //we can take minus 1 to "fake the limits off map
	
	//init the physics array if we need it
	if (havePhysics)
	TilesWithPhysic = [[NSMutableArray alloc] initWithCapacity:(MaxColumns*MaxRows)];

	//speed for automatic scrolling maps
	speedScroll = 1;
	
	CameraY = 0;
	indiceScroll = 0;
	

	
	//create memory to hold the map with all layers
	//init the dinamic array level
	int a,b;
	level = (Tile_Struct ***)malloc(Layers * sizeof(Tile_Struct **));
	for (a = 0; a < Layers; a++){
		level[a] = (Tile_Struct **)malloc(MaxRows * sizeof(Tile_Struct *));
		for (b = 0; b < MaxRows; b++)
			level[a][b] =
			(Tile_Struct *)malloc(MaxColumns *sizeof(Tile_Struct));
	}
	
	
	//screen size map in tiles
	tilesX = statesManager.screenBounds.x/TileSize;
	tilesY = statesManager.screenBounds.y/TileSize;
	
	//calculate image coords size, basically how many rows and columns are in that image
	ImageSizeTileX = (ImageSizeX / TileSize);
	ImageSizeTileY =  (ImageSizeY / TileSize);
	
	//create memory for arrays, vertex, coords and texture
	textureCoordinates = (Quad2f*)calloc(1, sizeof( Quad2f ) );
	mvertex = (Quad2f*)calloc( 1, sizeof( Quad2f ) );
	cachedTexture = (Quad2f*)calloc((ImageSizeTileX * ImageSizeTileY), sizeof(Quad2f));
	
	//now loop the tileset and cache all the texture coordinates
	//this will speed up things a lot
	int spriteSheetCount = 0;
    for(int i=0; i<ImageSizeTileY; i++) {
        for(int j=0; j<ImageSizeTileX; j++) {
            [mapImg cacheTexCoords:TileSize 
				  SubTextureHeight:TileSize  
				 CachedCoordinates:textureCoordinates 
					CachedTextures:cachedTexture
						   Counter:spriteSheetCount
							  PosX:j * TileSize
							  PosY:i * TileSize ];
			spriteSheetCount++;			
        }
    }
	
	[self ProcessTiles];
	
}


//=============================================================================
-(void) ProcessTiles
{
	
	//first clean the whole level to reset all
	//values to 0 and avoid problems
	[self CleanLevel];
	
	
	//now read the ".CSV" map and parse the values
	unsigned int countLayers = 0;
	while (countLayers != Layers ) {
		
		NSString *tempstr = [NSString stringWithFormat:@"%@" ,mapName ];
		int length = [tempstr length];	
		// Starting at position 0, get the rest of string minus the "0.CSV"
		NSRange range = NSMakeRange (0, (length-5)); 
		
		//now copy the new short string without the "0.CSV"
		NSString *tempName = [tempstr substringWithRange:range];

		NSMutableString *configString = [[NSMutableString alloc] initWithString:tempName];
		[configString appendFormat: @"%i",countLayers];
		[configString appendString:@".CSV"];
		
		//finally read the appropiate level
		[self ReadLevel:configString Layer:countLayers];
		
		++countLayers;
		//release the string used
		[configString release];
	}
	

	
	//index for tiles
    int index = 0;

	//now go through each layer and all map width and height
	//and add the properties we want for each tile
	//doors, walls, water, etc,etc
	for (int l = 0; l < Layers; l++){
		for(int y = 0; y < MaxRows; y++){
			for(int j = 0; j < MaxColumns; j++){
				//get the tilenum
				index = level[l][y][j].Tilenum;

				//now copy the properties to each tile of the map
				level[l][y][j].visible				= tmpLevel[index].visible;
				level[l][y][j].nowalkable			= tmpLevel[index].nowalkable;
				level[l][y][j].object				= tmpLevel[index].object;
				level[l][y][j].tileAnimated			= tmpLevel[index].tileAnimated;
				level[l][y][j].physicsTile			= tmpLevel[index].physicsTile;
				level[l][y][j].totalFramesAnimation = tmpLevel[index].totalFramesAnimation;
				level[l][y][j].delay				= tmpLevel[index].delay;
				level[l][y][j].nextframe			= tmpLevel[index].nextframe;
				level[l][y][j].delaySpeed			= tmpLevel[index].delaySpeed;
				if (level[l][y][j].tileAnimated)
				{
					level[l][y][j].animated = (int *)calloc(tmpLevel[index].totalFramesAnimation, sizeof(int));
					for (int internal = 0; internal < level[l][y][j].totalFramesAnimation; internal++) {
						level[l][y][j].animated[internal] = tmpLevel[index].animated[internal];
					}
				}
				
				//physics enabled, fill this array to setup tile blocks
				if (havePhysics)
				{
					//empty tile, just fill the array with an empty tile
					if(index == 0)
					{
						Tiles *tmp = [[Tiles alloc] init];
						[TilesWithPhysic addObject:tmp];
						[tmp release];
					}
				
					//this one is a real tile, add a static physic body 
					if (index != 0 && level[l][y][j].physicsTile)
					{
						Tiles *tmp = [[Tiles alloc] init];
						tmp.tilesWithPhysics = [[PhysicBodyBase alloc] init:b2_staticBody
															  TypeShape:BOX 
														  FixedRotation:YES 
														 BodySizeAndPos:CGRectMake(j * TileSize, y * TileSize, TileSize, TileSize) 
														   HandlerClass:tmp
																 Physic:myworld];
						tmp.position.x = j*TileSize;
						tmp.position.y = y*TileSize;
						[TilesWithPhysic addObject:tmp];
						[tmp release];		 
					}
				}

				 
			}
		}
	}
	
	//we've finished with the 
	//tmp xml file, now release the array
	//and free some memory
	if (tmpLevel)
	{
		free(tmpLevel);
		tmpLevel = NULL;
	}
	
}





//=============================================================================
-(void) CleanLevel
{
	//reset all values to 0
	for (int l = 0; l < Layers; l++)
	{
		for(int y = 0; y < MaxRows; y++)
		{
			for(int x = 0; x < MaxColumns; x++)
			{
				level[l][y][x].Tilenum = 0;
				level[l][y][x].visible = false;
				level[l][y][x].nowalkable = false;
				level[l][y][x].object = false;
				level[l][y][x].physicsTile = false;
				level[l][y][x].totalFramesAnimation = 0;
				level[l][y][x].tileAnimated = false;
				level[l][y][x].animated = NULL;
				level[l][y][x].delay = 0;
				level[l][y][x].nextframe = 0;
				level[l][y][x].delaySpeed = 0;
			}
		}
	}
	
}



//read the map file, you must specify wich layer are you loading
//remember all layers start on 0
//=============================================================================
-(void)ReadLevel:(NSString *)filemap Layer:(int)Layer
{
	NSString * path = [[NSBundle mainBundle] pathForResource:filemap ofType:nil];
	FILE *f = fopen([path cStringUsingEncoding:1],"r");
	if (f == NULL)
	NSLog(@"map file not found");

	for ( int row=0; row < MaxRows; row++) {
		for ( int column=0; column < MaxColumns; column++) {
            fscanf(f, "%d ,", &level[Layer][row][column].Tilenum);
        }
    }
    fclose(f);
}







//get the current tile in that position
//if tile is animated get the current frame to draw
- (int) getSpriteIndeX:(int)X Y:(int)Y Layer:(int)Layer 
{	
	if (level[Layer][Y][X].tileAnimated)
	{
		if (level[Layer][Y][X].delay < 0) //if delay < 0, change to next frame and reset delay counter
		{
			level[Layer][Y][X].nextframe ++;
			level[Layer][Y][X].Tilenum = level[Layer][Y][X].animated[level[Layer][Y][X].nextframe];
			
			level[Layer][Y][X].delay = level[Layer][Y][X].delaySpeed; //reset delay counter to value asigned
			
			//we reach the max frame, so reset to 0 and start over
			if (level[Layer][Y][X].nextframe == level[Layer][Y][X].totalFramesAnimation)
			{
				level[Layer][Y][X].nextframe = 0;
				level[Layer][Y][X].Tilenum = level[Layer][Y][X].animated[0];
				return  level[Layer][Y][X].Tilenum;
			}
		}
		else level[Layer][Y][X].delay --;
	}
	 
		
	return level[Layer][Y][X].Tilenum;
	
}





//=============================================================================
-(void) DrawLevelCameraX:(float)Camerax  CameraY:(float)Cameray  Layer:(int)Layer   Colors:(Color4f)_colors  
{
	//counter for all the tiles in screen
	int tile=0;
	
	//index to know the actual tile to draw
	int index = 0;
    int x,y;
	int xtile, ytile, xpos,ypos;
	
	//add calculations to achieve smooth scroll
	xtile = Camerax / TileSize;
	ytile = Cameray / TileSize;
	xpos = (int)Camerax & TileSize-1;
	ypos = (int)Cameray & TileSize-1;
	
	
	unsigned char red = _colors.red * 1.0f;
	unsigned char green = _colors.green * 1.0f;
	unsigned char blue = _colors.blue * 1.0f;
	unsigned char shortAlpha = _colors.alpha * 255.0f;
	
	//	pack all of the color data bytes into an unsigned int
	unsigned _color = (shortAlpha << 24) | (blue << 16) | (green << 8) | (red << 0);
	
	
	//we only want to render the visible screen plus 1 tile in each direcction
	// if map its more bigger than the screen resolution, that extra tile its 
	//for smooth scroll, so we only scan the screen resolution
	for (int i = 0; i < tilesY; i ++)
	{
		for (int j = 0; j < tilesX; j++)
		{
			//only draw visible tiles
			if (level[Layer][i+ytile][j+xtile].visible) 
			{
				//loop through the map
				index = [self getSpriteIndeX:j+xtile  Y:i+ytile  Layer:Layer];
				
	
				//convert map coords into pixels coords
				x=(j*TileSize) - xpos;
				y=(i*TileSize) - ypos;
				
				
				if (havePhysics)
				{
					//get the pyshic tile to interact
					Tiles *tmp = [TilesWithPhysic objectAtIndex:tile];
					tmp.position.x = x;
					tmp.position.y = y;
				}
				
				Quad2f vert = *[mapImg getVerticesForSpriteAtrect:CGRectMake(x, y, TileSize, TileSize) Vertices:mvertex Flip:1];
				
				//the textures are cached on a quad array, simply retrieve the correct texture coordinate from the array
				// Triangle #1
				[mapImg _addVertex:vert.tl_x  Y:vert.tl_y  UVX:cachedTexture[index].tl_x  UVY:cachedTexture[index].tl_y  Color:_color];
				[mapImg _addVertex:vert.tr_x  Y:vert.tr_y  UVX:cachedTexture[index].tr_x  UVY:cachedTexture[index].tr_y  Color:_color];
				[mapImg _addVertex:vert.bl_x  Y:vert.bl_y  UVX:cachedTexture[index].bl_x  UVY:cachedTexture[index].bl_y  Color:_color];
				
				// Triangle #2
				[mapImg _addVertex:vert.tr_x  Y:vert.tr_y  UVX:cachedTexture[index].tr_x  UVY:cachedTexture[index].tr_y  Color:_color];
				[mapImg _addVertex:vert.bl_x  Y:vert.bl_y  UVX:cachedTexture[index].bl_x  UVY:cachedTexture[index].bl_y  Color:_color];
				[mapImg _addVertex:vert.br_x  Y:vert.br_y  UVX:cachedTexture[index].br_x  UVY:cachedTexture[index].br_y  Color:_color];
			}
			tile++;
		}
	}//end for
	
	
}




//=============================================================================
-(void) UpdateScroll:(float)GameSpeed PauseGame:(bool)pauseGame;
{

	//the game is not paused, go ahead with the scroll
	if (!pauseGame)
	{
		//calculate speed for scroll here, higher number means more slower scroll
		if(speedScroll >= 60)
		{
			speedScroll = 1;
			indiceScroll +=0.5f;
		}
		else
			speedScroll += speedScroll * 2 * GameSpeed;

	
		//if we are at the end of the level
		//start again the map

		//update the camera position for scroll
		//128 and 120 it's just some values that fits my needs
		//feel free to change this value to modify the scrolling speed
		//higher number means slow speed
		CameraY += (indiceScroll - 128) / 120; 
	
	
		//check camera boundaries
		if (CameraY <= 0){
			CameraY = HeighTotalMap - statesManager.screenBounds.y;
			indiceScroll = 0;
		}		
	}
	

}






//scrolled maps DON'T have physics
//=============================================================================
-(void) DrawLevelWithScrollY:(bool)ScrollY Layer:(int)Layer  Colors:(Color4f)_colors GameSpeed:(float)gameSpeed PauseGame:(bool)pauseGame;
{
	
	[self UpdateScroll:gameSpeed PauseGame:pauseGame];
	int index = 0;
    int x,y;

	
	int ytile = CameraY / TileSize;
	int ypos = (int)CameraY & TileSize-1;

	
	unsigned char red = _colors.red * 1.0f;
	unsigned char green = _colors.green * 1.0f;
	unsigned char blue = _colors.blue * 1.0f;
	unsigned char shortAlpha = _colors.alpha * 255.0f;
	
	//	pack all of the color data bytes into an unsigned int
	unsigned _color = (shortAlpha << 24) | (blue << 16) | (green << 8) | (red << 0);
	
	

	// if map its more bigger than the screen resolution, that extra tile its 
	//for smooth scroll, so we only scan the screen resolution
	for (int i = 0; i < tilesY; i++)
	{
		for(int j=0; j < tilesX; j++){

			if (level[Layer][i+ytile][j].visible) 
			{
				//loop through the map
				index = [self getSpriteIndeX:j  Y:i+ytile  Layer:Layer];
		
				if (ScrollY)
				{
					//convert map coords into pixels coords
					x=(j*TileSize);
					y=(i*TileSize) - ypos;
				}
				else {
					x=(j*TileSize) - ypos;
					y=(i*TileSize);
				}

				Quad2f vert = *[mapImg getVerticesForSpriteAtrect:CGRectMake(x, y, TileSize, TileSize) Vertices:mvertex Flip:1];
				
				//the textures are cached on a quad array, simply retrieve the correct texture coordinate from the array
				// Triangle #1
				[mapImg _addVertex:vert.tl_x  Y:vert.tl_y  UVX:cachedTexture[index].tl_x  UVY:cachedTexture[index].tl_y  Color:_color];
				[mapImg _addVertex:vert.tr_x  Y:vert.tr_y  UVX:cachedTexture[index].tr_x  UVY:cachedTexture[index].tr_y  Color:_color];
				[mapImg _addVertex:vert.bl_x  Y:vert.bl_y  UVX:cachedTexture[index].bl_x  UVY:cachedTexture[index].bl_y  Color:_color];
				
				// Triangle #2
				[mapImg _addVertex:vert.tr_x  Y:vert.tr_y  UVX:cachedTexture[index].tr_x  UVY:cachedTexture[index].tr_y  Color:_color];
				[mapImg _addVertex:vert.bl_x  Y:vert.bl_y  UVX:cachedTexture[index].bl_x  UVY:cachedTexture[index].bl_y  Color:_color];
				[mapImg _addVertex:vert.br_x  Y:vert.br_y  UVX:cachedTexture[index].br_x  UVY:cachedTexture[index].br_y  Color:_color];
				
			}
		}
	}

}









//=============================================================================
-(int) SetPosLevelX:(int) x
{
    return x * TileSize;
}



//=============================================================================
-(int) SetPosLevelY:(int) y
{
    return y * TileSize;
}



-(int) GetTileNum:(int)x y:(int)y Layer:(int)l
{
    return level[l] [y / TileSize] [x /  TileSize].Tilenum;
}

//=============================================================================
-(bool) CollisionTile:(int)x  y:(int)y  Layer:(int)l
{
	//first convert pixel coords into map coords    
     return level[l][y / TileSize] [x /  TileSize].nowalkable;

}

//=============================================================================
-(bool) CollisionObjects:(int)x y:(int)y tilenum:(int)tilenum  Layer:(int)l
{
	
	int tile_num = level[l] [y / TileSize] [x /  TileSize].Tilenum;
	
	if (tile_num == level[l] [y / TileSize] [x /  TileSize].visible)
	{
        return YES;
	}
	else
		return NO;
	
}

-(bool) CollisionObjects:(int)x y:(int)y Layer:(int)l
{
	return level[l][y / TileSize] [x /  TileSize].object;
}


//=============================================================================
-(void) GetObjects:(int)x y:(int) y  Layer:(int)l
{
    level[l] [y / TileSize] [x / TileSize].visible = false;
}



//=============================================================================
-(void) RemoveObject:(int) x y:(int) y  Layer:(int)l
{
	
    level[l] [y / TileSize] [x / TileSize].visible = false;
    level[l] [y / TileSize] [x / TileSize].nowalkable = false;
}




@end




