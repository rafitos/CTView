//
//  CTDecoratorColor.m
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import "CTDecoratorColor.h"


@implementation CTDecoratorColor

- (void)decorateString:(CFMutableAttributedStringRef)attrString withValues:(NSDictionary*)vals starting:(int)startPos ending:(int)endPos forView:(UIView*)view {
	if([self testWithValues:vals] == NO) return;
	
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();

	NSArray *comps = [[vals valueForKey:@"color"] componentsSeparatedByString:@" "];
	CGFloat cs[] = { [(NSString *)[comps objectAtIndex:0] floatValue], [(NSString *)[comps objectAtIndex:1] floatValue], [(NSString *)[comps objectAtIndex:2] floatValue], [(NSString *)[comps objectAtIndex:3] floatValue]};
	CGColorRef color = CGColorCreate(rgbColorSpace, cs);
	CFAttributedStringSetAttribute(attrString, CFRangeMake(startPos, endPos - startPos), kCTForegroundColorAttributeName, color);

	CGColorRelease(color);
	CGColorSpaceRelease(rgbColorSpace);
}

- (BOOL)testWithValues:(NSDictionary*)vals {
	if([vals valueForKey:@"color"] == nil) return NO;
	
	return YES;
}

@end
