//
//  SelectImageView.m
//  SpinArt
//
//  Created by Rim Rami on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectImageView.h"
#import "SwitchView.h"


#define SIZE 120
#define PAD_SIZE 300

@implementation SelectImageView

@synthesize rootView;

NSString* strArray[6] = 
{
	@"ractangl",
	@"circl",
	@"close",
	@"tt",
	@"gg",
	@"hhh"
};

NSString* strShadow[6] = 
{
	@"00000.png",
	@"000000.png",
	@"00.png",
	@"0000.png",
	@"0.png",
	@"000.png"
};

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
			isPhone = YES;
		}
		
		int sizeW, sizeH;
		sizeW = isPhone?SIZE:PAD_SIZE;
		sizeH = isPhone?SIZE:PAD_SIZE;
		
		for (int i = 0; i < 6; i++) {
			UIImage* image = [UIImage imageNamed:SHImageString(strArray[i], @"png")];
			CGRect frame = CGRectMake(0, 0, sizeW, sizeH);
			
			uiImage[i] = [[UIButton alloc] initWithFrame:frame];
			uiImage[i].center = CGPointMake((isPhone?100:250)+(i%2)*sizeW, (isPhone?140:280)+(i/2)*sizeH);
			[uiImage[i] setBackgroundImage:image forState:UIControlStateNormal];
			[uiImage[i] setBackgroundImage:image forState:UIControlStateHighlighted];
			[uiImage[i] setBackgroundImage:image forState:UIControlStateDisabled];
			[uiImage[i]  addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:uiImage[i]];
		}
    }
    return self;
}

-(void)onClick:(id)sender
{
	for (int i = 0; i < 6; i++) {
		if (sender == uiImage[i]) {
			UIImage* image = [UIImage imageNamed:SHImageString(strArray[i], @"png")];
			UIImage* imageShow = [UIImage imageNamed:strShadow[i]];
			[rootView setShape:image];
			[rootView setShadow:imageShow];
			return;
		}
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
