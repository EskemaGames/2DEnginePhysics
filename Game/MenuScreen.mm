
#import "MenuScreen.h"
#import "Fonts.h"
#import "LenguageManager.h"
#import "Widgets.h"
#import "Image.h"

@implementation MenuScreen






- (id) init
{  
    self = [super init]; 
	menustate = [StateManager sharedStateManager]; 

	[self loadContent];
	
    return self;  
}



// release resources when they are no longer needed.
- (void)dealloc
{	
	[super dealloc];
	
}




- (void) loadContent  
{ 

	
	//sprites to draw the button and the buttons
	SpriteGame  = [[Image alloc] initWithTexture:@"mainmenu.png"  filter:GL_NEAREST Use32bits:YES TotalVertex:2000];

	
	//init the font
	FontMenu  = [[Fonts alloc] LoadFont:SpriteGame FileFont:@"gunexported.fnt"];

	MenuText = [[LenguageManager alloc] init];
	[MenuText LoadText:@"menu"];
	
 


	//used for selected option
	selected = 0;
	
	//active to mark load
	active = 0;
	

	
	y = 0;
	Time = 2;
	exitscreen = NO;
	
	
	button1 = [[Widgets alloc] initWidget:Vector2fMake((menustate.screenBounds.x*0.5f)-60, (menustate.screenBounds.y*0.5f) - 40)
									 Size:Vector2fMake(40.0f, 40.0f)
								 LocAtlas:Vector2fMake(472.0f, 152.0f)
									Color:Color4fInit 
									Scale:Vector2fMake(1.0f, 1.0f)
								 Rotation:0.0f 
								   Active:YES
									Image:SpriteGame
									 Font:FontMenu];
	
	button2 = [[Widgets alloc] initWidget:Vector2fMake((menustate.screenBounds.x*0.5f)-60, (menustate.screenBounds.y*0.5f) + ([button1 GetHeightOfWidget]*0.5f)  )
									 Size:Vector2fMake(40.0f, 40.0f)
								 LocAtlas:Vector2fMake(472.0f, 152.0f)
									Color:Color4fInit 
									Scale:Vector2fMake(1.0f, 1.0f)
								 Rotation:0.0f 
								   Active:YES
									Image:SpriteGame
									 Font:FontMenu];
	
	button3 = [[Widgets alloc] initWidget:Vector2fMake((menustate.screenBounds.x*0.5f)-60, (menustate.screenBounds.y*0.5f) + [button1 GetHeightOfWidget] + [button2 GetHeightOfWidget] +10)
									 Size:Vector2fMake(40.0f, 40.0f)
								 LocAtlas:Vector2fMake(472.0f, 152.0f)
									Color:Color4fInit 
									Scale:Vector2fMake(1.0f, 1.0f)
								 Rotation:0.0f
								   Active:YES
									Image:SpriteGame
									 Font:FontMenu];


	backgroundWidget = [[Widgets alloc] initWidget:Vector2fZero
											  Size:Vector2fMake(menustate.screenBounds.x, menustate.screenBounds.y)
										  LocAtlas:Vector2fMake(0, 192)
											 Image:SpriteGame];

}




- (void) unloadContent  
{  
	[MenuText release];
	[button1 release];
	[button2 release];
	[button3 release];
	[backgroundWidget release];
	[FontMenu release];
	[SpriteGame release];
	[self dealloc];
} 





-(void) TimeOut
{
	
	if( !( y%43 ) ) //55 its some value that fit my needs
	{
		Time--;
	}
	y++;
	
	if(Time <= 0)
	{
		[self LoadOption];
	
	}
}


-(void) LoadOption
{
	if (selected == 1 || selected == 2 || selected == 3)
	{
		exitscreen = YES;
	}
}







- (void) handleInput
{  	
	
	if (active == 0)
	{
		if ([menustate.input isButtonPressed:button1.touch Active:button1.active])  
		{  
			selected = 1;
			active = 1;
		} 
		if ([menustate.input isButtonPressed:button2.touch Active:button2.active])  
		{  
			selected = 2;
			active = 1;
		}
		if ([menustate.input isButtonPressed:button3.touch Active:button3.active])  
		{  
			selected = 3;
			active = 1;
		}
	}
	
	
} 












- (void) update:(float)deltaspeed 
{  

	if (selected != 0)
	{
		if (Time > 0)
		{
			[self TimeOut];
		}
	}
	

	//when exitscreen update the transition
	//when the transition finish change the screen
	if (exitscreen)
	{
		if (!menustate.fadeOut)
		{
			[menustate UpdateTransitionOut:deltaspeed];
		}
		else{
			switch (selected) {
				case 1:
					[menustate ChangeStates:PLAYNOPHYSICS];
					[self unloadContent];
					break;
					
				case 2:
					[menustate ChangeStates:PLAY];
					[self unloadContent];
					break;
					
					
				case 3:
					[menustate ChangeStates:PLAYTILEDMAP];
					[self unloadContent];
					break;
			}
		}
	}
}  






- (void) draw 
{ 
	//draw the backgroud widget
	[backgroundWidget DrawWidget];
	
	//draw all sprites without alpha
	[SpriteGame RenderToScreenActiveBlend:NO];
	
	
	//turn now to prepare the next batch, the fonts have alpha, so 
	//this batch need to enable the gl_blend state
	[button1 DrawWidgetFont:[MenuText.TextArray objectAtIndex:0]];
	[button2 DrawWidgetFont:[MenuText.TextArray objectAtIndex:1]];
	[button3 DrawWidgetFont:[MenuText.TextArray objectAtIndex:2]];
	
	//draw all alpha sprites
	[SpriteGame RenderToScreenActiveBlend:YES];
	
	
	

	//draw transition when we select one option
	if (selected !=0)
		[menustate fadeBackBufferToBlack:menustate.alphaOut];
		
}  





@end






