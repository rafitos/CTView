//
//  CTDecoratorTouched.m
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import "CTDecoratorTouched.h"


@implementation CTDecoratorTouched

- (void)decorateString:(CFMutableAttributedStringRef)attrString withValues:(NSDictionary*)vals starting:(int)startPos ending:(int)endPos forView:(UIView*)view {
	if([self testWithValues:vals] == NO) return;
	
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat components[] = { 0.0, 0.0, 1.0, 1.0 };
	CGColorRef blue = CGColorCreate(rgbColorSpace, components);
	
	if([vals valueForKey:@"color"] == nil) {
		CFAttributedStringSetAttribute(attrString, CFRangeMake(startPos, endPos - startPos), kCTForegroundColorAttributeName, blue);
	}
	
	CFAttributedStringSetAttribute(attrString, CFRangeMake(startPos, endPos - startPos), (CFStringRef)@"SELECTOR_TARGET", [vals valueForKey:@"touched"]);

	CGColorSpaceRelease(rgbColorSpace);
	CFRelease(blue);
}

- (BOOL)testWithValues:(NSDictionary*)vals {
	if([vals valueForKey:@"touched"] == nil) return NO;
	
	return YES;
}

@end
