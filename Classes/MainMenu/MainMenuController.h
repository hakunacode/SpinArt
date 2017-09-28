//
//  MainMenuController.h
//  SpinArt
//
//  Created by Rim Rami on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinArtAppDelegate.h"

@interface MainMenuController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	SpinArtAppDelegate* delegate;
	UIPopoverController* popoverController;
	bool isPhone;
}
@property (nonatomic, retain) UIPopoverController* popoverController;

-(void) back;
-(void) setShape:(UIImage*)image;
-(void)setShadow:(UIImage*)image;
-(void)setSelectImage:(UIImage*)image;
-(void) setWhiteColor;
-(void) setCurrentColor;
- (void) loadFromlibrary;
- (void) loadFromlibraryPad;
-(void) clearBackground;
@end
