//
//  Button.m
//
//  Created by Kim HoSung on 08/12/16.
//  Copyright 2008 Dalian. All rights reserved.
//

#import "Button.h"


@implementation Button

- (id)init: (NSString*) imgName focusName:(NSString*)focusName disableName:(NSString*)disableName title:(NSString*) title {
	// Retrieve the image for the view and determine its size
	UIImage *image = [UIImage imageNamed:imgName];
	UIImage *focusImage = [UIImage imageNamed:focusName];
	UIImage *disableImage = [UIImage imageNamed:disableName];
	
	CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
	[self initWithFrame:frame];
	NSString*buttonText =  NSLocalizedStringFromTable(title, @"English", @"");	
	[self setBackgroundImage:image forState:UIControlStateNormal];
	[self setBackgroundImage:focusImage forState:UIControlStateHighlighted];
	[self setBackgroundImage:disableImage forState:UIControlStateDisabled];
	[self setTitle:buttonText forState:UIControlStateNormal];	
	[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	self.titleLabel.font = [UIFont systemFontOfSize:18];
	[self titleRectForContentRect: CGRectMake(0, 0, 10, 10)];
	return self;
}

- (void) setFontColor: (UIColor*) color {
	[self setTitleColor:color forState:UIControlStateNormal];
}

- (void) setButtonImage: (NSString*) szFileName {
	UIImage *image = [UIImage imageNamed:szFileName];
	[self setImage:image forState:UIControlStateNormal];
}

- (void)dealloc {
	[super dealloc];
}


@end
