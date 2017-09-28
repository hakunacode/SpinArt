//
//  DBSettings.h
//  DisneyPlanner
//
//  Created by Hytech Professional on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DBSettings : NSObject {

	NSString *DBName;
	NSString *DBPath;

	//static NSString *DBName = @"DisnyPlannerDB.sql";
	//NSString *DBPath;

}
@property (nonatomic,retain) NSString *DBName;
@property (nonatomic,retain) NSString *DBPath;
-(id)initWithName:(NSString *)gid;
-(void) checkAndCreateDatabase;
@end
