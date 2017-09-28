//
//  statck.h
//  SpinArt
//
//  Created by Rim Rami on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define MAXCOUNT 3

@interface stack : NSObject {
	int limit;
	int top;
	NSMutableArray	*m_Data;
}

- (id)init;
//- (bool) push:(CCArray*)data;
- (bool) push:(UIImage*)data;
- (void) pop;
- (uint) getCount;
-(void) empty;
//- (CCArray*) getData:(int)index;
- (UIImage*) getData:(int)index;
@end
