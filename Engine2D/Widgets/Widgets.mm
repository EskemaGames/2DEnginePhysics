//
//  Widgets.m
//  War_Warriors
//
//  Created by Alejandro Perez Perez on 03/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Widgets.h"
#import "Image.h"
#import "Fonts.h"



@implementation Widgets


@synthesize locAtlas;
@synthesize color, touch;
@synthesize active, scaleText;


//init a widget without text, typically only a button
//usually you pass a tileset/texture atlas for the button
//pos = position on screen
//size = size of the widget
//locatlas = position of that widget within the texture atlas/spritesheet
//Color = color to apply to that image, or leave it white to use the image as it is
//scale = scale of that widget
//touch = touchable area of that widget, for tap inside
//rotation = rotation for that widget applied in degrees
// active = only active widgets are rendered on screen
//image = the atlas containing the widget or the image itself
//font = font to draw the text within the button

- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Scale:(Vector2f)Scale Rotation:(float)Rotation Active:(bool)Active Image:(Image *)image
{
	self = [super init];
	if (self != nil) {
		
		self._position = pos;
		self._size = Size;
		locAtlas = LocAtlas;
		color = Color;
		_scale = Scale;
		touch = CGRectMake(pos.x, pos.y, _size.x * Scale.x, _size.y * Scale.y); //Touch
		_rotation = Rotation;
		widgetImage = image;
		widgetFont = nil;
		active = Active;
		widgetFont = nil;
	}
	return self;
}


//init a widget with text, typically a button with text
- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Scale:(Vector2f)Scale Rotation:(float)Rotation Active:(bool)Active Image:(Image *)image Font:(Fonts *)font
{
	self = [super init];
	if (self != nil) {
		
		self._position = pos;
		self._size = Size;
		locAtlas = LocAtlas;
		color = Color;
		self._scale = Scale;
		touch = CGRectMake(pos.x, pos.y, _size.x * Scale.x, _size.y * Scale.y); //Touch
		_rotation = Rotation;
		widgetImage = image;
		active = Active;
		widgetFont = font;
	}
	return self;
}


- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Scale:(Vector2f)Scale Rotation:(float)Rotation Image:(Image *)image
{
	return [self initWidget:pos Size:Size LocAtlas:LocAtlas Color:Color Scale:Scale  Rotation:Rotation Active:YES Image:image];
}

- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Scale:(Vector2f)Scale Image:(Image *)image
{
	return [self initWidget:pos Size:Size LocAtlas:LocAtlas Color:Color Scale:Scale  Rotation:0.0f Active:YES Image:image];
}

- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Image:(Image *)image
{
	return [self initWidget:pos Size:Size LocAtlas:LocAtlas Color:Color Scale:Vector2fInit Rotation:0.0f Active:YES Image:image];
}

- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Image:(Image *)image
{
	return [self initWidget:pos Size:Size LocAtlas:LocAtlas Color:Color4fInit Scale:Vector2fInit  Rotation:0.0f Active:YES Image:image];
}

- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Scale:(Vector2f)Scale Image:(Image *)image
{
	return [self initWidget:pos Size:Size LocAtlas:LocAtlas Color:Color4fInit Scale:Scale Rotation:0.0f Active:YES Image:image];
}


- (void) dealloc
{
	widgetImage = nil;
	widgetFont = nil;
	[super dealloc];
}



//draw widget only
- (void) DrawWidget:(Vector2f)camerapos
{
	if (active)
	{
		touch = CGRectMake(self._position.x, self._position.y, self._size.x * self._scale.x, self._size.y * self._scale.y); //Touch
		[widgetImage DrawSprites:CGRectMake(self._position.x - camerapos.x , _position.y - camerapos.y, self._size.x*self._scale.x, self._size.y*self._scale.y) 
					 OffsetPoint:CGPointMake(locAtlas.x, locAtlas.y) 
					  ImageWidth:self._size.x ImageHeight:self._size.y 
							Flip:1 
						  Colors:color 
						Rotation:_rotation];
	}
	
}

- (void) DrawWidget
{
	if (active)
	{
		touch = CGRectMake(self._position.x, self._position.y, self._size.x * self._scale.x, self._size.y * self._scale.y); //Touch
		[widgetImage DrawSprites:CGRectMake(self._position.x, self._position.y,self._size.x*self._scale.x, self._size.y*self._scale.y) 
					 OffsetPoint:CGPointMake(locAtlas.x, locAtlas.y) 
					  ImageWidth:self._size.x ImageHeight:self._size.y 
							Flip:1 
						  Colors:color 
						Rotation:_rotation];
	}
	
}


- (void) DrawWidgetColored:(Color4f)_color
{
	if (active)
	{
		touch = CGRectMake(self._position.x, self._position.y, self._size.x * self._scale.x, self._size.y * self._scale.y); //Touch
		[widgetImage DrawSprites:CGRectMake(self._position.x, self._position.y,self._size.x*self._scale.x, self._size.y*self._scale.y) 
					 OffsetPoint:CGPointMake(locAtlas.x, locAtlas.y) 
					  ImageWidth:self._size.x ImageHeight:self._size.y  
							Flip:1 
						  Colors:_color 
						Rotation:_rotation];
	}
	
}

//draw a widget with some text, usually a menu button with the text "play" or whatever
- (void) DrawWidgetFont:(NSString *)text
{	
	
	if (active)
	{
		touch = CGRectMake(self._position.x, self._position.y, self._size.x * self._scale.x, self._size.y * self._scale.y); //Touch
		[widgetImage DrawSprites:CGRectMake(self._position.x, self._position.y, self._size.x *self._scale.x, self._size.y*self._scale.y) 
					 OffsetPoint:CGPointMake(locAtlas.x, locAtlas.y) 
					  ImageWidth:self._size.x ImageHeight:self._size.y 
							Flip:1 
						  Colors:color
						Rotation:_rotation];
		[widgetFont DrawTextCenteredPosXWidth:[self GetWidthOfWidget] 
											X:[self GetPositionX] 
											Y:[self GetCenterOfWidgetY] 
										Scale:_scale.x
									   Colors:color
										 Text:text];
	}
	
	
}


//draw widget with text, the text will be centered on the widget
- (void) DrawWidgetFont:(NSString *)text Scale:(float)scaletext Color:(Color4f)colortext
{
	if (active)
	{
		touch = CGRectMake(self._position.x, self._position.y, self._size.x * self._scale.x, self._size.y * self._scale.y); //Touch
		[widgetImage DrawSprites:CGRectMake(self._position.x, self._position.y,self._size.x*self._scale.x, self._size.y*self._scale.y) 
					 OffsetPoint:CGPointMake(locAtlas.x, locAtlas.y) 
					  ImageWidth:self._size.x ImageHeight:self._size.y  
							Flip:1 
						  Colors:color 
						Rotation:_rotation];
		[widgetFont DrawTextCenteredPosXWidth:[self GetWidthOfWidget] + 5
											X:[self GetPositionX] 
											Y:[self GetCenterOfWidgetY] - ([widgetFont GetTextHeight:scaletext myChar:text]/2)
										Scale:scaletext
									   Colors:colortext
										 Text:text];
	}
}




- (int) GetCenterOfWidgetY
{
	return self._position.y + (((self._size.y*_scale.y)/2)/2);
}

- (int) GetCenterOfWidgetX
{
	return self._position.x + (((self._size.x*_scale.x)/2)/2);
}


- (int) GetWidthOfWidget
{
	return self._size.x*_scale.x;
}

- (int) GetHeightOfWidget
{
	return self._size.y*_scale.y;
}

- (int) GetPositionX
{
	return self._position.x;
}

- (int) GetPositionY
{
	return self._position.y;
}



@end
