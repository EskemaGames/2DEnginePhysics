//
//  Fonts.h
//  
//
//  Created by Eskema on 11/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonEngine.h"

@class Image;


@interface Fonts : NSObject {
	
	//prepare some quads for textures, vertex and coordinates
	Quad2f *cachedTexture;
	Quad2f *vertices;
	Quad2f *textureCoordinates;
	_ArrayFonts arrayFonts[256];
	Image *fontImg;
}




//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================
- (id) LoadFont:(Image *)ImageDraw   FileFont:(NSString *)fileFont;
- (void) DrawTextCenteredPosXWidth:(float)Width X:(float)X  Y:(float)Y  Scale:(float)scale  Colors:(Color4f)_colors Text:(NSString *)Text;
- (void) DrawTextCenteredY:(float)Y  Scale:(float)scale  Colors:(Color4f)_colors Text:(NSString *)Text;
- (void) DrawTextCenteredPosXWidth:(float)Width  X:(float)X  Y:(float)Y  Scale:(float)scale  Text:(NSString *)Text;
- (void) DrawTextCenteredY:(float)Y  Scale:(float)scale  Text:(NSString *)Text ;
- (void) DrawTextX:(float)x  Y:(float)y  Scale:(float)scale  Text:(NSString *)Text;
- (void) DrawTextX:(float)X  Y:(float)Y  Scale:(float)scale  Colors:(Color4f)_colors  Text:(NSString *)Text;
- (void)DrawFunTextX:(float)X  Y:(float)Y  WaveX:(int)valueA WaveY:(int)valueB  SpeedMovement:(int)valueC Text:(NSString *)Text;
- (void)DrawFunTextX:(float)X  Y:(float)Y  WaveX:(int)valueA WaveY:(int)valueB  SpeedMovement:(int)valueC Scale:(float)scale Text:(NSString *)Text;
- (void)DrawFunTextX:(float)X  Y:(float)Y  WaveX:(int)valueA WaveY:(int)valueB  SpeedMovement:(int)valueC Scale:(float)scale   Colors:(Color4f)_colors Text:(NSString *)Text;
- (int) GetTextWidth:(NSString *)text Scale:(float)scale;
- (int) GetTextHeight:(float) scale;
- (int) GetTextHeight:(float) scale myChar:(NSString *)mychar;
- (void)parseFont:(NSString*)controlFile;
- (void)parseCharacterDefinition:(NSString*)line;


@end
