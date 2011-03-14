//
//  CTVFontTag.m
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import "CTVFontTag.h"
#import "CTDecoratorTouched.h"
#import "CTDecoratorFontName.h"
#import "CTDecoratorFontFile.h"
#import "CTDecoratorAlignment.h"
#import "CTDecoratorColor.h"
#import "CTDecoratorImage.h"
#import "CTView.h"
#import "CTVStyler.h"

@implementation CTVFontTag

@synthesize startPos;
@synthesize endPos;
@synthesize attributes;

+ (CTVFontTag*)fontTagWithAttributes:(NSDictionary*)attrs startPos:(int)start {
	CTVFontTag *ret = [[CTVFontTag alloc] init];
	ret.startPos = start;
	ret.attributes = [attrs mutableCopy];
	
	return [ret autorelease];
}

+ (NSArray*)getDecorators {
	static NSArray* decorators;
	
	@synchronized(self) {
		if(!decorators) {
			decorators = [NSArray arrayWithObjects:	[[[CTDecoratorTouched alloc] init] autorelease], 
													[[[CTDecoratorFontName alloc] init] autorelease], 
													[[[CTDecoratorFontFile alloc] init] autorelease], 
													[[[CTDecoratorAlignment alloc] init] autorelease], 
													[[[CTDecoratorColor alloc] init] autorelease], 
													[[[CTDecoratorImage alloc] init] autorelease], 
												nil];
			[decorators retain];
		}
	}
		
	return decorators;
}

- (void)decorate:(CFMutableAttributedStringRef)attrString forView:(UIView*)view {
	NSArray* decs = [CTVFontTag getDecorators];

	NSDictionary* atts = attributes;
	
	NSString* style = [attributes valueForKey:@"style"];
	if(style) {		
		atts = [NSMutableDictionary dictionaryWithDictionary:[CTVStyler getStyleNamed:style]];
		for(NSString* key in attributes) {
			[atts setValue:[attributes valueForKey:key] forKey:key];
		}
	}
	for(id <CTVDecorator> d in decs) {
		[d decorateString:attrString withValues:atts starting:startPos ending:endPos forView:view];
	}
}

- (void)dealloc {
	[attributes release];
	
	[super dealloc];
}
@end
