//
//  DefinitionViewController.m
//  Doxa
//
//  Created by Radu Ioan Fericean on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DoxaAppDelegate.h"
#import "RootViewController.h"
#import "DefinitionViewController.h"


@implementation DefinitionViewController

@synthesize definitionTableViewController, relatedWordsTableViewController;



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	RootViewController *rvc = (RootViewController*)[((DoxaAppDelegate*)[UIApplication sharedApplication].delegate).navigationController.viewControllers objectAtIndex:0];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:rvc action:@selector(returnToWordList)];
	self.navigationItem.rightBarButtonItem = backButton;
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[definitionTableViewController release];
	[relatedWordsTableViewController release];
    [super dealloc];
}


@end
