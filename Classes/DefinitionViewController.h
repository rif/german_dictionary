//
//  DefinitionViewController.h
//  Doxa
//
//  Created by Radu Ioan Fericean on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RelatedWordsTableViewController;
@class DefinitionTableViewController;

@interface DefinitionViewController : UIViewController {
	DefinitionTableViewController *definitionTableViewController;
	RelatedWordsTableViewController *relatedWordsTableViewController;
}

@property(nonatomic, retain) IBOutlet DefinitionTableViewController *definitionTableViewController;
@property(nonatomic, retain) IBOutlet RelatedWordsTableViewController *relatedWordsTableViewController;

@end
