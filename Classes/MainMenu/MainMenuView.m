//
//  MainMenuView.m
//  SpinArt
//
//  Created by Rim Rami on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuView.h"
#import "MainMenuController.h"
#import "SwitchView.h"

@implementation MainMenuView

@synthesize uiShape;
@synthesize uiWhite;
@synthesize uiCurrentColor;
@synthesize uiFromPhoto;
@synthesize uiClear;
@synthesize uiPiece;
@synthesize uiBackground;
@synthesize rootView;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		isPhone = NO;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
			isPhone = YES;
		}
		
		uiBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SHImageString(@"create",@"png")]];
		[self addSubview:uiBackground];
		[uiBackground release];

		uiShape = [[Button alloc] init: SHImageString(@"more", @"png") focusName:SHImageString(@"more_a", @"png") disableName:@"" title:@""];
		uiShape.center = isPhone?CGPointMake(190,160):CGPointMake(475, 345);
		[self addSubview:uiShape];
		[uiShape  addTarget:self action:@selector(onShape) forControlEvents:UIControlEventTouchUpInside];

		uiWhite = [[Button alloc] init: SHImageString(@"white", @"png") focusName:SHImageString(@"white_a", @"png") disableName:@"" title:@""];
		uiWhite.center = isPhone?CGPointMake(160,213):CGPointMake(375, 450);
		[self addSubview:uiWhite];
		[uiWhite  addTarget:self action:@selector(onWhite) forControlEvents:UIControlEventTouchUpInside];
		
		uiCurrentColor = [[Button alloc] init: SHImageString(@"currint", @"png") focusName:SHImageString(@"currint_a", @"png") disableName:@"" title:@""];
		uiCurrentColor.center = isPhone?CGPointMake(160,256):CGPointMake(375, 545);
		[self addSubview:uiCurrentColor];
		[uiCurrentColor  addTarget:self action:@selector(onCurrentColor) forControlEvents:UIControlEventTouchUpInside];
		
		uiFromPhoto = [[Button alloc] init: SHImageString(@"From", @"png") focusName:SHImageString(@"From_a", @"png") disableName:@"" title:@""];
		uiFromPhoto.center = isPhone?CGPointMake(160,299):CGPointMake(375, 640);
		[self addSubview:uiFromPhoto];
		[uiFromPhoto  addTarget:self action:@selector(onFromPhoto) forControlEvents:UIControlEventTouchUpInside];
		
		uiClear = [[Button alloc] init: SHImageString(@"clear", @"png") focusName:SHImageString(@"clear_a", @"png") disableName:@"" title:@""];
		uiClear.center = isPhone?CGPointMake(160,420):CGPointMake(375, 890);
		[self addSubview:uiClear];
		[uiClear  addTarget:self action:@selector(onClear) forControlEvents:UIControlEventTouchUpInside];
		
		uiPiece = [[UIImageView alloc] initWithFrame:CGRectMake(isPhone?63:151, isPhone?142:302, isPhone?39:94, isPhone?39:84)];
		[self addSubview:uiPiece];
	}
    return self;
}

-(void) onShape
{
	[rootView nextTransition:1 transition:1];
}

-(void) onWhite
{
	[rootView onWhite];
}

-(void) onCurrentColor
{
	[rootView onCurrentColor];
}

-(void) onFromPhoto
{
	if (isPhone)
		[rootView onFromPhoto];
	else 
		[rootView onFromPhotoPad];
}

-(void) onClear
{
	[rootView onClear];
}

-(void)setSelectImage:(UIImage*)image
{
	[uiPiece setImage:image];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[uiShape release];
	[uiWhite release];
	[uiFromPhoto release];
	[uiCurrentColor release];
	[uiClear release];
	
    [super dealloc];
}


@end
