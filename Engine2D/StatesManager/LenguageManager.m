//
//  LenguageManager.m
//  
//
//  Created by Eskema on 02/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LenguageManager.h"
#import "TBXML.h"

@implementation LenguageManager


@synthesize Languages;
@synthesize TextArray;



//get the default language from the preferences of the device
//in this case I will check for spanish, otherwise english will be used
- (id) init
{
	self = [super init];
	if (self != nil) {

		//init the text array with 5 sentences to default
		TextArray = [[NSMutableArray alloc] initWithCapacity:5];
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
		NSString *currentLanguage = [languages objectAtIndex:0];
		
		//get the system lenguage and choose the text if any
		if([currentLanguage isEqualToString:@"es"]) 
		{
			Languages = SPANISH;
		}else if([currentLanguage isEqualToString:@"it"]) {
			Languages = ITALIAN;
		}
		else if([currentLanguage isEqualToString:@"de"]) {
			Languages = DEUTSCH;
		}
		else if([currentLanguage isEqualToString:@"fr"]) {
			Languages = FRENCH;
		}
		else{
			Languages = ENGLISH;
		}
	}
	return self;
}

- (void) dealloc
{
	[TextArray release];
	[super dealloc];
}




//load a xml file with the texts for the game
-(void) LoadText:(NSString *)FileText
{
	//make a string with the file
	NSMutableString *configString = [[NSMutableString alloc] initWithString: FileText];
	
	switch (Languages) {
		case ENGLISH:
			// load the appropriate lenguage file
			[configString appendString: @"EN.xml"];
			break;
		case SPANISH:
			// load the appropriate lenguage file
			[configString appendString: @"ES.xml"];
			break;
		case ITALIAN:
			// load the appropriate lenguage file
			[configString appendString: @"IT.xml"];
			break;
		case DEUTSCH:
			// load the appropriate lenguage file
			[configString appendString: @"DE.xml"];
			break;
		case FRENCH:
			// load the appropriate lenguage file
			[configString appendString: @"FR.xml"];
			break;
		default:
			break;
	}

	//if the file doesn't exists then use the default english file
	NSString *pathAndFileName = [[NSBundle mainBundle] pathForResource:configString ofType:nil];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath:pathAndFileName]) // Returns a BOOL 
	{
		[configString setString:@""];
		[configString appendString:FileText];
		[configString appendString:@"EN.xml"];
	}

	
	// Load and parse the xml file for text
	TBXML * tbxml = [[TBXML alloc] initWithXMLFile:configString fileExtension:nil];
	
	// Obtain root element
	TBXMLElement * root = tbxml.rootXMLElement;
	
	// if root element is valid
	if (root) {
		// search for the first element within the root element's children
		TBXMLElement * desc1 = [TBXML childElementNamed:@"text" parentElement:root];
		
		// if an animation element was found
		while (desc1 != nil) {
			
			NSString *text1 = [TBXML textForElement:desc1];
			[TextArray addObject:text1];
			
			// find the next sibling element
			desc1 = [TBXML nextSiblingNamed:@"text" searchFromElement:desc1];
		}//end loop
	}
	[tbxml release];
	
	//release the string
	[configString release];

}



-(void) EmptyStrings
{
	[TextArray release];
}







@end
