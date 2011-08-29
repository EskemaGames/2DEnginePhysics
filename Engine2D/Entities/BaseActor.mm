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


@synthesize _Animation;
@synthesize _typeActor;
@synthesize _m_direction;
@synthesize _boundigxBox;

- (id) init
{
	self = [super init];
	if (self != nil) {
		m_states = [StateManager sharedStateManager];
		//init animations
		_Animation = [[Animations alloc] init];
	}
	return self;
}




// release resources when they are no longer needed.
- (void)dealloc
{
	[_Animation release];
	[super dealloc];
}




//create an actor for the game
//type = wich kind of actor is, player, enemy, final boss,etc
//image = atlas or image with the sprite
//filename = the xml file with the properties for this actor
//==============================================================================
-(void) InitActorImage:(Image *)Spriteimage FileName:(NSString *)_filename 
{
	
	_boundigxBox = CGRectZero;
	
	_rotation = 0;
	_flip = 1;
	_scale = Vector2fInit;
	
	//assign the image
	sprtImg = Spriteimage;
	
	
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
		_position.x = [pos intValue];
		
		object = [TBXML childElementNamed:@"PositionY" parentElement:property];
		pos = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		_position.y = [pos intValue];
		
		
		object = [TBXML childElementNamed:@"NumberofFrames" parentElement:property];
		pos = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		_TotalFramesAnimation = [pos intValue];
		
		object = [TBXML childElementNamed:@"FixedRotation" parentElement:property];
		pos = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		_FixedRotation = [pos boolValue];
		
		object = [TBXML childElementNamed:@"Speed" parentElement:property];
		pos = [TBXML valueOfAttributeNamed:@"value" forElement:object];
		_speed = [pos floatValue ];
		
	}
	//relase the pointer
	[tbxml release];
	
	
	_cameraPosition = Vector2fMake(0, 0);
	
	//create memory for arrays, vertex, coords and texture
	textureCoordinates = (Quad2f*)calloc(1, sizeof( Quad2f ) );
	mvertex = (Quad2f*)calloc( 1, sizeof( Quad2f ) );
	cachedTexture = (Quad2f*)calloc(_TotalFramesAnimation, sizeof(Quad2f));
	
	
}






-(void)SetDirectionX:(float)direction
{
	_m_direction.x = direction;
}


-(void)SetDirectionY:(float)direction
{
	_m_direction.y = direction;
}

-(float)GetDirectionX
{
	return _m_direction.x;
}


-(Vector2f)GetDirection
{
	return _m_direction;
}


-(void)SetCameraPosition:(Vector2f)camerapos
{
	_cameraPosition = Vector2fMake(camerapos.x, camerapos.y);
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
	
	//apply rotation if any
	if (_rotation != 0.0f)
	{
		//rotate the quad using coregraphics functions
		CGPoint topleft = CGPointMake(_position.x, _position.y);
		CGPoint topright = CGPointMake( _position.x + [_Animation GetFrameSizeWidth], _position.y);
		CGPoint bottomleft = CGPointMake( _position.x, _position.y + [_Animation GetFrameSizeHeight]);
		CGPoint bottomright = CGPointMake( _position.x + [_Animation GetFrameSizeWidth], _position.y + [_Animation GetFrameSizeHeight]);
		
		CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(_position.x + ([_Animation GetFrameSizeWidth] * 0.5f), _position.y + ([_Animation GetFrameSizeHeight] * 0.5f));
		float degrees = DEGREES_TO_RADIANS(_rotation);
		CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(degrees);
		CGAffineTransform customRotation = CGAffineTransformConcat(CGAffineTransformConcat( CGAffineTransformInvert(translateTransform), rotationTransform), translateTransform);
		
		CGPoint rotatedtl = CGPointApplyAffineTransform(topleft, customRotation);
		CGPoint rotatedtr = CGPointApplyAffineTransform(topright, customRotation);
		CGPoint rotatedbl = CGPointApplyAffineTransform(bottomleft, customRotation);
		CGPoint rotatedbr = CGPointApplyAffineTransform(bottomright, customRotation);
		
		
		
		
		//now add the triangles to the vertex array cache
		// Triangle #1
		[sprtImg _addVertex:rotatedtl.x  Y:rotatedtl.y  UVX:cachedTexture[[_Animation GetActualFrame]].tl_x  UVY:cachedTexture[[_Animation GetActualFrame]].tl_y  Color:_color];
		[sprtImg _addVertex:rotatedtr.x  Y:rotatedtr.y  UVX:cachedTexture[[_Animation GetActualFrame]].tr_x  UVY:cachedTexture[[_Animation GetActualFrame]].tr_y  Color:_color];
		[sprtImg _addVertex:rotatedbl.x  Y:rotatedbl.y  UVX:cachedTexture[[_Animation GetActualFrame]].bl_x  UVY:cachedTexture[[_Animation GetActualFrame]].bl_y  Color:_color];
		
		// Triangle #2
		[sprtImg _addVertex:rotatedtr.x  Y:rotatedtr.y  UVX:cachedTexture[[_Animation GetActualFrame]].tr_x  UVY:cachedTexture[[_Animation GetActualFrame]].tr_y  Color:_color];
		[sprtImg _addVertex:rotatedbl.x  Y:rotatedbl.y  UVX:cachedTexture[[_Animation GetActualFrame]].bl_x  UVY:cachedTexture[[_Animation GetActualFrame]].bl_y  Color:_color];
		[sprtImg _addVertex:rotatedbr.x  Y:rotatedbr.y  UVX:cachedTexture[[_Animation GetActualFrame]].br_x  UVY:cachedTexture[[_Animation GetActualFrame]].br_y  Color:_color];
	}
	else {
		//call the image class to get the vertices
		Quad2f vert = *[sprtImg getVerticesForSpriteAtrect:CGRectMake(_position.x + [_Animation GetFrameOffsetX] - _cameraPosition.x,
																	  _position.y + [_Animation GetFrameOffsetY] - _cameraPosition.y,
																	  [_Animation GetFrameSizeWidth] * _scale.x, 
																	  [_Animation GetFrameSizeHeight] * _scale.y)
												  Vertices:mvertex Flip:_flip];
		
		//the textures are cached on a quad array, simply retrieve the correct texture coordinate from the array
		//call the Image class to add vertex to the array
		// Triangle #1
		[sprtImg _addVertex:vert.tl_x  Y:vert.tl_y  UVX:cachedTexture[[_Animation GetActualFrame]].tl_x  UVY:cachedTexture[[_Animation GetActualFrame]].tl_y  Color:_color];
		[sprtImg _addVertex:vert.tr_x  Y:vert.tr_y  UVX:cachedTexture[[_Animation GetActualFrame]].tr_x  UVY:cachedTexture[[_Animation GetActualFrame]].tr_y  Color:_color];
		[sprtImg _addVertex:vert.bl_x  Y:vert.bl_y  UVX:cachedTexture[[_Animation GetActualFrame]].bl_x  UVY:cachedTexture[[_Animation GetActualFrame]].bl_y  Color:_color];
		
		// Triangle #2
		[sprtImg _addVertex:vert.tr_x  Y:vert.tr_y  UVX:cachedTexture[[_Animation GetActualFrame]].tr_x  UVY:cachedTexture[[_Animation GetActualFrame]].tr_y  Color:_color];
		[sprtImg _addVertex:vert.bl_x  Y:vert.bl_y  UVX:cachedTexture[[_Animation GetActualFrame]].bl_x  UVY:cachedTexture[[_Animation GetActualFrame]].bl_y  Color:_color];
		[sprtImg _addVertex:vert.br_x  Y:vert.br_y  UVX:cachedTexture[[_Animation GetActualFrame]].br_x  UVY:cachedTexture[[_Animation GetActualFrame]].br_y  Color:_color];
		
	}
}




//for now this method doesn't support physics
//only normal pixel movement
-(void) MoveXSpeed:(float)GameSpeed
{
	// Move sprite right/left
	_position.x += _m_direction.x * _speed * 2  * GameSpeed;
}


//for now this method doesn't support physics
//only normal pixel movement
//==============================================================================
-(void) MoveYSpeed:(float)GameSpeed
{	
	//move sprite up/down
	_position.y += _m_direction.y * _speed * 2  * GameSpeed;
}




-(void)Update
{
	[_Animation RefreshStates];
    
    
    //update our size values, the box2d class will use the size parameter
    //in order to get the sprite values, so update it here to get always the proper size
	_size.x = [_Animation GetFrameSizeWidth];
    _size.y = [_Animation GetFrameSizeHeight];
}





-(int)DetectCollision:(BaseActor *)sprCollision Actor2:(BaseActor *)thisActor CustomCollision:(bool)centered
{
	int collision = 0;
	
	//update the bounding box for collision before test it
	[sprCollision UpdateBoundingBox];
	[thisActor UpdateBoundingBox];
	
	//if collision is not centered we will calculate the bounding box here
	if (!centered)
	{
		if (thisActor._position.x + [thisActor._Animation GetFrameSizeWidth] > sprCollision._position.x &&
			thisActor._position.x < sprCollision._position.x + [sprCollision._Animation GetFrameSizeWidth] &&
			thisActor._position.y + [thisActor._Animation GetFrameSizeHeight] > sprCollision._position.y &&
			thisActor._position.y < sprCollision._position.y + [sprCollision._Animation GetFrameSizeHeight])
			collision = 1;
	}
	//otherwise this means we defined the bounding box first in the entity class and this bounding box is more accurate
	else {
		if ( (thisActor._boundigxBox.origin.x + thisActor._boundigxBox.size.width) > sprCollision._boundigxBox.origin.x &&
			thisActor._boundigxBox.origin.x < (sprCollision._boundigxBox.origin.x + sprCollision._boundigxBox.size.width) &&
			(thisActor._boundigxBox.origin.y + thisActor._boundigxBox.size.height)  > sprCollision._boundigxBox.origin.y &&
			thisActor._boundigxBox.origin.y < (sprCollision._boundigxBox.origin.y + sprCollision._boundigxBox.size.height) )
			collision = 1;
	}
	
	return collision;	
}



//just for testing purposes this can draw a box sorrounding the sprite
-(void) drawBoundigBox:(CGRect) aRect {
	
	glColor4f(128.0, 128.0, 128.0, 1.0);
	// Setup the array used to store the vertices for our rectangle
	GLfloat vertices[8];
	
	// Using the CGRect that has been passed in, calculate the vertices we
	// need to render the rectangle
	vertices[0] = aRect.origin.x;
	vertices[1] = aRect.origin.y;
	vertices[2] = aRect.origin.x + aRect.size.width;
	vertices[3] = aRect.origin.y;
	vertices[4] = aRect.origin.x + aRect.size.width;
	vertices[5] = aRect.origin.y + aRect.size.height;
	vertices[6] = aRect.origin.x;
	vertices[7] = aRect.origin.y + aRect.size.height;
	
	// Disable the color array and switch off texturing
	glDisableClientState(GL_COLOR_ARRAY);
	glDisable(GL_TEXTURE_2D);
	
	// Set up the vertex pointer to the array of vertices we have created and
	// then use GL_LINE_LOOP to render them
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glDrawArrays(GL_LINE_LOOP, 0, 4);
	
	// Switch the color array back on and enable textures.  This is the default state
	// for our game engine
	glEnableClientState(GL_COLOR_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
}

-(void)UpdateBoundingBox
{
}

@end
