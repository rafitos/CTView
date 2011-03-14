//
//  CTView.h
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CTVDelegate.h"

@interface CTView : UILabel {
	CFAttributedStringRef attrString;
	NSString* text;
	NSMutableArray* targetList;	
		
	id <CTVDelegate> delegate;	
}

@property (retain) id <CTVDelegate> delegate;

- (CGSize)calculateHeight;
- (void)setText:(NSString*)text;

- (void)buildText;
- (void)setup;

@end
