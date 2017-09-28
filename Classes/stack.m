//
//  statck.m
//  SpinArt
//
//  Created by Rim Rami on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "stack.h"


@implementation stack

- (id)init
{
	top = 0;
	m_Data = [[NSMutableArray alloc] init];
	return self;
}

/*-(bool) push:(CCArray*)data
{
	top = 0;
	[m_Data addObject:[data copy]];
	return YES;
}
*/
- (bool) push:(UIImage*)data
{
	top = 0;
	[m_Data addObject:data];
	return YES;	
}

-(uint) getCount
{
	return [m_Data count] - 1;
}
/*
-(CCArray*) getData:(int)index
{
	return [m_Data objectAtIndex:index];
}
*/
- (UIImage*) getData:(int)index
{
	return [m_Data objectAtIndex:index];
}

-(void) empty
{
//	for (int i = 1; i < [m_Data count]; i++) {
//		[m_Data removeObjectAtIndex:i];
//	}
	[m_Data removeAllObjects];
	top = 0;
}

-(void) pop
{
	top++;
	if (top > MAXCOUNT || [m_Data count] == 0 || limit == [m_Data count]){
		limit = [m_Data count];
		return;
	}
	
	return [m_Data removeLastObject];
}
@end
