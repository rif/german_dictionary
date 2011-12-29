//
//  RelatedWordsTableViewController.h
//  Doxa
//
//  Created by Radu Ioan Fericean on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Word;

@interface RelatedWordsTableViewController : UITableViewController {
	Word *word;
}

@property(nonatomic, retain) Word *word;

@end
