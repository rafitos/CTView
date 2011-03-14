//
//  CTViewViewController.h
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTView.h"

@interface CTViewViewController : UIViewController <CTVDelegate> {
	IBOutlet CTView* ctview;
}

@property (nonatomic, retain) CTView* ctview;

@end

