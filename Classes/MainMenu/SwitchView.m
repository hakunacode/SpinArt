//
//  SwitchView.m
//  SpinArt
//
//  Created by Rim Rami on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SwitchView.h"
#import <QuartzCore/QuartzCore.h>
#import "MainMenuController.h"

@implementation SwitchView

@synthesize mainView;
@synthesize selView;
@synthesize parent;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		mainView = [[MainMenuView alloc] initWithFrame:frame];
		selView  = [[SelectImageView alloc] initWithFrame:frame];
		
		mainView.rootView = self;
		selView.rootView = self;
		
		mainView.hidden = NO;
		selView.hidden = YES;
		
		[self addSubview:mainView];
		[self addSubview:selView];
		
		transitioning = NO;
    }
    return self;
}

-(void)performTransition:(int)type transition:(int)_transition
{
	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = 0.75;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	// Now to set the type of transition. Since we need to choose at random, we'll setup a couple of arrays to help us.
	NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
	NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
	int rnd = random() % 4;
	transition.type = types[rnd/*type*/];
	if(rnd < 3) // if we didn't pick the fade transition, then we need to set a subtype too
	{
		transition.subtype = subtypes[random() % 4/*_transition*/];
	}
	
	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
	transitioning = YES;
	transition.delegate = self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[self.layer addAnimation:transition forKey:nil];
	
	// Here we hide view1, and show view2, which will cause Core Animation to animate view1 away and view2 in.
	if (mainView.hidden == YES) {
		mainView.hidden = NO;
		selView.hidden = YES;
	}else {
		mainView.hidden = YES;
		selView.hidden = NO;
	}
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	transitioning = NO;
}

-(void)nextTransition:(int)type transition:(int)_transition
{
	if(!transitioning)
	{
		[self performTransition:type transition:_transition];
	}
}

-(void) onWhite
{
	[parent setWhiteColor];
}

-(void) onCurrentColor
{
	[parent setCurrentColor];
}

-(void) onFromPhoto
{
	[parent loadFromlibrary];
}

-(void) onFromPhotoPad
{
	[parent loadFromlibraryPad];
}

-(void) onClear
{
	[parent clearBackground];
}

-(void) setShape:(UIImage*)image
{
	[parent setShape:image];
}

-(void)setShadow:(UIImage*)image
{
	[parent setShadow:image];
	[parent back];
}

-(void)setSelectImage:(UIImage*)image
{
	[mainView setSelectImage:image];
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
