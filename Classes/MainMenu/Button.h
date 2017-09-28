//
//  Button.h
//  iIgo
//
//  Created by Kim Kang U on 08/12/16.
//  Copyright 2008 Dalian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Button : UIButton {
	CGFloat _fontSize;
}


//Initalizer for this object
- (id)init: (NSString*) imgName focusName:(NSString*)focusName disableName:(NSString*)disableName title:(NSString*) title;
- (void) setFontColor: (UIColor*) color;
- (void) setButtonImage: (NSString*) szFileName;
@end
