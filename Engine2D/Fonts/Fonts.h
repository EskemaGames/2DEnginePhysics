//
//  Fonts.h
//  
//
//  Created by Eskema on 11/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@class Image;


@interface Fonts : NSObject {
	
	//prepare some quads for textures, vertex and coordinates
	Quad2f *cachedTexture;
	Quad2f *vertices;
	Quad2f *textureCoordinates;
	_ArrayFonts arrayFonts[256];
}




//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================
- (id) LoadFont:(Image *)ImageDraw   FileFont:(NSString *)fileFont;
- (void) DrawTextCenteredPosX:(Image *)Surf_Draw  Width:(float)Width X:(float)X  Y:(float)Y  Scale:(float)scale  Colors:(Color4f)_colors Text:(NSString *)Text;
- (void) DrawTextCentered:(Image *)Surf_Draw  Lanscape:(bool)landsCape Y:(float)Y  Scale:(float)scale  Colors:(Color4f)_colors Text:(NSString *)Text;
- (void) DrawTextCenteredPosX:(Image *)Surf_Draw  Width:(float)Width  X:(float)X  Y:(float)Y  Scale:(float)scale  Text:(NSString *)Text;
- (void) DrawTextCentered:(Image *)Surf_Draw  Lanscape:(bool)landsCape Y:(float)Y  Scale:(float)scale  Text:(NSString *)Text ;
- (void) DrawText:(Image *)Surf_Draw X:(float)x  Y:(float)y  Scale:(float)scale  Text:(NSString *)Text;
- (void) DrawText:(Image *)Surf_Draw X:(float)X  Y:(float)Y  Scale:(float)scale  Colors:(Color4f)_colors  Text:(NSString *)Text;
- (int) GetTextWidth:(NSString *)text Scale:(float)scale;
- (int) GetTextHeight:(float) scale;
- (int) GetTextHeight:(float) scale myChar:(NSString *)mychar;
- (void)parseFont:(NSString*)controlFile  ImageArray:(Image *)imageArray;
- (void)parseCharacterDefinition:(NSString*)line  ImageArray:(Image *)imageArray;


@end
