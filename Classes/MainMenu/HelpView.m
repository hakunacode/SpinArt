//
//  HelpView.m
//  SpinArt
//
//  Created by Rim Rami on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelpView.h"


@implementation HelpView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		UIImageView* uiBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SHImageString(@"help_1",@"png")]];
		[self addSubview:uiBackground];
		[uiBackground release];				
    }
    return self;
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
