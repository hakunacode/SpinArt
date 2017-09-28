//
//  MainMenuView.h
//  SpinArt
//
//  Created by Rim Rami on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Button.h"

@class MainMenuController;
@class SwitchView;

@interface MainMenuView : UIView {
	Button *uiShape;
	Button *uiWhite;
	Button *uiCurrentColor;
	Button *uiFromPhoto;
	Button *uiClear;
	
	UIImageView *uiPiece;
	UIImageView *uiBackground;
	
	SwitchView*			rootView;
	
	bool isPhone;
}

@property (nonatomic, retain) Button*				uiShape;
@property (nonatomic, retain) Button*				uiWhite;
@property (nonatomic, retain) Button*				uiCurrentColor;
@property (nonatomic, retain) Button*				uiFromPhoto;
@property (nonatomic, retain) Button*				uiClear;
@property (nonatomic, retain) UIImageView*			uiPiece;
@property (nonatomic, retain) UIImageView*			uiBackground;
@property (nonatomic, retain) SwitchView*			rootView;

-(void) onShape;
-(void) onWhite;
-(void) onCurrentColor;
-(void) onFromPhoto;
-(void) onClear;
-(void)setSelectImage:(UIImage*)image;

@end
