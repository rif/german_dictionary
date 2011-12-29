//
//  Word.m
//  Doxa
//
//  Created by Radu Ioan Fericean on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Word.h"


@implementation Word
@synthesize word, definition, relatedWords;


+ (id)initWithWord:(NSString *)word definition:(NSString *)definition;
{
	Word *newWord = [[[self alloc] init] autorelease];
	newWord.word = word;
	newWord.definition = definition;
	return newWord;
}


- (void)dealloc
{
	[word release];
	[definition release];
	[relatedWords release];
	[super dealloc];
}

@end
