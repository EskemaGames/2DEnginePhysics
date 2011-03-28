//
//  Slider.h
//  HappyJumper
//
//  Created by Alejandro Perez Perez on 26/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonEngine.h"
#import "SpriteBase.h"



@protocol SliderControlProtocol  

- (void) valueChanged:(float)_value;  

@end  



@interface Slider : SpriteBase {  
	float value;  
	id<SliderControlProtocol> delegate;  

	Vector2f locAtlasBackground;
	Vector2f locAtlasCap;
	Vector2f CapPosition;
	Vector2f CapSize;
	Vector2f scale;
	CGRect touch;
	Image *sliderImg;
	bool active;
}  

@property (nonatomic, assign) float value;  
@property (nonatomic, retain) id<SliderControlProtocol> delegate; 
@property (nonatomic, readwrite) float minX, maxX;
@property (nonatomic, readwrite) bool active;
@property (nonatomic, readwrite) Vector2f locAtlasBackground;
@property (nonatomic, readwrite) Vector2f locAtlasCap;
@property (nonatomic, readwrite) Vector2f scale;
@property (nonatomic, readwrite) CGRect touch;
@property (nonatomic, readwrite) float scaleText;




//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================
- (id) initSlider:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas LocAtlasCap:(Vector2f)LocAtlasCap Capsize:(Vector2f)capsize Scale:(Vector2f)Scale Active:(bool)Active Image:(Image *)image;
- (id) initSlider:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas LocAtlasCap:(Vector2f)LocAtlasCap Capsize:(Vector2f)capsize Scale:(Vector2f)Scale Image:(Image *)image;
- (id) initSlider:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas LocAtlasCap:(Vector2f)LocAtlasCap Capsize:(Vector2f)capsize Image:(Image *)image;

-(void)SetInitialSliderValue:(float)newValue;
-(void) DrawSlider;
-(void)UpdateSlider;

@end
