//
//  SelectImageView.h
//  SpinArt
//
//  Created by Rim Rami on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchView;

@interface SelectImageView : UIView {
	UIButton* uiImage[6];
	SwitchView*		rootView;
	Boolean			isPhone;	
}

@property (nonatomic, retain) SwitchView*			rootView;

-(void)onClick:(id)sender;
@end
