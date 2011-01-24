//
//  TBXMLParticleAdditions.m
//  
//
//  Created by Michael Daley on 14/12/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "TBXMLParticleAdditions.h"


@implementation TBXML (TBXMLParticleAdditions) 

- (float)intValueFromChildElementNamed:(NSString*)aName parentElement:(TBXMLElement*)aParentXMLElement {
	TBXMLElement * xmlElement = [TBXML childElementNamed:aName parentElement:aParentXMLElement];
	
	if (xmlElement) {
		return [[TBXML valueOfAttributeNamed:@"value" forElement:xmlElement] intValue];
	}
	
	return 0;
}

- (float)floatValueFromChildElementNamed:(NSString*)aName parentElement:(TBXMLElement*)aParentXMLElement {
	TBXMLElement * xmlElement = [TBXML childElementNamed:aName parentElement:aParentXMLElement];
	
	if (xmlElement) {
		return [[TBXML valueOfAttributeNamed:@"value" forElement:xmlElement] floatValue];
	}
	
	return 0.0f;
}

- (BOOL)boolValueFromChildElementNamed:(NSString*)aName parentElement:(TBXMLElement*)aParentXMLElement {
	TBXMLElement * xmlElement = [TBXML childElementNamed:aName parentElement:aParentXMLElement];
	
	if (xmlElement) {
		return [[TBXML valueOfAttributeNamed:@"value" forElement:xmlElement] boolValue];
	}
	
	return NO;
}

- (Vector2f)vector2fFromChildElementNamed:(NSString*)aName parentElement:(TBXMLElement*)aParentXMLElement {
	TBXMLElement * xmlElement = [TBXML childElementNamed:aName parentElement:aParentXMLElement];
	
	if (xmlElement) {
		float x = [[TBXML valueOfAttributeNamed:@"x" forElement:xmlElement] floatValue];
		float y = [[TBXML valueOfAttributeNamed:@"y" forElement:xmlElement] floatValue];
		return Vector2fMake(x, y);
	}
	
	return Vector2fMake(0, 0);
}

- (Color4f)color4fFromChildElementNamed:(NSString*)aName parentElement:(TBXMLElement*)aParentXMLElement {
	TBXMLElement * xmlElement = [TBXML childElementNamed:aName parentElement:aParentXMLElement];
	
	if (xmlElement) {
		float red = [[TBXML valueOfAttributeNamed:@"red" forElement:xmlElement] floatValue];
		float green = [[TBXML valueOfAttributeNamed:@"green" forElement:xmlElement] floatValue];
		float blue = [[TBXML valueOfAttributeNamed:@"blue" forElement:xmlElement] floatValue];
		float alpha = [[TBXML valueOfAttributeNamed:@"alpha" forElement:xmlElement] floatValue];
		return Color4fMake(red, green, blue, alpha);
	}
	
	return Color4fMake(0, 0, 0, 0);
}

@end
