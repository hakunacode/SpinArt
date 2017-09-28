//
//  ShareView.h
//  SpinArt
//
//  Created by Rim Rami on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Button.h"

@class ShareController;
@class SpinArtAppDelegate;

@interface ShareView : UIView {
	Button *uiSave;
	Button *uiEmail;
	Button *uiPrint;
	Button *uiPost;
	Button *uiTweet;
	UITextView* uiTextView;
	
	UIImageView* uiImage;
	ShareController*	m_parent;
	SpinArtAppDelegate*	delegate;
}

@property (nonatomic, retain) Button*				uiSave;
@property (nonatomic, retain) Button*				uiEmail;
@property (nonatomic, retain) Button*				uiPrint;
@property (nonatomic, retain) Button*				uiPost;
@property (nonatomic, retain) Button*				uiTweet;
@property (nonatomic, retain) UITextView*			uiTextView;
@property (nonatomic, retain) ShareController*		m_parent;
@property (nonatomic, retain) UIImageView*			uiImage;
@property (nonatomic, retain) SpinArtAppDelegate*	delegate;

-(void)setImage:(UIImage*)image;
-(void)onSave;
-(void)onEmail;
-(void)onPrint;
-(void)onPost;
-(void)onTweet;
@end
