//
//  CTDecoratorImage.m
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import "CTDecoratorImage.h"
#import "CTView.h"

@implementation CTDecoratorImage

/* Callbacks */
void MyDeallocationCallback(void* refCon) {	
	NSArray* arr = (NSArray*)refCon;
	[arr release];
}

CGFloat MyGetAscentCallback(void *refCon) {
	NSArray* arr = (NSArray*)refCon;
	CTView* v = (CTView*)[arr objectAtIndex:1];
	NSDictionary* attrs = [arr objectAtIndex:0];
	UIImage* image = [v.delegate getImageNamed:[attrs valueForKey:@"image"]];
	if(image == nil) return 0;

	float height = image.size.height;
	
	NSString* atWidth = [attrs objectForKey:@"width"];
	NSString* atHeight = [attrs objectForKey:@"height"];
	if(atWidth) {
		float width = [atWidth floatValue];
		height = image.size.height * (image.size.width / width);
	}
	else if(atHeight) {
		height = [atHeight floatValue];
	}
	
	return height;
}

CGFloat MyGetDescentCallback(void *refCon) {
	return 0;
}

CGFloat MyGetWidthCallback(void* refCon) {
	NSArray* arr = (NSArray*)refCon;
	CTView* v = (CTView*)[arr objectAtIndex:1];
	NSDictionary* attrs = [arr objectAtIndex:0];
	UIImage* image = [v.delegate getImageNamed:[attrs valueForKey:@"image"]];
	if(image == nil) return 0;

	float width = image.size.width;
	
	NSString* atWidth = [attrs objectForKey:@"width"];
	NSString* atHeight = [attrs objectForKey:@"height"];
	if(atWidth) {
		width = [atWidth floatValue];
	}
	else if(atHeight) {
		float height = [atHeight floatValue];
		width = image.size.width * (image.size.height / height);
	}
	
    return width;
}

- (void)decorateString:(CFMutableAttributedStringRef)attrString withValues:(NSDictionary*)vals starting:(int)startPos ending:(int)endPos forView:(CTView*)view {
	if([self testWithValues:vals] == NO) return;

    // create the delegate
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.dealloc = MyDeallocationCallback;
    callbacks.getAscent = MyGetAscentCallback;
    callbacks.getDescent = MyGetDescentCallback;
    callbacks.getWidth = MyGetWidthCallback;
    CTRunDelegateRef dlg = CTRunDelegateCreate(&callbacks, [[NSArray alloc] initWithObjects:vals, view, nil]);
	
    // set the delegate as an attribute
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attrString, CFRangeMake(startPos, endPos - startPos), kCTRunDelegateAttributeName, dlg);
	CFAttributedStringSetAttribute(attrString, CFRangeMake(startPos, endPos - startPos), (CFStringRef)@"IMAGE", [vals valueForKey:@"image"]);
	if([vals valueForKey:@"width"]) {
		CFAttributedStringSetAttribute(attrString, CFRangeMake(startPos, endPos - startPos), (CFStringRef)@"IMAGE_WIDTH", [vals valueForKey:@"width"]);
	}
	if([vals valueForKey:@"height"]) {
		CFAttributedStringSetAttribute(attrString, CFRangeMake(startPos, endPos - startPos), (CFStringRef)@"IMAGE_HEIGHT", [vals valueForKey:@"height"]);
	}
	if([vals valueForKey:@"vpos"]) {
		CFAttributedStringSetAttribute(attrString, CFRangeMake(startPos, endPos - startPos), (CFStringRef)@"IMAGE_VPOS", [vals valueForKey:@"vpos"]);
	}
	
//	CFRelease(dlg);
}

- (BOOL)testWithValues:(NSDictionary*)vals {
	if([vals valueForKey:@"image"] == nil) return NO;
	
	return YES;
}

@end
