//
//  ShareController.h
//  SpinArt
//
//  Created by Rim Rami on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FBConnect.h"
#import "SpinArtAppDelegate.h"
#import "TwitpicEngine.h"

@interface ShareController : UITableViewController
{
	SpinArtAppDelegate* delegate;
	SEL				messageSender;
}

@property (nonatomic, retain) SpinArtAppDelegate* delegate;

-(void) back;
-(void)setImage:(UIImage*)image;
-(void)sendEmail;
-(void)saveImage;
-(void) login;
-(void) twitter:(NSString*) strDetail;
@end
