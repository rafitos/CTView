//
//  CTVParser.h
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTView.h"
#import "CTVFontTag.h"

@interface CTVParser : NSObject <NSXMLParserDelegate> {	
	NSMutableArray* tagList;
	NSMutableArray* tagStack;	
	NSMutableString* textBody;

	NSArray* decorators;
}

- (CFAttributedStringRef)newAttributedStringFromText:(NSString*)text forView:(CTView*)view;
- (void)startTextParsing:(NSString*)text;
- (CFAttributedStringRef)decorateForView:(UIView*)view;
- (void)decorate:(CFMutableAttributedStringRef)attrString withTag:(CTVFontTag*)tag forView:(UIView*)view;
- (NSDictionary*)getStyledAttributesForTag:(CTVFontTag*)tag;
- (void)finishTextParsing;
- (void)addTagToStack:(NSDictionary*)attributeDict;
- (void)appendTextToBody:(NSString*)string;
- (void)moveTagFromStackToList;

@end
