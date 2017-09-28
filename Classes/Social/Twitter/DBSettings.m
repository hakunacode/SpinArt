//
//  DBSettings.m
//  DisneyPlanner
//
//  Created by Hytech Professional on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DBSettings.h"


@implementation DBSettings
@synthesize DBName,DBPath;


-(id)initWithName:(NSString *)gid
{
	DBName = @"CoolFlyrs.sqlite";
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	DBPath = [documentsDir stringByAppendingPathComponent:DBName];
	[documentsDir release];
	[documentPaths release];
	return self;
}


-(void) checkAndCreateDatabase
{
	
	DBName=@"CoolFlyrs.sqlite";
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	DBPath = [documentsDir stringByAppendingPathComponent:DBName];
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:DBPath];
	// If the database already exists then return without doing anything
	if(success) return;
	// If not then proceed to copy the database from the application to the users filesystem
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBName];
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:DBPath error:nil];
	[fileManager release];
	
}


@end
