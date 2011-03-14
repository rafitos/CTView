//
//  CTVDecorator.h
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@protocol CTVDecorator
- (void)decorateString:(CFMutableAttributedStringRef)attrString withValues:(NSDictionary*)vals starting:(int)startPos ending:(int)endPos forView:(UIView*)view;
- (BOOL)testWithValues:(NSDictionary*)vals;
@end
