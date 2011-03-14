//
//  CTDecoratorFontName.m
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import "CTDecoratorFontName.h"


@implementation CTDecoratorFontName

- (void)decorateString:(CFMutableAttributedStringRef)attrString withValues:(NSDictionary*)vals starting:(int)startPos ending:(int)endPos forView:(UIView*)view {
	if([self testWithValues:vals] == NO) return;
	
	CTFontRef myFont = CTFontCreateWithName((CFStringRef)[vals valueForKey:@"name"], [(NSString*)[vals valueForKey:@"size"] floatValue], NULL);

	CFAttributedStringSetAttribute(attrString, CFRangeMake(startPos, endPos - startPos), kCTFontAttributeName, myFont);
}

- (BOOL)testWithValues:(NSDictionary*)vals {
	if([vals valueForKey:@"name"] == nil || [vals valueForKey:@"size"] == nil) return NO;
	
	return YES;
}

@end
