//
//  Widgets.h
//  
//
//  Created by Alejandro Perez Perez on 03/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Common.h"
@class Image;
@class Fonts;



//class to handle widgets
//a widget is usually a button with or without a text
@interface Widgets : NSObject
{
	Vector2f size;
	Vector2f position;
	Vector2f locAtlas;
	Color4f color;
	Vector2f scale;
	CGRect touch;
	float rotation;
	Image *widgetImage;
	Fonts *widgetFont;
	bool active;
	float scaleText;
}


@property (readwrite) bool active;
@property (readwrite) Vector2f size;
@property (readwrite) Vector2f position;
@property (readwrite) Vector2f locAtlas;
@property (readwrite) Color4f color;
@property (readwrite) Vector2f scale;
@property (readwrite) CGRect touch;
@property (readwrite) float rotation;
@property (readwrite) float scaleText;




//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================
- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Scale:(Vector2f)Scale Rotation:(float)Rotation Active:(bool)Active Image:(Image *)image;
- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Scale:(Vector2f)Scale Rotation:(float)Rotation Active:(bool)Active Image:(Image *)image Font:(Fonts *)font;
- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Scale:(Vector2f)Scale Rotation:(float)Rotation Image:(Image *)image;
- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Scale:(Vector2f)Scale Image:(Image *)image;
- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Image:(Image *)image;
- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Scale:(Vector2f)Scale Image:(Image *)image;
- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Image:(Image *)image;



- (void) DrawWidget;
- (void) DrawWidgetFont:(NSString *)text Scale:(float)scaletext Color:(Color4f)colortext;
- (void) DrawWidgetFont:(NSString *)text;
- (int) GetCenterOfWidgetY;
- (int) GetCenterOfWidgetX;
- (int) GetWidthOfWidget;
- (int) GetHeightOfWidget;
- (int) GetPositionX;
- (int) GetPositionY;

@end
