//
//  ColorPickerLayer.m
//  SpinArt
//
//  Created by Rim Rami on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ColorPickerLayer.h"

#define X 110
#define Y 64
#define PAD_X 265
#define PAD_Y 154
#define TITLEW	20
#define TITLEH	18
#define PAD_TITLEW	48
#define PAD_TITLEH	44

#define MAX_X 9
#define MAX_Y 5

colorInfo color[MAX_X+1][MAX_Y+1] = 
{
	{
		{32,6,6},
		{141,30,30},
		{235,120,120},
		{253,188,188},
		{252,235,235},
		{255,255,255}
	},
	{
		{69,5,5},
		{156,48,15},
		{233,79,32},
		{252,139,105},
		{252,184,164},
		{254,226,217}
	},
	{
		{0,255,48},
		{156,253,4},
		{192,254,95},
		{215,254,153},
		{227,253,187},
		{240,253,220}
	},
	{
		{0,25,0},
		{2,86,2},
		{4,182,4},
		{5,252,5},
		{146,253,146},
		{205,253,205}
	},
	{
		{0,55,44},
		{4,125,101},
		{28,184,153},
		{72,251,215},
		{162,253,203},
		{229,253,240}
	},
	{
		{2,35,157},
		{34,169,219},
		{34,219,204},
		{85,250,237},
		{185,253,247},
		{224,252,250}
	},
	{
		{1,32,110},
		{5,58,194},
		{130,163,249},
		{176,197,252},
		{213,224,252},
		{237,241,251}
	},
	{
		{9,1,1},
		{53,6,6},
		{100,16,121},
		{246,41,239},
		{252,163,249},
		{251,220,250}
	},
	{
		{0,0,0},
		{50,50,50},
		{97,95,95},
		{148,147,147},
		{209,208,208},
		{255,255,255}
	},
	{
		{255,0,0},
		{255,0,0},
		{255,0,0},
		{255,0,0},
		{255,0,0},
		{255,0,0}
	}
};

@implementation ColorPickerLayer

@synthesize drawView;

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		isPhone = NO;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
			isPhone = YES;
		}
		
		pallet = [CCSprite spriteWithFile:SHImageString(@"1_0_0", @"png")];
		pallet.anchorPoint = ccp(0,0);
		[self addChild:pallet];
		
		single = [CCSprite spriteWithFile:SHImageString(@"single", @"png")];
		single.anchorPoint = ccp(0, 0);
		single.position = ccp(-1000, -1000);
		[self addChild:single];
		
		pattern = [CCSprite spriteWithFile:SHImageString(@"pattern", @"png")];
		pattern.anchorPoint = ccp(0, 0);
		pattern.position = ccp(-1000, -1000);
		[self addChild:pattern];

		item1 = [CCMenuItemImage itemFromNormalImage:SHImageString(@"1_ba", @"png") selectedImage:SHImageString(@"1_ba_a",@"png") target:self selector:@selector(smallPatten)];
		item2 = [CCMenuItemImage itemFromNormalImage:SHImageString(@"2_ba",@"png") selectedImage:SHImageString(@"2_ba_a",@"png") target:self selector:@selector(mediumPatten)];
		item3 = [CCMenuItemImage itemFromNormalImage:SHImageString(@"3_ba",@"png") selectedImage:SHImageString(@"3_ba_a",@"png") target:self selector:@selector(largePatten)];
		
		CCMenu *menu = [CCMenu menuWithItems:item1, item2, item3, nil];
		
		menu.position = CGPointZero;
		item1.position = isPhone?ccp(55, 155):ccp(132, 370);
		item2.position = isPhone?ccp(55,117):ccp(132, 280);
		item3.position = isPhone?ccp(55,80):ccp(132, 190);
		[self addChild: menu z:100];
	}
	
	titleW = isPhone?TITLEW:PAD_TITLEW;
	titleH = isPhone?TITLEH:PAD_TITLEH;
	maxX = MAX_X;
	maxY = MAX_Y;
	x = isPhone?X:PAD_X;
	y = isPhone?Y:PAD_Y;
	return self;
}

-(void)unselect
{
	[item1 unselected];
	[item2 unselected];
	[item3 unselected];
}

-(void)smallPatten
{
	[self unselect];
	[item1 selected];
	[drawView setPattern:0];
}

-(void)mediumPatten
{
	[self unselect];
	[item2 selected];
	[drawView setPattern:1];
}

-(void)largePatten
{
	[self unselect];
	[item3 selected];
	[drawView setPattern:2];
}

-(void)setDrawPosition:(CGPoint)pos
{
	curPosition = pos;
	curPosition.y -= 10;
	if (curPosition.x < x || (curPosition.y) < y) {
		return;
	}
	
	int nx = (curPosition.x - x) / titleW;
	int ny = (curPosition.y - y) / titleH;
	
	if (nx > maxX || ny > maxY) {
		return;
	}
	
	curPosition.y += 10;
	if (nx == maxX) {
		single.position = ccp(-1000,-1000);
		if (ny / 3 == 0)
		{
			[drawView setBrushType:2];
			ny = 0;
		}
		else
		{
			[drawView setBrushType:3];
			ny = 3;
		}
		
		curPosition = ccpAdd(ccp(x, y), ccp(nx*titleW-(isPhone?0:2), ny*titleH-(isPhone?0:6)));
		pattern.position = curPosition;
		return;
	}
	
	pattern.position = ccp(-1000,-1000);
	[drawView setBrushColor:color[nx][ny].r g:color[nx][ny].g b:color[nx][ny].b];
	curPosition = ccpAdd(ccp(x, y), ccp(nx*titleW-(isPhone?-1:2), ny*titleH-(isPhone?-1:6)));
	single.position = curPosition;
}

-(void)setFirstColor
{
	[drawView setBrushColor:color[0][maxY].r g:color[0][maxY].g b:color[0][maxY].b];
	curPosition = ccpAdd(ccp(x, y), ccp(0*titleW-(isPhone?-1:2), maxY*titleH-(isPhone?-1:6)));
	single.position = curPosition;
	
	[self smallPatten];
}

@end
