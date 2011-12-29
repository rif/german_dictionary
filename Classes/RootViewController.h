//
//  RootViewController.h
//  Doxa
//
//  Created by Radu Ioan Fericean on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@class DefinitionViewController;

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
	DefinitionViewController *definitionViewController;
	UISearchDisplayController *searchController;
	NSArray *sectionIndex; //keeps an ordered list of sections
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
}

@property (nonatomic, retain) NSArray *sectionIndex;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property(nonatomic, retain) IBOutlet DefinitionViewController *definitionViewController;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchController;

- (IBAction)returnToWordList;
+ (NSDictionary *) getSections; 
@end
