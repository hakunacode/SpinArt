//
//  ColorPickerLayer.h
//  SpinArt
//
//  Created by Rim Rami on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HelloWorldScene.h"
#import "GameConfig.h"

@interface ColorPickerLayer : CCLayer {
	HelloWorld* drawView;
	
	CCSprite* pallet;
	CCSprite* single;
	CCSprite* pattern;
	
	CCMenuItemImage *item1, *item2, *item3;
	
	CGPoint curPosition;
	int titleW, titleH;
	int maxX, maxY;
	int x, y;
	bool isPhone;
}

@property (nonatomic, retain) HelloWorld*	drawView;

-(void)smallPatten;
-(void)mediumPatten;
-(void)largePatten;
-(void)setDrawPosition:(CGPoint)pos;
-(void)setFirstColor;
-(void)unselect;
@end
