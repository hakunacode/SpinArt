//
//  Databasemanager.h
//  mapLines
//
//  Created by Administrator on 7/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface Databasemanager : NSObject 
{
	
	NSString *DatabaseName;
	NSString *DatabasePath;
	
}


@property (nonatomic, retain) NSString *DatabaseName;
@property (nonatomic, retain) NSString *DatabasePath;

-(BOOL)DeleteTemplateByID:(int)TemplateID;
-(NSMutableArray*)GetTemplateImage;

-(BOOL)SetBackgroundImage:(UIImage*)CheckImage;
-(NSData*)GetTemplateImageByID:(int)TemplateID;

-(BOOL)SetTwitterDetails:(NSString*)Username :(NSString*)Password;
-(NSMutableArray*)GetTwitterDetails;
@end
