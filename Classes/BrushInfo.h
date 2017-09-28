//
//  BrushInfo.h
//  SpinArt
//
//  Created by Rim Rami on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrushInfo : NSObject {
@public
	uint	patten;
	float	x, y;
	double	brushSize;
	float	clearColor_[4];
}

@end
