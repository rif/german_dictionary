//
//  DoxaAppDelegate.m
//  Doxa
//
//  Created by Radu Ioan Fericean on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DoxaAppDelegate.h"
#import "RootViewController.h"
#include <sqlite3.h>

@implementation DoxaAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize dbFilePath;

NSString *DATABASE_RESOURCE_NAME = @"doxa9zd";
NSString *DATABASE_RESOURCE_TYPE = @"sqlite3";
NSString *DATABASE_FILE_NAME = @"doxa9zd.sqlite3";



#pragma mark -
#pragma mark Application lifecycle

- (BOOL) initializeDb {
	NSLog (@"initializeDB");
	// look to see if DB is in known location (~/Documents/$DATABASE_FILE_NAME)
	//START:code.DatabaseShoppingList.findDocumentsDirectory
	NSArray *searchPaths =
	NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
	dbFilePath = [documentFolderPath stringByAppendingPathComponent:
				  DATABASE_FILE_NAME];
	//END:code.DatabaseShoppingList.findDocumentsDirectory
	[dbFilePath retain];
	//START:code.DatabaseShoppingList.copyDatabaseFileToDocuments
	if (! [[NSFileManager defaultManager] fileExistsAtPath: dbFilePath]) {
		// didn't find db, need to copy
		NSString *backupDbPath = [[NSBundle mainBundle]
								  pathForResource:DATABASE_RESOURCE_NAME
								  ofType:DATABASE_RESOURCE_TYPE];
		if (backupDbPath == nil) {
			// couldn't find backup db to copy, bail
			return NO;
		} else {
			BOOL copiedBackupDb = [[NSFileManager defaultManager]
								   copyItemAtPath:backupDbPath
								   toPath:dbFilePath
								   error:nil];
			if (! copiedBackupDb) {
				// copying backup db failed, bail
				return NO;
			}
		}
	}
	return YES;
	//END:code.DatabaseShoppingList.copyDatabaseFileToDocuments
	NSLog (@"bottom of initializeDb");
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // copy the database from the bundle if necessary
	if (! [self initializeDb]) {
		// TODO: alert the user!
		NSLog (@"couldn't init db");
		return NO;
	}
	
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[dbFilePath release];
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

