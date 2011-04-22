//
//  Slider.mm
//  
//
//  Created by Alejandro Perez Perez on 26/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Slider.h"
#import "StateManager.h"



@implementation Slider

@synthesize value;  
@synthesize delegate; 
@synthesize minX, maxX;
@synthesize active;
@synthesize locAtlasBackground;
@synthesize locAtlasCap;


@synthesize touch;
@synthesize scaleText;


- (id) initSlider:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas LocAtlasCap:(Vector2f)LocAtlasCap Capsize:(Vector2f)capsize Scale:(Vector2f)Scale Active:(bool)Active Image:(Image *)image
{
	self = [super init];
	if (self != nil) {
		
		value = 0.0f;
		self._position = pos;
		self._size = Size;
		locAtlasBackground = LocAtlas;
		locAtlasCap = LocAtlasCap;
		CapPosition = Vector2fZero;
		CapSize = capsize;
		self._scale = Scale;
		touch = CGRectMake(pos.x, pos.y, self._size.x * Scale.x, self._size.y * Scale.y); 
		sliderImg = image;
		active = Active;
	}
	return self;
}



- (id) initSlider:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas LocAtlasCap:(Vector2f)LocAtlasCap Capsize:(Vector2f)capsize Scale:(Vector2f)Scale Image:(Image *)image
{
	return [self initSlider:pos Size:Size LocAtlas:LocAtlas LocAtlasCap:LocAtlasCap Capsize:capsize Scale:Scale  Active:YES Image:image];
}


- (id) initSlider:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas LocAtlasCap:(Vector2f)LocAtlasCap Capsize:(Vector2f)capsize Image:(Image *)image
{
	return [self initSlider:pos Size:Size LocAtlas:LocAtlas LocAtlasCap:LocAtlasCap Capsize:capsize Scale:Vector2fInit Active:YES Image:image];
}




- (void) dealloc
{
	[super dealloc];
}


-(float) GetSliderCenterY
{
	return self._position.y + ((self._size.y * self._scale.y) * 0.5f);
}



-(void)SetInitialSliderValue:(float)newValue
{
	if (newValue < 0.0) newValue = 0.0;
    if (newValue > 1.0) newValue = 1.0;
    value = newValue;
	
	
	CapPosition.x = (self._position.x + (value * (self._size.x * self._scale.x))) - ((CapSize.x * 0.5f) * 0.5f);
	CapPosition.y = [self GetSliderCenterY] - (CapSize.y * 0.5f); 
}



-(void)UpdateSlider
{
	StateManager *_state = [StateManager sharedStateManager];
	
	
	if ([InputManager doesRectangle:CGRectMake(self._position.x, self._position.y, self._size.x * self._scale.x, self._size.y * self._scale.y) ContainPoint:_state.input.currentState.touchLocation])
	{
		CapPosition.x = _state.input.currentState.touchLocation.x;
		
		value = (( CapPosition.x - self._position.x + ( self._size.x * self._scale.x)) / ( self._position.x - self._position.x + (self._size.x * self._scale.x)) ) - 1.0f;
		
		CapPosition.x = (self._position.x + (value * (self._size.x * self._scale.x))) - ((CapSize.x * 0.5f) * 0.5f);
		CapPosition.y = [self GetSliderCenterY] - (CapSize.y * 0.5f);
		
		[delegate valueChanged:value];
	}
	
	
}


-(void)DrawSlider
{
	if (active)
	{
		//draw slider background
		[sliderImg DrawSprites:CGRectMake(self._position.x, self._position.y , self._size.x*self._scale.x, self._size.y*self._scale.y) 
				   OffsetPoint:CGPointMake(locAtlasBackground.x, locAtlasBackground.y) 
					ImageWidth:self._size.x ImageHeight:self._size.y 
						  Flip:1 
						Colors:Color4fInit 
					  Rotation:0.0f];
		
		//draw slider cap
		[sliderImg DrawSprites:CGRectMake(CapPosition.x - (CapSize.x * 0.5f), CapPosition.y, CapSize.x, CapSize.y) 
				   OffsetPoint:CGPointMake(locAtlasCap.x, locAtlasCap.y) 
					ImageWidth:CapSize.x ImageHeight:CapSize.y 
						  Flip:1 
						Colors:Color4fInit 
					  Rotation:0.0f];
		
	}
}





@end





