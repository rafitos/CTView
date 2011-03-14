//
//  CTVDelegate.h
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CTVDelegate
- (void)linkTouched:(NSString*)selector;
- (UIImage*)getImageNamed:(NSString*)imageName;
@end
