//
//  CTVFontTag.h
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTDecorator.h"


@interface CTVFontTag : NSObject {
	int startPos;
	int endPos;
	NSMutableDictionary* attributes;
}

@property int startPos;
@property int endPos;
@property (retain) NSMutableDictionary* attributes;

+ (CTVFontTag*)fontTagWithAttributes:(NSDictionary*)attrs startPos:(int)start;
+ (NSArray*)getDecorators;

- (void)decorate:(CFMutableAttributedStringRef)attrString forView:(UIView*)view;

@end
