//
//  RootViewController.h
//  SpinArt
//
//  Created by Rim Rami on 10/13/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuController.h"
#import "ShareController.h"
#import "HelpController.h"
#import "AboutController.h"
#import <MessageUI/MFMailComposeViewController.h>

@class SpinArtAppDelegate;
@interface RootViewController : UIViewController <UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, TwitpicEngineDelegate>
{
	SpinArtAppDelegate* delegate;
	UIImageView*		m_pUploadingView;
	BOOL				m_bPermission;
	Facebook*				_facebook;
	SEL					sender;
	
	UIActivityIndicatorView *activityIndicator;
	UIAlertView *alertMain;
	UITextField *textField;
	UITextField *textField2;
	UIImage*		uiImage;
	NSString*		m_strMessage;	
	
	NSArray*				_permissions;
}
@property(readonly) int request_type;
@property(readonly) Facebook *facebook;
@property (nonatomic, retain) SpinArtAppDelegate* delegate;

- (void) ShowMainMenu:(UIImage*)image;
-(void) ShowShareView:(UIImage*)image;
-(void) ShowHelpView;
-(void) ShowAboutView;
-(void)launchMailAppOnDevice;
-(void)displayComposerSheet;
-(void)sendMail;

//Twitter
-(void) actionLogin;
-(void) twitter:(NSString*) strDetail;
-(void) addAlertWindow;

//facebook
-(void) login;
- (void) uploadItem;
- (void)alertSimpleAction:(NSString*) strMessage;
//-(void) cancelLogin;
//-(void) GetExtendedFBPermissions;
//-(void) facebookUpload;

@end
