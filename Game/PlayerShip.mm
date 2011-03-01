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
				NSString *_loop = [TBXML valueOfAttributeNamed:@"Loop" forElement:animation];
				

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
					NSString *_OffsetX = [TBXML valueOfAttributeNamed:@"OffsetX" forElement:props];
					NSString *_OffsetY = [TBXML valueOfAttributeNamed:@"OffsetY" forElement:props];

					
					if([name isEqualToString:@"Stopped"])
					{
						[Animation LoadAnimation:STOPPED   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i OffsetX:[_OffsetX intValue]
										 OffsetY:[_OffsetY intValue] LoopAnimation:[_loop boolValue]];
					}
					
					if([name isEqualToString:@"MoveLeft"])
					{
						[Animation LoadAnimation:MOVELEFT   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i OffsetX:[_OffsetX intValue]
										 OffsetY:[_OffsetY intValue] LoopAnimation:[_loop boolValue]];
					}
					if([name isEqualToString:@"MoveRight"])
					{
						[Animation LoadAnimation:MOVERIGHT   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i OffsetX:[_OffsetX intValue]
										 OffsetY:[_OffsetY intValue] LoopAnimation:[_loop boolValue]];
					}
					if([name isEqualToString:@"MoveUp"])
					{
						[Animation LoadAnimation:MOVEUP   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i OffsetX:[_OffsetX intValue]
										 OffsetY:[_OffsetY intValue] LoopAnimation:[_loop boolValue]];
					}
					if([name isEqualToString:@"MoveDown"])
					{
						[Animation LoadAnimation:MOVEDOWN   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i OffsetX:[_OffsetX intValue]
										 OffsetY:[_OffsetY intValue] LoopAnimation:[_loop boolValue]];
					}
					
					if([name isEqualToString:@"Dead"])
					{
						[Animation LoadAnimation:DEAD   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i OffsetX:[_OffsetX intValue]
										 OffsetY:[_OffsetY intValue] LoopAnimation:[_loop boolValue]];
					}
					
					if([name isEqualToString:@"Dying"])
					{
						[Animation LoadAnimation:DYING   
								 AnimationValues:CGRectMake([X intValue] , [Y intValue], [Width intValue], [Height intValue]) 
										   Speed:[_speed intValue] frames_number:[Num intValue] EndAnimation:[End intValue] CachedNum:i OffsetX:[_OffsetX intValue]
										 OffsetY:[_OffsetY intValue] LoopAnimation:[_loop boolValue]];
					}
					

					//cache this sprite frame, this improves the perfomance a lot
					//precalculate here all the frames coordinates will help framerate
					[sprtImg cacheTexCoords:[Width intValue]
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
			
	
		//set the actor type
		_typeActor = TYPEPLAYER;
		
		//start the enemy animation and state
		EntityState = STOPPED;
		
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
	Animation.AnimationActive = NO;
	[super dealloc];
}



//
//
//	STATES
//
//==============================================================================
-(state) GetState
{
	return EntityState;
}



//==============================================================================
-(void) ChangeState:(state) EntityStatus
{
	EntityState = EntityStatus;
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
// STATES FOR ANIMATIONS AND BEHAVIOUR OF THE ENEMY
//
//=============================================================================

-(void) Control:(float)GameSpeed 
{
	switch (EntityState) 
	{
		case DYING:
			break;
			
		case DEAD:
			break;
			
		case STOPPED:
			break;
			
		case MOVELEFT:
			[Animation ChangeStates:MOVELEFT];
			break;
			
		case MOVERIGHT:
			[Animation ChangeStates:MOVERIGHT];
			break;
			
		case MOVEUP:
			[Animation ChangeStates:MOVEUP];
			break;
			
		case MOVEDOWN:
			[Animation ChangeStates:MOVEDOWN];
			break;

			
		case EMPTY:
			//empty state useful to move from one state to another
			break;
			
		case GAMEOVER:
			//empty state to handle the gameover, we post a notification
			//and we will use that notification in the maingame screen
			//this is only an empty state
			break;
	}
	
	//the enemy is not dead, dying or gameover, so we can move it
    if ( EntityState != DYING && EntityState != DEAD && EntityState != STOPPED && EntityState != EMPTY && EntityState != GAMEOVER ) 
	{
		[self Move:GameSpeed]; // move enemy		
	}
	
}



-(void) Move:(float)GameSpeed 
{
	
	switch (EntityState)
	{
		case MOVELEFT:
				[super MoveXSpeed:GameSpeed];
			break;
			
		case MOVERIGHT:
				[super MoveXSpeed:GameSpeed];
			break;
			
		case MOVEUP:
				[super MoveYSpeed:GameSpeed];
			break;
			
		case MOVEDOWN:
				[super MoveYSpeed:GameSpeed];
			break;
			
			//end case moveleft
	};
}






//
//
// DRAW
//
//


//==============================================================================
-(void) Draw:(Color4f)_colors
{
	//call parent class to draw the player
	[super Draw:_colors];

}


@end


