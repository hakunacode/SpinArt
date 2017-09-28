//
//  SwitchView.h
//  SpinArt
//
//  Created by Rim Rami on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuView.h"
#import "SelectImageView.h"

@class MainMenuController;

@interface SwitchView : UIView {
	MainMenuView*		mainView;
	SelectImageView*	selView;
	MainMenuController* parent;
	
	BOOL transitioning;
}

@property (nonatomic, retain) MainMenuView*			mainView;
@property (nonatomic, retain) SelectImageView*		selView;
@property (nonatomic, retain) MainMenuController*	parent;

-(void)performTransition:(int)type transition:(int)_transition;
-(void)nextTransition:(int)type transition:(int)_transition;
-(void) onWhite;
-(void) onWhite;
-(void) onCurrentColor;
-(void) onFromPhoto;
-(void) onFromPhotoPad;
-(void) onClear;
-(void) setShape:(UIImage*)image;
-(void)setShadow:(UIImage*)image;
-(void)setSelectImage:(UIImage*)image;
@end
