//
//  CTVStyler.m
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import "CTVStyler.h"

NSString* currentDevice;


@implementation CTVStyler

+ (NSMutableDictionary*)getStyles {
	static NSMutableDictionary* styles;
	
	@synchronized(self) {
		if(!styles) {
			styles = [[NSMutableDictionary alloc] initWithCapacity:1];
		}
	}
	
	return styles;
}

+ (void)setStyle:(NSString*)styleName attributes:(NSDictionary*)atts {
	[[CTVStyler getStyles] setObject:atts forKey:styleName];
}

+ (NSDictionary*)getStyleNamed:(NSString*)styleName {
	if(currentDevice != nil) {
		styleName = [styleName stringByAppendingFormat:@"-%@", currentDevice];
	}
	
	NSMutableDictionary* styles = [CTVStyler getStyles];
	
	return [styles valueForKey:styleName];
}

+ (void)setCurrentDevice:(NSString*)devName {
	currentDevice = [devName retain];
}


@end
