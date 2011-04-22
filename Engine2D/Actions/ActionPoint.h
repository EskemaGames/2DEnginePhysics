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
}


@property (nonatomic, readwrite) Vector2f m_entityPoint;
@property (nonatomic, readwrite) float m_speed;

@end