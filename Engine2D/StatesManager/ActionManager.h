//
//  ActionManager.h
//  
//
//  Created by Alejandro Perez Perez on 16/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#define WAYPOINT_DISTANCE 4
#define MAX_VELOCITY 5.0f
#define MAX_STEERING_FORCE 1.50f



#import <Foundation/Foundation.h>
#import "CommonEngine.h"
@class SpriteBase;


@protocol ActionManagerProtocol

-(void) onAnimationEnded;

@end



@interface ActionManager : NSObject {
	
	SpriteBase *m_sprite;

	//position
	Vector2f m_position;
	// Velocity
	Vector2f m_velocity;
	
	// Current target waypoint within the entity path array
	unsigned int m_currentWayPoint;
	// Total number of waypoints being used
	unsigned int m_wayPointCount;
	
	// Array of waypoints this entity is to follow
	NSMutableArray *m_entityPath;

	//flag for the action
	bool ActionEnded;
	bool repeatAction;
	
	id<ActionManagerProtocol> delegate;
	
	float			_duration;		//duration of this action
	float			oldDuration;
	float		distX, distY;		//dist to travel in this action
	Vector2f		from_, to_;		//initial and destination points
	Vector2f		delta_;			//delta distance between initial and destination point
	
}

@property (nonatomic, retain) id<ActionManagerProtocol> delegate;
@property (nonatomic, assign) bool ActionEnded;
@property (nonatomic, assign) bool repeatAction;



-(id) init:(SpriteBase *)spriteforAction RepeatAction:(bool)RepeatAction;
-(id)initWithDuration:(SpriteBase *)sprite Duration:(float)duration from:(Vector2f)from to:(Vector2f)to;
-(void)AddPointsToRoute:(Vector2f)onePoint Speed:(float)Speed;
-(void)SetInitialPoint;
-(void)MoveToPosition:(float)GameSpeed;
-(void)RestartAction;

-(void)RestartTimeAction;
-(void)UpdateTimeAction:(float)deltaTime;

@end


// how to use this class

//first init
//then add points starting from the initial position
//finally setinitialpoint;
//and use it with movetoposition
//if you need to use again the action, call restartaction
