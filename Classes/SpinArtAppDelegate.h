//
//  SpinArtAppDelegate.h
//  SpinArt
//
//  Created by Rim Rami on 10/13/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class HelloWorld;

@interface SpinArtAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
	UINavigationController	*navigationController;
	HelloWorld*			gameView;
	Boolean				isiPhone;
	
	NSString*			m_strMessage;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *viewController;
@property (nonatomic, retain) UINavigationController	*navigationController;
@property (nonatomic, retain) HelloWorld*				gameView;
@property (nonatomic, retain) NSString*					m_strMessage;

-(void)saveImage;
-(void)saveImage:(NSString*)path;
-(NSData*) getImageData;
-(void)createClearImage:(UIImage*)image;
-(void)sendMail;
-(void)facebook;
-(void)twitter;
-(void)sendMail;
@end
