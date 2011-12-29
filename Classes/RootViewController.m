//
//  RootViewController.m
//  Doxa
//
//  Created by Radu Ioan Fericean on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DoxaAppDelegate.h"
#import "DefinitionViewController.h"
#import "Word.h"
#import "RelatedWordsTableViewController.h"
#import "DefinitionTableViewController.h"
#import <sqlite3.h>

@implementation RootViewController

static NSMutableDictionary *sections = nil;

@synthesize filteredListContent, searchController, definitionViewController, sectionIndex;


+ (NSDictionary *)getSections {
    if (!sections) sections = [[NSMutableDictionary alloc] initWithCapacity: 30]; // 30 letters in the alphabeth
    return sections;
}

#pragma mark -
#pragma mark View lifecycle

- (void) loadDataFromDb {
	NSLog (@"loadDataFromDb");
	
	sqlite3 *db;
	int dbrc; // database return code
	DoxaAppDelegate *appDelegate = (DoxaAppDelegate*)
	[UIApplication sharedApplication].delegate;
	const char* dbFilePathUTF8 = [appDelegate.dbFilePath UTF8String];
	NSLog(@"db path: %@", appDelegate.dbFilePath);
	dbrc = sqlite3_open (dbFilePathUTF8, &db);
	if (dbrc) {
		NSLog (@"couldn't open db:");
		return;
	}
	NSLog (@"opened db");
	
	// select stuff
	sqlite3_stmt *dbps; // database prepared statement
	NSString *queryStatementNS = @"select word, definition, related from dict order by id COLLATE NOCASE;";
	const char *queryStatement = [queryStatementNS UTF8String];
	dbrc = sqlite3_prepare_v2 (db, queryStatement, -1, &dbps, NULL);
	NSLog (@"prepared statement");
	
	// at this point, clear out any existing table model array and prepare new one
	//[[RootViewController getSections] release];
	//self.sectionIndex = [[NSMutableArray alloc] initWithCapacity: 30];
	self.sectionIndex = [NSArray arrayWithObjects: @"A", @"Ä", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"Ö", @"P", @"Q", @"R", @"S", @"T", @"U", @"Ü", @"V", @"W", @"X", @"Y", @"Z", nil];
	
	// repeatedly execute the prepared statement until we're out of results
	//START:code.DatabaseShoppingList.readFromDatabaseResults
	NSString *lastSection = nil;
	NSMutableArray *dictionaryItems = nil;
	while ((dbrc = sqlite3_step (dbps)) == SQLITE_ROW) {
		NSString *wordValue = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text (dbps, 0)];
		NSString *definitionValue = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text (dbps, 1)];
		NSString *relatedValue = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text (dbps, 2)];
		
		NSString *firstLetter = [[wordValue substringToIndex: 1] uppercaseString];
		if ([firstLetter isEqualToString: @"ä"]) firstLetter = @"Ä";
		if ([firstLetter isEqualToString: @"ö"]) firstLetter = @"Ö";
		if ([firstLetter isEqualToString: @"ü"]) firstLetter = @"Ü";

		if (! [lastSection isEqualToString: firstLetter]) {
			lastSection = firstLetter;
			//if (dictionaryItems) [dictionaryItems release];
			dictionaryItems = nil;
			dictionaryItems = [[RootViewController getSections] valueForKey: firstLetter];

			if (dictionaryItems == nil) {
				dictionaryItems = [[NSMutableArray alloc] initWithCapacity: 350]; // arbitrary capacity
				//[self.sectionIndex addObject:firstLetter];
				[[RootViewController getSections] setValue:dictionaryItems forKey:firstLetter];
			}
		}
		Word *newWord = [Word initWithWord:wordValue definition:definitionValue]; 
		newWord.relatedWords = [relatedValue componentsSeparatedByString:@","];
		[dictionaryItems addObject: newWord];
		// release our interest in all the value items
		[wordValue release];
		[definitionValue release];
		[relatedValue release];
	}
	//END:code.DatabaseShoppingList.readFromDatabaseResults
	
	// done with the db.  finalize the statement and close
	sqlite3_finalize (dbps);
	sqlite3_close(db);
	NSLog(@"finished db loading");
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSUserDefaults standardUserDefaults] setObject: [NSArray arrayWithObjects:@"de", nil] forKey:@"AppleLanguages"];
	// load the database into memory
	[self loadDataFromDb];
	self.title = @"Fremdwörterlexikon";
	self.filteredListContent = [NSMutableArray arrayWithCapacity:300];
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	//self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of self.sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return 1;
    }
	else
	{
         return [self.sectionIndex count];
    }
   
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
		NSString *key = [self.sectionIndex objectAtIndex: section];
        return [[[RootViewController getSections] valueForKey:key] count];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	// Configure the cell.
	
	Word *word;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        word = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
		NSString *key = [self.sectionIndex objectAtIndex: indexPath.section];
        NSArray *dictionaryItems = [[RootViewController getSections] valueForKey:key];
		word = [dictionaryItems objectAtIndex: indexPath.row];
    }
	cell.textLabel.text = word.word;

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return nil;
    }
	else
	{
        return [self.sectionIndex objectAtIndex:section];
    }
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	[self.navigationController pushViewController:self.definitionViewController animated:YES];
	
	Word *word;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        word = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
		NSString *key = [self.sectionIndex objectAtIndex: indexPath.section];
        NSArray *dictionaryItems = [[RootViewController getSections] valueForKey: key];
		word = [dictionaryItems objectAtIndex: indexPath.row];
    }
	
	self.definitionViewController.title = word.word;
	self.definitionViewController.definitionTableViewController.definition = word.definition;
    [(UITableView*)self.definitionViewController.definitionTableViewController.view reloadData];
	self.definitionViewController.relatedWordsTableViewController.word = word;
	[(UITableView*)self.definitionViewController.relatedWordsTableViewController.view reloadData];

}

- (IBAction)returnToWordList {
	[self.navigationController popToRootViewControllerAnimated:YES];
	[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for words whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	
	for (NSString *key in [RootViewController getSections]) {
		for(Word *word in [[RootViewController getSections] valueForKey:key]){
			if ([word.word rangeOfString: searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)].length != 0) {
				[self.filteredListContent addObject: word];
			}
		}
	}
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:nil];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope: nil];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (tableView == self.searchDisplayController.searchResultsTableView)
		return nil;
	return self.sectionIndex;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
		return -1;
	return index;
}

- (void)dealloc {
	[[RootViewController getSections] release];
	[self.sectionIndex release];
	[filteredListContent release];
	[searchController release];
	[definitionViewController release];
    [super dealloc];
}


@end

