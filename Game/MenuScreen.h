////////////////////////////////////
//
/// DEFINE OUR MENU SYSTEM
//
////////////////////////////////////



#import <Foundation/Foundation.h> 
#import "StateManager.h"



@class Fonts;
@class LenguageManager;
@class Widgets;
@class Image;

@interface MenuScreen : NSObject
{
	
	LenguageManager *MenuText; 


	//game sprites
	Image *SpriteGame;
	Widgets *backgroundWidget;
	Widgets *button1;
	Widgets *button2;
	Widgets *button3;

	
	StateManager* menustate;
	Fonts *FontMenu;

	int selected;
	int active;
	
	int y, Time;
	bool exitscreen;

}


//////////////////
///
///	 GENERAL FUNCTIONS
///
//////////////////

- (void) loadContent;
- (void) handleInput;
- (void) update:(float)deltaspeed;
- (void) draw;
- (void) LoadOption;
- (void) TimeOut;



@end


