//
//  TBXMLParticleAdditions.h
//  
//
//  Created by Michael Daley on 19/12/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "TBXML.h"
#import "CommonEngine.h"

// This is a category that has been added to the TBML class.  Reading specific attributes from a
// particle emitter XML config file is not something the TBXML class should be altered for.  This
// is a perfect opportunity to create a category on top of TBXML that adds specfic features that
// meet our needs when processing the particle config files.
//
// The new methods below grab data from specific attributes that we know will contain the information
// we need in a particle config file and returns values that are specific to our implementation such 
// as Color4f and Vector4f
//
// These changes will only work when processing the particle config files and a further category would
// need to be made to process other types of data if necessary
//
@interface TBXML (TBXMLParticleAdditions)

// Returns a int value from the processes element
- (float) intValueFromChildElementNamed:(NSString*)aName parentElement:(TBXMLElement*)aParentXMLElement;

// Returns a float value from the processes element
- (float) floatValueFromChildElementNamed:(NSString*)aName parentElement:(TBXMLElement*)aParentXMLElement;

// Returns a bool value from the processes element
- (BOOL) boolValueFromChildElementNamed:(NSString*)aName parentElement:(TBXMLElement*)aParentXMLElement;

// Returns a vector2f structure from the processes element
- (Vector2f) vector2fFromChildElementNamed:(NSString*)aName parentElement:(TBXMLElement*)aParentXMLElement;

// Returns a color4f structure from the processes element
- (Color4f) color4fFromChildElementNamed:(NSString*)aName parentElement:(TBXMLElement*)aParentXMLElement;

@end
