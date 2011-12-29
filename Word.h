//
//  Word.h
//  Doxa
//
//  Created by Radu Ioan Fericean on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Word : NSObject {
	NSString *word;
	NSString *definition;
	NSArray *relatedWords;
}

@property (nonatomic, copy) NSString *word, *definition;
@property (nonatomic, retain) NSArray *relatedWords;

+ (id)initWithWord:(NSString *)word definition:(NSString *)definition;

@end
