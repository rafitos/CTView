//
//  CTViewAppDelegate.h
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTViewViewController;

@interface CTViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CTViewViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CTViewViewController *viewController;

@end

