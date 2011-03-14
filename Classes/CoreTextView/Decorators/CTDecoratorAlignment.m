//
//  CTDecoratorAlignment.m
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import "CTDecoratorAlignment.h"


@implementation CTDecoratorAlignment

- (void)decorateString:(CFMutableAttributedStringRef)attrString withValues:(NSDictionary*)vals starting:(int)startPos ending:(int)endPos forView:(UIView*)view {
	if([self testWithValues:vals] == NO) return;
	
	CTTextAlignment alignment;

	NSString* al = [vals valueForKey:@"align"];
	
	if([al isEqualToString:@"right"]) {
		alignment = kCTRightTextAlignment;
	}
	else if([al isEqualToString:@"center"]) {
		alignment = kCTCenterTextAlignment;
	}
	else if([al isEqualToString:@"justified"]) {
		alignment = kCTJustifiedTextAlignment;
	}
	else {
		alignment = kCTLeftTextAlignment;
	}
	
	CTParagraphStyleSetting settings[] = {
		{kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment}
	};
	CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
	CFAttributedStringSetAttribute(attrString, CFRangeMake(startPos, endPos - startPos), kCTParagraphStyleAttributeName, paragraphStyle);
}

- (BOOL)testWithValues:(NSDictionary*)vals {
	if([vals valueForKey:@"align"] == nil) return NO;
	
	return YES;
}

@end
