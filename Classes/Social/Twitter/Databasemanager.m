//
//  Databasemanager.m
//  mapLines
//
//  Created by Administrator on 7/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Databasemanager.h"
#import"DBSettings.h"
#import "TemplateImageInfo.h"


static sqlite3_stmt *addStmt = nil;

static sqlite3_stmt *deleteStmt = nil;


@implementation Databasemanager
@synthesize DatabaseName;
@synthesize DatabasePath;

-(BOOL)SetBackgroundImage:(UIImage*)CheckImage
{
	@try{
		DBSettings *dbSettings = [[DBSettings alloc]init];
		[dbSettings checkAndCreateDatabase];
		DatabaseName=dbSettings.DBName;
		DatabasePath=dbSettings.DBPath;
		[dbSettings release];
		sqlite3 *database; 
		if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) {
			
			sqlite3_stmt *insert_statement;     
			
		  
			//NSData *imgData= UIImageJPEGRepresentation(CheckImage, 0);
			
			NSData *imgData= UIImagePNGRepresentation(CheckImage);
						
			const char *sql_query = "INSERT INTO tbl_coolflyrs (Template_Image) VALUES (?)";
			
			if (sqlite3_prepare_v2(database,sql_query, -1, &insert_statement, NULL) == SQLITE_OK)
			{
				
					
				sqlite3_bind_blob(insert_statement, 1, [imgData bytes], [imgData length], NULL);
							
				sqlite3_step(insert_statement);
			}
		
	
	
	sqlite3_close(database);
	sqlite3_reset(insert_statement);
	sqlite3_finalize(insert_statement);
			
			return YES;
		}
		
	}
	@catch (id theException) {
		return NO;
		
	}
	return NO;
}

-(BOOL)DeleteTemplateByID:(int)TemplateID
{
	@try{
		DBSettings *dbSettings = [[DBSettings alloc]init];
		[dbSettings checkAndCreateDatabase];
		DatabaseName=dbSettings.DBName;
		DatabasePath=dbSettings.DBPath;
		[dbSettings release];
		sqlite3 *database; 
		if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) {
			
			const char *sqlStatement;
			NSString *sql=@"delete from tbl_coolflyrs where Template_id=%d";
			NSString *sqlFormated=[NSString  stringWithFormat:sql,TemplateID];
			//Convert Nsstring to char pointer
			
			sqlStatement=[sqlFormated UTF8String];
			
			if(sqlite3_prepare_v2(database, sqlStatement, -1, &deleteStmt, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
			
			if(SQLITE_DONE != sqlite3_step(deleteStmt))
			{
				NSAssert1(0, @"Error while deleting data. '%s'", sqlite3_errmsg(database));
			}
			
			sqlite3_finalize(deleteStmt);
			sqlite3_close(database);
			return YES;
		}
		
	}
	@catch (id theException) 
	{
		return NO;
		
	}
	return NO;	
	
}

-(NSMutableArray*)GetTemplateImage
{
	DBSettings *dbSettings = [[DBSettings alloc]init];
	[dbSettings checkAndCreateDatabase];
	DatabaseName=dbSettings.DBName;
	DatabasePath=dbSettings.DBPath;
	sqlite3 *database;
	
	NSMutableArray *ActiveString = [[NSMutableArray alloc] init];
	// Open the database from the users filessytem
	if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = "Select * from tbl_coolflyrs";
		
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			// Loop through the results and add them to the feeds array
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				// Read the data from the result row
				
				NSString *TemplateID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				
				NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, 1) length:sqlite3_column_bytes(compiledStatement, 1)]; 
				
				
				TemplateImageInfo *infoList=[[TemplateImageInfo alloc] initWithName:[TemplateID intValue] Name:data];
				// Add the GiftInfo object to the GiftList Array      
				
				[ActiveString addObject:infoList];
				
				[data release];
				[infoList release];
				
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
	return ActiveString;
	
}


-(NSData*)GetTemplateImageByID:(int)TemplateID
{
	DBSettings *dbSettings = [[DBSettings alloc]init];
	[dbSettings checkAndCreateDatabase];
	DatabaseName=dbSettings.DBName;
	DatabasePath=dbSettings.DBPath;
	sqlite3 *database;
	
	NSData *data;
	
	// Open the database from the users filessytem
	if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement;
		NSString *sql=@"Select Template_Image from tbl_coolflyrs where Template_id=%d";
		NSString *sqlFormated=[NSString  stringWithFormat:sql,TemplateID];
		//Convert Nsstring to char pointer
		
		sqlStatement=[sqlFormated UTF8String];
		
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			// Loop through the results and add them to the feeds array
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				// Read the data from the result row
				
				data = [[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, 0) length:sqlite3_column_bytes(compiledStatement, 0)]; 
				
			
				
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
	return data;
	[data release];
}

-(BOOL)SetTwitterDetails:(NSString*)Username :(NSString*)Password
{
	@try{
		DBSettings *dbSettings = [[DBSettings alloc]init];
		[dbSettings checkAndCreateDatabase];
		DatabaseName=dbSettings.DBName;
		DatabasePath=dbSettings.DBPath;
		[dbSettings release];
		sqlite3 *database; 
		if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) {
			const char *sqlStatement;
			NSString *sql = @"update tbl_TwitterDetails set username='%@', password='%@'";
			NSString *sqlFormated = [NSString stringWithFormat:sql,Username,Password];
			sqlStatement=[sqlFormated UTF8String];
			
			if(sqlite3_prepare_v2(database, sqlStatement, -1, &addStmt, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
			
			sqlite3_bind_text(addStmt, 1, [Username UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 2, [Password UTF8String], -1, SQLITE_TRANSIENT);
			
			
			
			if(SQLITE_DONE != sqlite3_step(addStmt))
			{
				NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
			}
			//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
			
			//Reset the add statement.
			//sqlite3_reset(addStmt);
			sqlite3_finalize(addStmt);
			sqlite3_close(database);
			return YES;
		}
		
	}
	@catch (id theException) {
		return NO;
		
	}
	return NO;
}

-(NSMutableArray*)GetTwitterDetails
{
	DBSettings *dbSettings = [[DBSettings alloc]init];
	[dbSettings checkAndCreateDatabase];
	DatabaseName=dbSettings.DBName;
	DatabasePath=dbSettings.DBPath;
	sqlite3 *database;
	
	NSMutableArray *ActiveString = [[NSMutableArray alloc] init];
	// Open the database from the users filessytem
	if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = "Select * from tbl_TwitterDetails";
		
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			// Loop through the results and add them to the feeds array
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				// Read the data from the result row
				
				NSString *ActiveID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				NSString *ActivePwd = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				
				[ActiveString addObject:ActiveID];	
				[ActiveString addObject:ActivePwd];	
				
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
	return ActiveString;
	
}



@end
