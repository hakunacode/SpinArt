//
//  ShareController.m
//  SpinArt
//
//  Created by Rim Rami on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareController.h"
#import "ShareView.h"
#import "SpinArtAppDelegate.h"

@implementation ShareController

@synthesize delegate;

- (void)loadView {
	delegate = [[UIApplication sharedApplication] delegate];
	CGRect rc;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		rc = CGRectMake(0, 0, 320, 480);
	}else{ 
		rc = CGRectMake(0, 0, 768, 1024);
	}
	
	ShareView* share = [[ShareView alloc] initWithFrame:rc];
	share.m_parent = self;
	self.view = share;
	[share.m_parent release];
//	[share release];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Save & Share";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Dismiss" 
															style:UIBarButtonItemStyleBordered target:self action:@selector(back)] autorelease]; 
}

-(void)sendEmail
{
	messageSender = @selector(sendMail);
	[self back];
}

//twittr
-(void) twitter:(NSString*) strDetail
{
	delegate.m_strMessage = strDetail;
	messageSender = @selector(twitter);
	[self back];
}

-(void) login
{
	messageSender = @selector(facebook);
	[self back];
}

-(void) back
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)setImage:(UIImage*)image
{
	ShareView* share = (ShareView*)self.view;
	[share setImage:image];
	[share release];
}

-(void)saveImage
{
	messageSender = @selector(saveImage);
	[self back];
}

- (void)dealloc {
	if (messageSender) {
		[delegate performSelector:messageSender];
		messageSender = nil;
	}

    [super dealloc];
}

@end
