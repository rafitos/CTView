//
//  CTDecoratorFontFile.m
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import "CTDecoratorFontFile.h"


@implementation CTDecoratorFontFile

+ (CTFontRef)newCustomFontWithPath:(NSString *)fontPath size:(float)sz {
	static NSMutableDictionary *loadedFonts;
	
	if(!loadedFonts) {
		@synchronized(self) {
			if(!loadedFonts) {
				loadedFonts = [[NSMutableDictionary alloc] init];
			}
		}
	}
	
	sz = round(sz);
	
	NSString* fontKey = [NSString stringWithFormat:@"%@_%f", fontPath, sz];

	CTFontRef font = (CTFontRef)[loadedFonts valueForKey:fontKey];
	if(!font) {
		NSData *data = [[NSData alloc] initWithContentsOfFile:fontPath];
		
		NSDictionary* attributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:sz] forKey:(NSString*)kCTFontSizeAttribute];
		CGDataProviderRef fontProvider = CGDataProviderCreateWithCFData((CFDataRef)data);
		CGFontRef cgFont = CGFontCreateWithDataProvider(fontProvider);	
		CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attributes);
		font = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
		
		[loadedFonts setValue:(id)font forKey:fontKey];
		
		[data release];	
		CGDataProviderRelease(fontProvider);
		CFRelease(fontDescriptor);
		CGFontRelease(cgFont);
	}
	
	return font;
}

- (void)decorateString:(CFMutableAttributedStringRef)attrString withValues:(NSDictionary*)vals starting:(int)startPos ending:(int)endPos forView:(UIView*)view {
	if([self testWithValues:vals] == NO) return;
	
	NSArray* comps = [[vals valueForKey:@"file"] componentsSeparatedByString:@"."];
	NSString *fontPath;
	if ([comps count] == 1) {
		fontPath = [[NSBundle mainBundle] pathForResource:[comps objectAtIndex:0] ofType:@""];
	}
	else {
		fontPath = [[NSBundle mainBundle] pathForResource:[comps objectAtIndex:0] ofType:[comps objectAtIndex:1]];
	}
	if(fontPath == nil) return;
	
	float fontSize = [(NSString*)[vals valueForKey:@"size"] floatValue];
	CTFontRef myFont = [CTDecoratorFontFile newCustomFontWithPath:fontPath size:fontSize];
	
	CFAttributedStringSetAttribute(attrString, CFRangeMake(startPos, endPos - startPos), kCTFontAttributeName, myFont);

	CGFloat minLineHeight = fontSize + 3.0;
	CGFloat maxLineHeight = 9999999.0;
	CTParagraphStyleSetting settings[] = {
		{ kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(minLineHeight), &minLineHeight },
        { kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(maxLineHeight), &maxLineHeight },
	};
	CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
	CFAttributedStringSetAttribute(attrString, CFRangeMake(startPos, endPos - startPos), kCTParagraphStyleAttributeName, paragraphStyle);
}

- (BOOL)testWithValues:(NSDictionary*)vals {
	if([vals valueForKey:@"file"] == nil || [vals valueForKey:@"size"] == nil) return NO;
	
	return YES;
}

@end
