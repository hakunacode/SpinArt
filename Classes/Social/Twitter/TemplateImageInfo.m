//
//  TemplateImageInfo.m
//  CoolFlyrsMain
//
//  Created by apple apple on 06/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TemplateImageInfo.h"


@implementation TemplateImageInfo

@synthesize Templateid,TemplateImage;

-(id)initWithName:(int)Lid Name:(NSData *)N 
{
	self.Templateid=Lid;
	self.TemplateImage=N;
	
	return self;
}

- (void)dealloc {
	
	[TemplateImage release];
	
    [super dealloc];
}
@end
