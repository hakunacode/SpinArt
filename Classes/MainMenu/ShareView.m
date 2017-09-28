//
//  ShareView.m
//  SpinArt
//
//  Created by Rim Rami on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareView.h"
#import "ShareController.h"
#import "SpinArtAppDelegate.h"
#import "cocos2d.h"

#define WIDTH 128
#define HEIGHT 128

@implementation ShareView

@synthesize uiSave;
@synthesize uiEmail;
@synthesize uiPrint;
@synthesize uiPost;
@synthesize uiTweet;
@synthesize uiTextView;
@synthesize uiImage;
@synthesize m_parent;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		bool b = NO;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
			b = YES;
		}
		
		UIImageView* uiBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SHImageString(@"gb_011", @"png")]];
		[self addSubview:uiBackground];
		[uiBackground release];
		
//		uiSave = [[Button alloc] init: SHImageString(@"save", @"png") focusName:SHImageString(@"save_a", @"png") disableName:@"" title:@""];
//		uiSave.center = b?ccp(225, 127):ccp(550,270);
//		[self addSubview:uiSave];
//		[uiSave  addTarget:self action:@selector(onSave) forControlEvents:UIControlEventTouchUpInside];
		
//		uiEmail = [[Button alloc] init: SHImageString(@"email", @"png") focusName:SHImageString(@"email_a", @"png") disableName:@"" title:@""];
//		uiEmail.center = b?ccp(225, 175):ccp(550,370);
//		[self addSubview:uiEmail];
//		[uiEmail  addTarget:self action:@selector(onEmail) forControlEvents:UIControlEventTouchUpInside];
		
//		uiPrint = [[Button alloc] init: SHImageString(@"prit", @"png") focusName:SHImageString(@"prit_a", @"png") disableName:@"" title:@""];
//		uiPrint.center = b?ccp(225, 223):ccp(550,470);
//		[self addSubview:uiPrint];
//		[uiPrint  addTarget:self action:@selector(onPrint) forControlEvents:UIControlEventTouchUpInside];
		
		uiSave = [[Button alloc] init: SHImageString(@"save", @"png") focusName:SHImageString(@"save_a", @"png") disableName:@"" title:@""];
		uiSave.center = b?ccp(225, 147):ccp(550,310);
		[self addSubview:uiSave];
		[uiSave  addTarget:self action:@selector(onSave) forControlEvents:UIControlEventTouchUpInside];
		
		uiEmail = [[Button alloc] init: SHImageString(@"email", @"png") focusName:SHImageString(@"email_a", @"png") disableName:@"" title:@""];
		uiEmail.center = b?ccp(225, 205):ccp(550,430);
		[self addSubview:uiEmail];
		[uiEmail  addTarget:self action:@selector(onEmail) forControlEvents:UIControlEventTouchUpInside];

		uiPost = [[Button alloc] init: SHImageString(@"post", @"png") focusName:SHImageString(@"post_a", @"png") disableName:@"" title:@""];
		uiPost.center = b?ccp(94, 433):ccp(220,920);
		[self addSubview:uiPost];
		[uiPost  addTarget:self action:@selector(onPost) forControlEvents:UIControlEventTouchUpInside];
		
		uiTweet = [[Button alloc] init: SHImageString(@"tweet", @"png") focusName:SHImageString(@"tweet_a", @"png") disableName:@"" title:@""];
		uiTweet.center = b?ccp(228, 433):ccp(550,920);
		[self addSubview:uiTweet];
		[uiTweet  addTarget:self action:@selector(onTweet) forControlEvents:UIControlEventTouchUpInside];
		
		uiTextView = [[UITextView alloc] initWithFrame:CGRectMake(b?26:54, b?320:690, b?269:656, b?84:183)];
		[uiTextView setBackgroundColor:[UIColor clearColor]];
		if (!b) {
			[uiTextView setFont:[UIFont fontWithName:@"Thonburi" size:24]];
		}		
		[self addSubview:uiTextView];
		
		uiImage = [[UIImageView alloc] initWithFrame:CGRectMake(b?33:110, b?110:240, b?WIDTH:250, b?HEIGHT:250)];
		[self addSubview:uiImage];
    }
    return self;
}

-(void)setImage:(UIImage*)image
{
	[uiImage setImage:image];
}

-(void)onSave
{
	[m_parent saveImage];
}

-(void)onEmail
{	
	[m_parent sendEmail];
}

-(void)onPrint
{
}

-(void)onPost
{
	[m_parent login];
}

-(void)onTweet
{
	NSString* m_strDetail = [[NSString alloc] initWithString:uiTextView.text];
	[m_parent twitter:m_strDetail];
}

- (void)dealloc {
	[uiEmail release];
	[uiTweet release];
	[uiPost release];
	[uiSave release];
	[uiTextView release];
	[uiImage release];
//	[uiTextView release];

    [super dealloc];
}

@end
