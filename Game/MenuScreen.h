////////////////////////////////////
//
/// DEFINE OUR MENU SYSTEM
//
////////////////////////////////////



#import <Foundation/Foundation.h> 
#import "StateManager.h"



@class SoundManager;
@class Fonts;
@class LenguageManager;
@class Widgets;
@class Image;

@interface MenuScreen : NSObject
{
	
	LenguageManager *MenuText; 
	//sound
	SoundManager *sharedSoundManager;

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
- (id) init:(StateManager *)states_; 
- (void) loadContent;
- (void) handleInput:(InputManager *)inputmenu;
- (void) update:(float)deltaspeed;
- (void) draw;
- (void) LoadOption;
- (void) TimeOut;



@end


