//
//  CTVStyler.h
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CTVStyler : NSObject {

}

+ (void)setStyle:(NSString*)styleName attributes:(NSDictionary*)atts;
+ (NSDictionary*)getStyleNamed:(NSString*)styleName;
+ (void)setCurrentDevice:(NSString*)devName;

@end
