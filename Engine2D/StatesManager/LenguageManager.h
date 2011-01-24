//
//  LenguageManager.h
//  
//
//  Created by Eskema on 02/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum {
	ENGLISH,
	SPANISH,
	ITALIAN,
	DEUTSCH,
	FRENCH
}_LanguageType;


@interface LenguageManager : NSObject {
	
	_LanguageType Languages;
	NSMutableArray *TextArray;
}


@property (nonatomic, retain) NSMutableArray *TextArray;
@property (nonatomic, readwrite) _LanguageType Languages;


//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================
-(void) EmptyStrings;
-(void) LoadText:(NSString *)FileText;


@end
