//
//  RootViewController.m
//  SpinArt
//
//  Created by Rim Rami on 10/13/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"
#import <MessageUI/MFMailComposeViewController.h>

#define ACCESS_TOKEN_KEY @"fb_access_token"
#define EXPIRATION_DATE_KEY @"fb_expiration_date"
#define REQUEST_NAME			0
#define REQUEST_ALBUM			1
#define REQUEST_ALBUM_ADD		2
#define REQUEST_UPLOAD			3


@implementation RootViewController

NSString*		m_strTwitterUser;
NSString*		m_strTwitterPassword;

static NSString* kAppId = @"170727826307295";
//static NSString* kAppSecret = @"fb7027c5b5806bf80ac6fc6aeaa5e6fc";

@synthesize request_type = _request_type, facebook = _facebook;
@synthesize delegate;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
		delegate = [[UIApplication sharedApplication] delegate];
		
		m_bPermission = NO;
		_facebook = [[Facebook alloc] init];
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		_facebook.accessToken = [defaults objectForKey:ACCESS_TOKEN_KEY];
		_facebook.expirationDate = [defaults objectForKey:EXPIRATION_DATE_KEY];
		
		_permissions =  [[NSArray arrayWithObjects:
						  @"read_stream", 
						  @"offline_access", 
						  @"publish_stream", 
						  @"read_requests", 
						  @"user_photo_video_tags", 
						  @"friends_photo_video_tags", 
						  @"user_photos", 
						  @"friends_photos", 
						  @"user_videos", 
						  @"friends_videos", 
						  @"read_insights", 
						  @"user_checkins", 
						  @"create_event", 
						  @"publish_checkins", 
						  nil] retain];	 		
	}
	return self;
 }


/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
*/


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	[super viewDidLoad];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	//return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	return ( UIInterfaceOrientationIsPortrait( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect;
	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) ShowMainMenu:(UIImage*)image
{
	MainMenuController* MewMgrController = [[MainMenuController alloc] initWithNibName:@"" bundle:[NSBundle mainBundle]];
	[MewMgrController setSelectImage:image];
//	MainMenuController* MewMgrController = [[MainMenuController alloc] initWithCoder:UITableViewStyleGrouped];
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController: MewMgrController];
	navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	[MewMgrController release];
}

-(void) ShowShareView:(UIImage*)image
{
	ShareController* _viewController = [[ShareController alloc] initWithStyle:UITableViewStyleGrouped];
	[_viewController setImage:image];
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController: _viewController];
	navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	[_viewController release];
}

-(void) ShowHelpView
{
	HelpController* _viewController = [[HelpController alloc] initWithNibName:@"" bundle:[NSBundle mainBundle]];
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController: _viewController];
	navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	[_viewController release];
}

-(void) ShowAboutView
{
	AboutController* _viewController = [[AboutController alloc] initWithNibName:@"" bundle:[NSBundle mainBundle]];
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController: _viewController];
	navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	[_viewController release];
}

-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=";
	NSString *body = @"&body=";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void)displayComposerSheet
{
	MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
	mail.mailComposeDelegate = self;
	
	[mail setSubject:@""];
	
//	NSString* path =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/email.png"];
//	[delegate saveImage:path];
	
	[mail addAttachmentData:[delegate getImageData]  mimeType:@"image/png" fileName:@"Attached image"];
	
	NSString *msg = [NSString stringWithFormat:@"Hi,\nI made this image using SpinArt on my %@.\nEnjoy!", [UIDevice currentDevice].model];
	
	NSString* mailcontent =  [NSString stringWithFormat:@"<br> %@ <br>", msg];
	[mail setMessageBody:mailcontent isHTML:YES];
	
	[self presentModalViewController:mail animated:YES];
	
	[mail release];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissModalViewControllerAnimated:YES];
}

-(void)sendMail
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}

//twittr
-(void) twitter:(NSString*) strDetail
{
	m_strMessage = strDetail;

	if(m_strTwitterUser == nil || m_strTwitterPassword == nil)
	{
//		UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"Twitter Message" message:@"Please login first" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//		[alt show];
//		[alt release];
		[self actionLogin];
		return;
	}
	
	TwitpicEngine *twitpicEngine = [[TwitpicEngine alloc] initWithDelegate:self];
	[self addAlertWindow];
    [twitpicEngine uploadImageToTwitpic:[delegate getImageData] withMessage:NSLocalizedString(@"To my friends from the Picto Frame App!",@"") 
                               username:m_strTwitterUser password:m_strTwitterPassword];
    [twitpicEngine release];
}

-(void) addAlertWindow
{
	alertMain = [[[UIAlertView alloc] initWithTitle:@"Uploading Photo\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[alertMain show];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	// Adjust the indicator so it is up a few pixels from the bottom of the alert
	activityIndicator.center = CGPointMake(150, 85);
	[alertMain addSubview:activityIndicator];
	[activityIndicator startAnimating];
}

- (void)twitpicEngine:(TwitpicEngine *)engine didUploadImageWithResponse:(NSString *)response{
	[activityIndicator stopAnimating];
	[alertMain dismissWithClickedButtonIndex:0 animated:YES];
	
	if([response hasPrefix:@"http://"])
	{
		UIAlertView *baseAlert = [[UIAlertView alloc] initWithTitle:@"Photo Uploaded Successfully." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[baseAlert show];
	}
	else if([[response uppercaseString] isEqualToString:@"ERROR"])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"Error") message:NSLocalizedString(@"Unable to upload Photo",@"Unable to upload Flyers") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss",@"Dismiss") otherButtonTitles: nil];
		[alert show];
		
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"Error") message:response delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss",@"Dismiss") otherButtonTitles: nil];
		[alert show];		
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ([alertView title] == @"Twitter Account Details")
	{
		if( buttonIndex == 1)
		{
            if(textField == nil || textField2 == nil)
            {
                UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"Twitter Message" message:@"Please input user name and password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alt show];
                [alt release];
                return;
            }

            if(textField.text == nil || textField2.text == nil)
            {
                UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"Twitter Message" message:@"Please input user name and password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alt show];
                [alt release];
                return;
            }

			m_strTwitterUser = [[NSString alloc] initWithString:textField.text];
			m_strTwitterPassword = [[NSString alloc] initWithString:textField2.text];
            
            [self twitter:m_strMessage];
		}
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
}

-(void) actionLogin
{
	alertMain = [[UIAlertView alloc] initWithTitle:@"Twitter Account Details" 
										   message:@"\n\n\n" // IMPORTANT
										  delegate:self 
								 cancelButtonTitle:@"Cancel" 
								 otherButtonTitles:@"Enter", nil];
	
	textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)]; 
	[textField setBackgroundColor:[UIColor whiteColor]];
	[textField setPlaceholder:@"username"];
	
	[alertMain addSubview:textField];
	
	textField2 = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)]; 
	[textField2 setBackgroundColor:[UIColor whiteColor]];
	[textField2 setPlaceholder:@"password"];
	[textField2 setSecureTextEntry:YES];
	
	
	[alertMain addSubview:textField2];
	
	// set place
	[alertMain setTransform:CGAffineTransformMakeTranslation(0.30, 5)]; //////
	[alertMain show];
	[alertMain release];
	
	// set cursor and show keyboard
	[textField becomeFirstResponder];
}
///// twitter end //////

//facebook
-(void) login
{
	if ([_facebook isSessionValid]) {
		_request_type = REQUEST_NAME;
		[_facebook requestWithGraphPath:@"me" andDelegate:self];
	} else {
		[_facebook authorize:kAppId permissions:_permissions delegate:self];
	}	
}

- (void) uploadItem
{
	[self addAlertWindow];
	_request_type = REQUEST_UPLOAD;
	
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _facebook.accessToken,@"access_token",
                                   [delegate getImageData],@"source",
                                   @"upload with PhotoUploader",@"message",
                                   nil];
    [_facebook requestWithGraphPath:@"me/photos"
                          andParams:params
                      andHttpMethod:@"POST"
                        andDelegate:self];
}

- (void)fbDidLogin {
	_request_type = REQUEST_NAME;
	[_facebook requestWithGraphPath:@"me" andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_facebook.accessToken forKey:ACCESS_TOKEN_KEY];
    [defaults setObject:_facebook.expirationDate forKey:EXPIRATION_DATE_KEY];
    [defaults synchronize];
}

-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:ACCESS_TOKEN_KEY];
    [defaults setObject:nil forKey:EXPIRATION_DATE_KEY];
    [defaults synchronize];
}


- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
}

- (void)request:(FBRequest *)request didLoad:(id)result 
{
	if (_request_type == REQUEST_NAME) {
		if ([result isKindOfClass:[NSArray class]]) {
			result = [result objectAtIndex:0];
		}
		[self uploadItem];
	} else if (_request_type == REQUEST_UPLOAD) {
        [self alertSimpleAction:@"Upload successful."];
	}
};

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	[self alertSimpleAction:@"Upload fail."];
};

- (void)dialogDidComplete:(FBDialog *)dialog {
}

- (void)alertSimpleAction:(NSString*) strMessage
{
	[activityIndicator stopAnimating];
	[alertMain dismissWithClickedButtonIndex:0 animated:YES];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Uploader" message:strMessage
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
}
//end

- (void)dealloc {
    [super dealloc];
}


@end

