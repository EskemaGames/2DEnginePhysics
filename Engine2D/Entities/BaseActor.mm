////////////////////////////////////////////////////////////////////
//
// BaseActor.mm
// this class controls all the actor in a game, like player, enemies
//npcs, bosses,etc.
//
////////////////////////////////////////////////////////////////////


#import "BaseActor.h"
#import "TBXML.h"


@implementation BaseActor


@synthesize Animation;
@synthesize _typeActor;

- (id) init
{
	self = [super init];
	if (self != nil) {
		m_states = [StateManager sharedStateManager];
	}
	return self;
}




// release resources when they are no longer needed.
- (void)dealloc
{
	[Animation release];
	[super dealloc];
}




//create an actor for the game
//type = wich kind of actor is, player, enemy, final boss,etc
//image = atlas or image with the sprite
//filename = the xml file with the properties for this actor
//==============================================================================
-(void) InitActorImage:(Image *)Spriteimage FileName:(NSString *)_filename
{

	rotation = 0;
	flip = 1;
	
	//assign the image
	sprtImg = Spriteimage;
	
	//init animations
	Animation = [[Animations alloc] init];
	
	//pointer to use XML files
	TBXML *tbxml;
	tbxml = [[TBXML alloc] initWithXMLFile:_filename fileExtension:nil];
	
	
	///// ANIMATIONS
	// Load and parse the xml file for animations and other config values
	// Obtain root element
	TBXMLElement * root = tbxml.rootXMLElement;
	
	// if root element is valid
	if (root) {
		
		// search for the first element within the root element's children
		TBXMLElement * property = [TBXML childElementNamed:@"properties" parentElement:root];
		
		
		TBXMLElement * object = [TBXML childElementNamed:@"PositionX" parentElement:property];
		NSString *pos = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		position.x = [pos intValue];
		
		object = [TBXML childElementNamed:@"PositionY" parentElement:property];
		pos = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		position.y = [pos intValue];
		
		object = [TBXML childElementNamed:@"Speed" parentElement:property];
		pos = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		speed = [pos floatValue];

		object = [TBXML childElementNamed:@"NumberofFrames" parentElement:property];
		pos = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		TotalFramesAnimation = [pos intValue];
		
		object = [TBXML childElementNamed:@"FixedRotation" parentElement:property];
		pos = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		FixedRotation = [pos boolValue];
		
	}
	//relase the pointer
	[tbxml release];
	

	//create memory for arrays, vertex, coords and texture
	textureCoordinates = (Quad2f*)calloc(1, sizeof( Quad2f ) );
	mvertex = (Quad2f*)calloc( 1, sizeof( Quad2f ) );
	cachedTexture = (Quad2f*)calloc(TotalFramesAnimation, sizeof(Quad2f));
	
}










//send all the quads to the Image class to render all in one batch
//==============================================================================
-(void) Draw:(Color4f)_colors
{
	unsigned char red = _colors.red * 1.0f;
	unsigned char green = _colors.green * 1.0f;
	unsigned char blue = _colors.blue * 1.0f;
	unsigned char shortAlpha = _colors.alpha * 255.0f;
	
	//	pack all of the color data bytes into an unsigned int
	unsigned _color = (shortAlpha << 24) | (blue << 16) | (green << 8) | (red << 0);
	
	//call the image class to get the vertices
	Quad2f vert = *[sprtImg getVerticesForSpriteAtrect:CGRectMake(position.x + [Animation GetFrameOffsetX], 
																  position.y + [Animation GetFrameOffsetY],
																  [Animation GetFrameSizeWidth], 
																  [Animation GetFrameSizeHeight])
											  Vertices:mvertex Flip:flip];
	
	//the textures are cached on a quad array, simply retrieve the correct texture coordinate from the array
	//call the Image class to add vertex to the array
	// Triangle #1
	[sprtImg _addVertex:vert.tl_x  Y:vert.tl_y  UVX:cachedTexture[[Animation GetActualFrame]].tl_x  UVY:cachedTexture[[Animation GetActualFrame]].tl_y  Color:_color];
	[sprtImg _addVertex:vert.tr_x  Y:vert.tr_y  UVX:cachedTexture[[Animation GetActualFrame]].tr_x  UVY:cachedTexture[[Animation GetActualFrame]].tr_y  Color:_color];
	[sprtImg _addVertex:vert.bl_x  Y:vert.bl_y  UVX:cachedTexture[[Animation GetActualFrame]].bl_x  UVY:cachedTexture[[Animation GetActualFrame]].bl_y  Color:_color];
	
	// Triangle #2
	[sprtImg _addVertex:vert.tr_x  Y:vert.tr_y  UVX:cachedTexture[[Animation GetActualFrame]].tr_x  UVY:cachedTexture[[Animation GetActualFrame]].tr_y  Color:_color];
	[sprtImg _addVertex:vert.bl_x  Y:vert.bl_y  UVX:cachedTexture[[Animation GetActualFrame]].bl_x  UVY:cachedTexture[[Animation GetActualFrame]].bl_y  Color:_color];
	[sprtImg _addVertex:vert.br_x  Y:vert.br_y  UVX:cachedTexture[[Animation GetActualFrame]].br_x  UVY:cachedTexture[[Animation GetActualFrame]].br_y  Color:_color];
	
	 
}




//for now this method doesn't support physics
//only normal pixel movement
-(void) MoveXSpeed:(float)GameSpeed
{
	// Move player right
	position.x += m_direction.x * speed * 2  * GameSpeed;
}


//for now this method doesn't support physics
//only normal pixel movement
//==============================================================================
-(void) MoveYSpeed:(float)GameSpeed
{	
	position.y += m_direction.y * speed * 2  * GameSpeed;
}



-(void)Update
{
	[Animation RefreshStates];
}


@end
