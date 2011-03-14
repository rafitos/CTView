//
//  CTViewAppDelegate.m
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import "CTViewAppDelegate.h"
#import "CTViewViewController.h"
#import "CTVStyler.h"

@implementation CTViewAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[CTVStyler setCurrentDevice:@"iPad"];

	[CTVStyler setStyle:@"sample_style" attributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Helvetica", @"18", nil] 
																				   forKeys:[NSArray arrayWithObjects:@"name", @"size", nil]]];
	[CTVStyler setStyle:@"sample_style-iPad" attributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Helvetica", @"26", @"0.5 0.5 0.5 1.0", nil] 
																						forKeys:[NSArray arrayWithObjects:@"name", @"size", @"color", nil]]];
    
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];

	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
