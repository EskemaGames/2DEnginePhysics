//
//  InputState.h
//  
//
//  Created by Eskema on 05/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>  

@interface InputState : NSObject  
{  
    bool isBeingTouched;  
    CGPoint touchLocation;  
}  

@property (nonatomic, readwrite) bool isBeingTouched;  
@property (nonatomic, readwrite) CGPoint touchLocation;  

@end  



 
