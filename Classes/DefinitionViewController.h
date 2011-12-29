//
//  DefinitionViewController.h
//  Doxa
//
//  Created by Radu Ioan Fericean on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RelatedWordsTableViewController;

@interface DefinitionViewController : UIViewController {
	UITextView *definitionView;
	RelatedWordsTableViewController *relatedWordsTableViewController;
}

@property(nonatomic, retain) IBOutlet UITextView *definitionView;
@property(nonatomic, retain) IBOutlet RelatedWordsTableViewController *relatedWordsTableViewController;

@end
