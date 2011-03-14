//
//  CTVParser.m
//  CTView
//
//  Created by Rafael Imas on 12/03/11.
//  Copyright 2011 Rafael Imas. All rights reserved.
//

#import "CTVParser.h"
#import "CTVStyler.h"
#import "CTDecoratorTouched.h"
#import "CTDecoratorFontName.h"
#import "CTDecoratorFontFile.h"
#import "CTDecoratorAlignment.h"
#import "CTDecoratorColor.h"
#import "CTDecoratorImage.h"

@implementation CTVParser

- (CFAttributedStringRef)newAttributedStringFromText:(NSString*)text forView:(CTView*)view {
	CFAttributedStringRef attrString;
	
	[self startTextParsing:text];
	attrString = [self decorateForView:view];
	[self finishTextParsing];
			
	return attrString;
}

- (void)startTextParsing:(NSString*)text {
	tagList = [[NSMutableArray alloc] init];
	tagStack = [[NSMutableArray alloc] init];
	textBody = [[NSMutableString alloc] init];
	
	NSXMLParser *theParser = [[NSXMLParser alloc] initWithData:[text dataUsingEncoding:NSUTF8StringEncoding]];
	[theParser setDelegate:self];	
	[theParser parse];
	[theParser release];	
}

- (CFAttributedStringRef)decorateForView:(UIView*)view {
	CFMutableAttributedStringRef attrString;
	attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);		
	CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), (CFStringRef)textBody);
	
	for(CTVFontTag *ttag in tagList) {
		[self decorate:attrString withTag:ttag forView:view];
	}
	
	return attrString;
}

- (void)decorate:(CFMutableAttributedStringRef)attrString withTag:(CTVFontTag*)tag forView:(UIView*)view {
	NSDictionary *atts = [self getStyledAttributesForTag:tag];
	
	for(id <CTVDecorator> d in decorators) {
		[d decorateString:attrString withValues:atts starting:tag.startPos ending:tag.endPos forView:view];
	}
}

- (NSDictionary*)getStyledAttributesForTag:(CTVFontTag*)tag {
	NSDictionary* atts = tag.attributes;
	
	NSString* style = [tag.attributes valueForKey:@"style"];
	if(style) {
		atts = [NSMutableDictionary dictionaryWithDictionary:[CTVStyler getStyleNamed:style]];
		for(NSString* key in tag.attributes) {
			[atts setValue:[tag.attributes valueForKey:key] forKey:key];
		}
	}
	
	return atts;
}

- (void)finishTextParsing {
	[textBody release];
	[tagStack release];
	[tagList release];
}

#pragma mark -
#pragma mark NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	[self addTagToStack:attributeDict];
}

- (void)addTagToStack:(NSDictionary*)attributeDict {
	CTVFontTag* ttag = [CTVFontTag fontTagWithAttributes:attributeDict startPos:[textBody length]];
	[tagStack addObject:ttag];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[self appendTextToBody:string];
}

- (void)appendTextToBody:(NSString*)string {
	[textBody appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	[self moveTagFromStackToList];
}

- (void)moveTagFromStackToList {
	CTVFontTag* ttag = (CTVFontTag*)[tagStack lastObject];
	ttag.endPos = [textBody length];
	[tagList insertObject:ttag atIndex:0];
	[tagStack removeLastObject];
}

#pragma mark -
#pragma mark Life cycle management

- (id)init {
	if(self = [super init]) {
		decorators = [NSArray arrayWithObjects:	
					  [[[CTDecoratorTouched alloc] init] autorelease], 
					  [[[CTDecoratorFontName alloc] init] autorelease], 
					  [[[CTDecoratorFontFile alloc] init] autorelease], 
					  [[[CTDecoratorAlignment alloc] init] autorelease], 
					  [[[CTDecoratorColor alloc] init] autorelease], 
					  [[[CTDecoratorImage alloc] init] autorelease], 
					  nil];
		[decorators retain];
	}
	return self;
}

- (void)dealloc {
	[decorators release];
	
	[super dealloc];
}

@end
