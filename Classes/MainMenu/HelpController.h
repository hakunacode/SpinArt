//
//  HelpController.h
//  SpinArt
//
//  Created by Rim Rami on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinArtAppDelegate.h"


@interface HelpController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	SpinArtAppDelegate* delegate;
}
-(void) back;
@end
