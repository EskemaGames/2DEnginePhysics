//
//  ActionManager.m
//  
//
//  Created by Alejandro Perez Perez on 16/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionManager.h"
#import "ActionPoint.h"
#import "Widgets.h"
#import "SpriteBase.h"

@implementation ActionManager

@synthesize ActionEnded;
@synthesize repeatAction;
@synthesize delegate;



- (id) init:(SpriteBase *)spriteforAction RepeatAction:(bool)RepeatAction
{
	self = [super init];
	if (self != nil) {
		m_sprite = spriteforAction;
		m_position = m_sprite._position;
		m_entityPath = [[NSMutableArray alloc] init];
		ActionEnded = NO;
		repeatAction = RepeatAction;
		m_wayPointCount = 0;
		m_currentWayPoint = 0;
		m_velocity = Vector2fZero;
		

	}
	return self;
}


- (id)initWithDuration:(SpriteBase *)sprite Duration:(float)duration from:(Vector2f)from to:(Vector2f)to 
{
    
	self = [super init];
	if (self != nil) {
		m_sprite = sprite;
		m_position = Vector2fMake(from.x, from.y);
		_duration = duration;
		to_		= to;
		from_	= from;
		delta_ = Vector2fSub(to_, from_);
		distX = delta_.x / _duration;
		distY = delta_.y / _duration;
		oldDuration = _duration;
		
	}
    
	return self;
}


- (void) dealloc
{
	[m_entityPath release];
	[super dealloc];
}


-(void)AddPointsToRoute:(Vector2f)onePoint Speed:(float)Speed
{
	ActionPoint *tmp = [[ActionPoint alloc] init];
	tmp.m_entityPoint = Vector2fMake(onePoint.x, onePoint.y);
	tmp.m_speed = Speed;
	[m_entityPath addObject:tmp];
	m_wayPointCount = [m_entityPath count];
	[tmp release];
	
}


//establish the first point for the action
//we need an initial point to start the movements
-(void)SetInitialPoint
{
	ActionPoint *waypoint = [m_entityPath objectAtIndex:0];
	m_position = waypoint.m_entityPoint;
	m_sprite._position = m_position;
}


//restart the action and the values needed
//otherwise the action won't be played again
-(void)RestartAction
{
	ActionEnded = NO;
	m_currentWayPoint = 0;
	[self SetInitialPoint];
}


-(void)MoveToPosition:(float)GameSpeed
{	
	
	if (ActionEnded && !repeatAction)
		return;
	
	
	// Set the next waypoint from the entity path
	ActionPoint *waypoint = [m_entityPath objectAtIndex:m_currentWayPoint];
	
	// as we are seeking the target
	Vector2f steeringForce = Vector2fSub(waypoint.m_entityPoint, m_position);
	
	// Subtract current velocity from the steering force
	steeringForce = Vector2fSub(steeringForce, m_velocity);
	
	// Multiply the steering force with delta
	steeringForce = Vector2fMultiply(steeringForce, GameSpeed);
	
	// Limit the steering force to be applied
	float vectorLength = Vector2fLength(steeringForce);
	float maxSteeringForce = MAX_STEERING_FORCE;
	if(vectorLength > maxSteeringForce) 
	{
		steeringForce = Vector2fMultiply(steeringForce, maxSteeringForce / vectorLength);
	}
	
	// Add the steering force to the current velocity
	m_velocity = Vector2fAdd(m_velocity, steeringForce);		
	
	// Limit the velocity
	vectorLength = Vector2fLength(m_velocity);
	float maxVelocity = MAX_VELOCITY;
	if(vectorLength > maxVelocity) 
	{
		m_velocity = Vector2fMultiply(m_velocity, maxVelocity/vectorLength);
	}
	
	//fix the movement with the gamespeed to get smooth values
	m_position.x += (waypoint.m_speed*2) * m_velocity.x * GameSpeed;
	m_position.y += (waypoint.m_speed*2) * m_velocity.y * GameSpeed;
	

	// If the player gets to within a defined # of pixels from waypoint move to the next waypoint
	if((m_position.x - waypoint.m_entityPoint.x) >= -WAYPOINT_DISTANCE && 
	   (m_position.x - waypoint.m_entityPoint.x) <= WAYPOINT_DISTANCE && 
	   (m_position.y - waypoint.m_entityPoint.y) >= -WAYPOINT_DISTANCE && 
	   (m_position.y - waypoint.m_entityPoint.y) <= WAYPOINT_DISTANCE) 
	{
		// Increment the current waypoint counter
		m_currentWayPoint++;
		
		// Check to see if we have reached the end of the entity path
		if(m_currentWayPoint > m_wayPointCount-1) 
		{
			m_currentWayPoint = 0;
			ActionEnded = YES;
			
			//we finish the action, notify through delegate
			if (!repeatAction)
			{
				//notify system the action have ended
				[delegate onAnimationEnded];
			}
		}
		
		// Set the next waypoint from the entity path
		waypoint = [m_entityPath objectAtIndex:m_currentWayPoint];
	}

	m_sprite._position = m_position;

}










//reset positions and time to play again this action
-(void)RestartTimeAction
{
	ActionEnded = NO;
	_duration = oldDuration;
	m_position = from_;
}


-(void)UpdateTimeAction:(float)deltaTime
{
	if (ActionEnded)
		return;
	
	
	if( !ActionEnded )
	{				
		// See if we are done with our animation yet
		if( ( deltaTime + _duration ) <= deltaTime )
		{
			ActionEnded = YES;
			//notify system the action have ended
			[delegate onAnimationEnded];
			
			//finally put the sprite in the exact spot stated in the function
			m_position = to_;
			//update the associate sprite to this class
			m_sprite._position = m_position;
		}
		else //we update the position because we have time to do it
		{
			_duration -= deltaTime;
			ActionEnded = NO;
			m_position.x += distX * deltaTime;
			m_position.y += distY * deltaTime; 
			//update the associate sprite to this class
			m_sprite._position = m_position;
		}
	}
}



@end
