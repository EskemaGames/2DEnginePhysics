//
//  ActionPoint.h
//  
//
//  Created by Alejandro Perez Perez on 16/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonEngine.h"


@interface ActionPoint : NSObject {
	float m_speed;
	Vector2f m_entityPoint;
	
	float			_duration;		//duration of this action
	float			oldDuration;
	float		distX, distY;		//dist to travel in this action
	Vector2f		from_, to_;		//initial and destination points
	Vector2f		delta_;			//delta distance between initial and destination point
}


@property (nonatomic, readwrite) Vector2f m_entityPoint;
@property (nonatomic, readwrite) float m_speed;
@property (nonatomic, readwrite) float _duration;
@property (nonatomic, readwrite) float oldDuration;
@property (nonatomic, readwrite) float distX, distY;
@property (nonatomic, readwrite) Vector2f from_;
@property (nonatomic, readwrite) Vector2f to_;
@property (nonatomic, readwrite) Vector2f delta_;


@end