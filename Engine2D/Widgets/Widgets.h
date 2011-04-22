//
//  Widgets.h
//  
//
//  Created by Alejandro Perez Perez on 03/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommonEngine.h"
#import "SpriteBase.h"


@class Fonts;



//class to handle widgets
//a widget is usually a button with or without a text
@interface Widgets : SpriteBase
{
	Vector2f locAtlas;
	Color4f color;
	CGRect touch;
	Image *widgetImage;
	Fonts *widgetFont;
	bool active;
	float scaleText;
}


@property (nonatomic, readwrite) bool active;
@property (nonatomic, readwrite) Vector2f locAtlas;
@property (nonatomic, readwrite) Color4f color;
@property (nonatomic, readwrite) CGRect touch;
@property (nonatomic, readwrite) float scaleText;




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


- (void) DrawWidget:(Vector2f)camerapos;
- (void) DrawWidget;
- (void) DrawWidgetColored:(Color4f)_color;
- (void) DrawWidgetFont:(NSString *)text Scale:(float)scaletext Color:(Color4f)colortext;
- (void) DrawWidgetFont:(NSString *)text;
- (int) GetCenterOfWidgetY;
- (int) GetCenterOfWidgetX;
- (int) GetWidthOfWidget;
- (int) GetHeightOfWidget;
- (int) GetPositionX;
- (int) GetPositionY;

@end
