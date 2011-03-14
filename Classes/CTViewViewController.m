//
//  CTViewViewController.m
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import "CTViewViewController.h"

@implementation CTViewViewController

@synthesize ctview;

- (void)viewDidLoad {
    [super viewDidLoad];

	self.ctview.delegate = self;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"lorem" ofType:@"txt"];	
	[self.ctview setText:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
}

#pragma mark -
#pragma mark CTVDelegate

- (void)linkTouched:(NSString *)selector {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Link touched" message:selector delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (UIImage*)getImageNamed:(NSString *)imageName {
	return [UIImage imageNamed:imageName];
}

#pragma mark -

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.ctview = nil;
	
    [super dealloc];
}

@end
