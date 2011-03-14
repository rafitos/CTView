//
//  CTView.m
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CTView.h"
#import "CTVParser.h"


@implementation CTView

@synthesize delegate;


- (void)setText:(NSString*)txt {
	[text release];
	text = [txt retain];
	
	[self buildText];
}

- (void)buildText {
	if(attrString) {
		CFRelease(attrString);
	}
	
	CTVParser* parser = [[CTVParser alloc] init];
	attrString = [parser newAttributedStringFromText:text forView:self];
	[parser release];
}

#pragma mark -
#pragma mark touch event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if(targetList == nil) return;
	
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
		
	for(NSDictionary* d in targetList) {
		NSValue* nvrect = (NSValue*)[d objectForKey:@"rect"];
		CGRect r = [nvrect CGRectValue];
		NSString* selector = (NSString*)[d objectForKey:@"selector"];
		if(p.y > r.origin.y - r.size.height && p.y < r.origin.y + r.size.height) {
			[self setNeedsDisplay];
			[delegate linkTouched:selector];
		}
	}
}

#pragma mark -
#pragma mark painting

- (void) drawRect:(CGRect)rect {
	if(!attrString) return;
	
	/* get the context */
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	
	/* flip the coordinate system */	
	float viewHeight = self.bounds.size.height;
    CGContextTranslateCTM(context, 0, viewHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
	
	/* generate the path for the text */
	CGMutablePathRef path = CGPathCreateMutable();
	if(self.contentMode == UIViewContentModeCenter) {
		CGSize sz = [self calculateHeight];
		CGRect bounds = CGRectMake(0, (self.bounds.size.height - sz.height) / 2, self.bounds.size.width, sz.height + 1);
		CGPathAddRect(path, NULL, bounds);
	}
	else {
		CGRect bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
		CGPathAddRect(path, NULL, bounds);
	}
	
	
	/* draw the text */
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
	CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
	CFRelease(framesetter);
	CFRelease(path);
	CTFrameDraw(frame, context);
	
	/* scan touch targets and images */
	if(targetList) {
		[targetList release];
	}
	targetList = [[NSMutableArray alloc] init];
	
	NSArray* lines = (NSArray*)CTFrameGetLines(frame);
	for(int x = 0; x < [lines count]; x++) {
		CTLineRef l = (CTLineRef)[lines objectAtIndex:x];
		CGPoint origins;
		CTFrameGetLineOrigins(frame, CFRangeMake(x, 1), &origins);		
		float yPos = self.bounds.origin.y + self.bounds.size.height - origins.y;
		
		NSArray* runs = (NSArray*)CTLineGetGlyphRuns(l);
		for(int y = 0; y < [runs count]; y++) {
			CTRunRef r = (CTRunRef)[runs objectAtIndex:y];
			NSDictionary* attrs = (NSDictionary*)CTRunGetAttributes(r);
			id at = [attrs objectForKey:@"SELECTOR_TARGET"];
			if(at) {
				CGRect runBounds = CTRunGetImageBounds(r, context, CFRangeMake(0, 0));
				CGRect bnd = CGRectMake(0, yPos, self.frame.size.width, runBounds.size.height);
				CFRange rng = CTRunGetStringRange(r);
				NSRange nsr = { rng.location, rng.length };
				
				[targetList addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:at, [NSValue valueWithCGRect:bnd], [NSValue valueWithRange:nsr],  nil] 
																  forKeys:[NSArray arrayWithObjects:@"selector", @"rect", @"range", nil]]];
				break;
			} else {
				at = [attrs objectForKey:@"IMAGE"];
				if(at) {
					UIImage* image = [self.delegate getImageNamed:at];
					if(image != nil) {						
						float vpos = 0;
						NSString* atVPos = [attrs objectForKey:@"IMAGE_VPOS"];
						if(atVPos) {
							vpos = [atVPos floatValue];
						}
						
						CGRect bnd = CGRectMake(0, origins.y - vpos, image.size.width, image.size.height);
						CGContextDrawImage(context, bnd, [image CGImage]);
					}
					
					break;
				}
			}
		}
	}
	
	CFRelease(frame);
}

- (CGSize)calculateHeight {
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
	
	CFRange fitRange = CFRangeMake(0,0);
	CGSize aSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, CFStringGetLength((CFStringRef)attrString)), NULL, CGSizeMake(self.frame.size.width, CGFLOAT_MAX), &fitRange);
	
	CFRelease(framesetter);
	
	return aSize; 
}

#pragma mark -
#pragma mark Life cycle management

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self setup];
    }
    return self;
}

- (void)awakeFromNib {
	[self setup];
}

- (void)setup {
	/* this will ensure that the layer will be redrawn when the user changes the autorotation */
	CALayer *layer = self.layer;
	[layer setNeedsDisplayOnBoundsChange:YES];
}

- (void)dealloc {
	if(attrString) {
		CFRelease(attrString);
	}
	[targetList release];
	[text release];
	self.delegate = nil;
	
	[super dealloc];
}


@end
