//
//  PlayerShip.m
//  test
//
//  Created by Alejandro Perez Perez on 05/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PlayerShip.h"
#import "TBXML.h"
#import "PhysicsWorld.h"


@implementation PlayerShip





- (id) initImage:(Image *)Spriteimage FileName:(NSString *)_filename Physic:(PhysicsWorld*)world TypeShape:(bodyTpes)typeshape
{
	self = [super init];
	if (self != nil) {
		
		[super InitActorImage:Spriteimage FileName:_filename];
		
		//pointer to use XML files
		TBXML *tbxml;
		
		tbxml = [[TBXML alloc] initWithXMLFile:_filename fileExtension:nil];
		
		
		///// ANIMATIONS
		// Load and parse the xml file for animations and other config values
		// Obtain root element
		TBXMLElement * root = tbxml.rootXMLElement;
		
		// if root element is valid
		if (root) {
			
			// search for the first element within the root element's children
			TBXMLElement * property = [TBXML childElementNamed:@"properties" parentElement:root];
			
			// search for the first element within the root element's children
			TBXMLElement * animation = [TBXML childElementNamed:@"animation" parentElement:property];
			
			//counter to cache how many sprites we found
			int i = 0;
			
			// if an animation element was found
			while (animation != nil) {
				
				NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:animation];
				NSString *frame = [TBXML valueOfAttributeNamed:@"frame" forElement:animation];
				NSString *_speed = [TBXML valueOfAttributeNamed:@"speed" forElement:animation];
				

				//each animation have it's own array
				//init the size propertly
				if([name isEqualToString:@"Stopped"])
				{
					[Animation InitArray:STOPPED Number:[frame intValue]];
				}

				if([name isEqualToString:@"MoveLeft"])
				{
					[Animation InitArray:MOVELEFT Number:[frame intValue]];
				}
				
				if([name isEqualToString:@"MoveRight"])
				{
					[Animation InitArray:MOVERIGHT Number:[frame intValue]];
				}
				
				if([name isEqualToString:@"MoveDown"])
				{
					[Animation InitArray:MOVEDOWN Number:[frame intValue]];
				}
				
				if([name isEqualToString:@"MoveUp"])
				{
					[Animation InitArray:MOVEUP Number:[frame intValue]];
				}
				
				if([name isEqualToString:@"Dead"])
				{
					[Animation InitArray:DEAD Number:[frame intValue]];
				}
				
				if([name isEqualToString:@"Dying"])
				{
					[Animation InitArray:DYING Number:[frame intValue]];
				}
				
				
				// search the animation's child elements for this animation state
				TBXMLElement * props = [TBXML childElementNamed:@"propertiesAnimation" parentElement:animation];
				
				// animation elements
				while (props != nil) {
					
					NSString *Num = [TBXML valueOfAttributeNamed:@"Num" forElement:props];
					NSString *End = [TBXML valueOfAttributeNamed:@"EndAnimation" forElement:props];
					NSString *X = [TBXML valueOfAttributeNamed:@"LocX" forElement:props];
					NSString *Y = [TBXML valueOfAttributeNamed:@"LocY" forElement:props];
					NSString *Width = [TBXML valueOfAttributeNamed:@"Width" forElement:props];
					NSString *Height = [TBXML valueOfAttributeNamed:@"Height" forElement:props];
					
					if([name isEqualToString:@"Stopped"])
					{
						[Animation LoadAnimation:STOPPED   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i];
					}
					
					if([name isEqualToString:@"MoveLeft"])
					{
						[Animation LoadAnimation:MOVELEFT   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i];
					}
					
					if([name isEqualToString:@"MoveRight"])
					{
						[Animation LoadAnimation:MOVERIGHT   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i];
					}
					
					if([name isEqualToString:@"MoveDown"])
					{
						[Animation LoadAnimation:MOVEDOWN   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i];
					}
					
					if([name isEqualToString:@"MoveUp"])
					{
						[Animation LoadAnimation:MOVEUP   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i];
					}
					
					if([name isEqualToString:@"Dead"])
					{
						[Animation LoadAnimation:DEAD   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i];
					}
					
					if([name isEqualToString:@"Dying"])
					{
						[Animation LoadAnimation:DYING   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i];
					}
					

					//cache this sprite frame, this improves the perfomance a lot
					//precalculate here all the frames coordinates will help framerate
					[baseImg cacheTexCoords:[Width intValue]
						   SubTextureHeight:[Height intValue]  
						  CachedCoordinates:textureCoordinates 
							 CachedTextures:cachedTexture
									Counter:i
									   PosX:[X intValue]
									   PosY:[Y intValue]];
					
					//increase counter
					++i;
					
					// find the next sibling element named "book"
					props = [TBXML nextSiblingNamed:@"propertiesAnimation" searchFromElement:props];
				}
				
				// find the next sibling element
				animation = [TBXML nextSiblingNamed:@"animation" searchFromElement:animation];
			}//end animation
			
			
		}
		//relase the pointer
		[tbxml release];
			
	
		
		//put a default animation state
		[Animation ChangeStatesAndResetAnim:STOPPED];
		
		

		if (world != nil)
		{
			physicsEnabled = YES;
		//create a physic body for this player class
		physicBody = [[PhysicBodyBase alloc] init:b2_dynamicBody 
										TypeShape:typeshape 
									FixedRotation:FixedRotation 
								   BodySizeAndPos:CGRectMake(position.x,position.y,[Animation GetFrameSizeWidth],[Animation GetFrameSizeHeight]) 
										   HandlerClass:self
										   Physic:world];
		}
		else {
			physicsEnabled = NO;
		}

	}
	return self;
}



- (void) dealloc
{
	[super dealloc];
}





//==============================================================================
-(void) Update:(float)deltaTime  Touchlocation:(CGPoint)Touchlocation
{
	//c = a - b
	Vector2f tp1 = Vector2fMake(position.x, position.y);
	Vector2f tp2 = Vector2fMake(Touchlocation.x, Touchlocation.y);
	Vector2f tp3 = Vector2fSub(tp1, tp2);
	
	//make enough room to handle the thumb propertly
	if (tp3.x <= 84 && tp3.x > -84 && tp3.y <= 60 && tp3.y > -120)
	{
		position.x = Touchlocation.x - (size.x/2);
		position.y = Touchlocation.y - 70;

		if (physicsEnabled)
		physicBody.body->SetLinearVelocity(b2Vec2(position.x/PTM_RATIO * speed, position.y/PTM_RATIO * speed));
		
	}

	
	
	//call parent class to update the entity
	[super Update];

}







//
//
// STATES FOR ANIMATIONS AND BEHAVIOUR OF THE PLAYER
//
//
//=============================================================================
-(void) StateStopped
{
	
	//when we are stopped check if we can move
	//in that case change the animations to move
    if ( MoveLeft == true )
    {
		[Animation ChangeStates:MOVELEFT];
    }
    else if ( MoveRight == true )
    {
		[Animation ChangeStates:MOVERIGHT];
    }
    else if ( MoveUp == true )
    {
		[Animation ChangeStates:MOVEUP];
		
	}
    else if ( MoveDown == true )
    {
		[Animation ChangeStates:MOVEDOWN];
	}
	
	
}






//==============================================================================
-(void) StateWalking
{
	
	//now we are in move, so change again the animation to move
	//and increase the move function, adding the speed in the direction needed
    if ( MoveLeft == true )
    {
		[Animation ChangeStates:MOVERIGHT];
		//[self Move:x-speed Y:y];
    }
	else if ( MoveRight == true )
    {
		[Animation ChangeStates:MOVERIGHT];
		//[self Move:x+speed Y:y];
	}
    else if ( MoveUp == true )
    {
		[Animation ChangeStates:MOVEUP];
		//[self Move:x Y:y-speed];
	}
    else if ( MoveDown == true )
    {
		[Animation ChangeStates:MOVEDOWN];
		//[self Move:x Y:y+speed];
	}
	
	
	//if the player stops, stop its animation
	if ((MoveLeft == false) && (MoveRight == false) && (MoveUp == false) && (MoveDown == false))
    {
        [Animation ChangeStatesAndResetAnim:STOPPED];
	}
	
}



//==============================================================================
-(void) Draw:(Color4f)_colors
{
	//call parent class to draw the player
	[super Draw:_colors];

}


@end


