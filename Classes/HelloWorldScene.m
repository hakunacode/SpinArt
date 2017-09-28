//
//  HelloWorldLayer.m
//  SpinArt
//
//  Created by Rim Rami on 10/13/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "ColorPickerLayer.h"
#import "RootViewController.h"

#define MAX_V 18.0f
#define MIN_V -18.0f
#define kBrushPixelStep		3

static int sr = 0;
static int sg = 0;
static int sb = 0;

// HelloWorld implementation
@implementation HelloWorld

@synthesize target;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		appDelegate = [[UIApplication sharedApplication] delegate];
		
		// ask director the the window size
		sizeView = [[CCDirector sharedDirector] winSize];

		// create a render texture, this is what we're going to draw into
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
			width = 300;
			height = 300;
			brushScale = 1;
		}else {
			width = 600;
			height = 600;
			brushScale = 2;
		}


		target = [[CCRenderTexture renderTextureWithWidth:width height:height] retain];
		[target setPosition:ccp(sizeView.width/2, sizeView.height*3/5)];
		ratioX = width/2;
		ratioY = height/2;
		[self addChild:target z:-1];
		angle = target.rotation;		
	
		targetOuter = [[CCRenderTexture renderTextureWithWidth:sizeView.width height:sizeView.height] retain];
		[targetOuter setPosition:ccp(sizeView.width/2, sizeView.height/2)];
		
		targetBottom = [[CCRenderTexture renderTextureWithWidth:sizeView.width height:sizeView.height] retain];
		targetBottom.position = ccpSub(targetBottom.position, ccp(1,1));
		[targetBottom setPosition:ccp(sizeView.width/2, sizeView.height/2)];
		[self addChild:targetBottom z:-3];
		
		//create brush
		brush = [[CCSprite spriteWithFile:@"fire.png"] retain];
		
		//clear image
		clearImage = [[CCSprite spriteWithFile:SHImageString(@"ractangl",@"png")] retain];
		clearImage.anchorPoint = ccp(0,0);
		CGSize imageSize = clearImage.contentSize;
		clearImage.scale = width / imageSize.width;
		
		clearBackgrond = [[CCSprite spriteWithFile:SHImageString(@"ractangl",@"png")] retain];
		[clearBackgrond setPosition:ccp(sizeView.width/2, sizeView.height*3/5)];
		clearBackgrond.scale = width / imageSize.width;
		
		opecity = [[CCSprite spriteWithFile:@"opecity.png"] retain];
		opecity.position = ccp(sizeView.width/2, sizeView.height/2);
		if (brushScale == 1)
			opecity.scale = 0.5f;
		
		shadow = [[CCSprite spriteWithFile:@"00000.png"] retain];
		shadow.position = clearBackgrond.position;
		if (brushScale == 2) {
			shadow.scale = 2.0f;
		}
		[self addChild:shadow z:-2];
		
		[target begin];
		[clearImage visit];
		[target end];
		
		//background
		CCSprite* background = [CCSprite spriteWithFile:SHImageString(@"drawBG", @"png")];
		background.position = ccp(sizeView.width/2, sizeView.height/2);
		[self addChild:background z:-10];

		selectItem = [CCMenuItemImage itemFromNormalImage:SHImageString(@"ba_1_0_a", @"png") selectedImage:SHImageString(@"ba_1_0", @"png") target:self selector:@selector(onActionMenu)];
		rotateItem = [CCMenuItemImage itemFromNormalImage:SHImageString(@"ba_2_0_a", @"png") selectedImage:SHImageString(@"ba_2_0", @"png") target:self selector:@selector(onRotateState)];
		brushItem = [CCMenuItemImage itemFromNormalImage:SHImageString(@"ba_33_00_a", @"png") selectedImage:SHImageString(@"ba_33_00", @"png") target:self selector:@selector(onBrushState)];
		colorItem = [CCMenuItemImage itemFromNormalImage:SHImageString(@"ba_4_00_a", @"png") selectedImage:SHImageString(@"ba_4_00", @"png") target:self selector:@selector(onColorPicker)];
		undoItem =	[CCMenuItemImage itemFromNormalImage:SHImageString(@"ba_5_00_a", @"png") selectedImage:SHImageString(@"ba_5_00", @"png") target:self selector:@selector(onUndo)];
		
		CCMenu* mainMenu = [CCMenu menuWithItems:selectItem, rotateItem, brushItem, colorItem, undoItem, nil];
		
		selectItem.anchorPoint = ccp(0,0);
		rotateItem.anchorPoint = ccp(0,0);
		brushItem.anchorPoint = ccp(0,0);
		colorItem.anchorPoint = ccp(0,0);
		undoItem.anchorPoint = ccp(0,0);
		
		mainMenu.position = CGPointZero;
		selectItem.position = brushScale==1?ccp(4,5):ccp(14,15);
		rotateItem.position = brushScale==1?ccp(67,5):ccp(164,15);
		brushItem.position = brushScale==1?ccp(130,5):ccp(314,15);
		colorItem.position = brushScale==1?ccp(193,5):ccp(464,15);
		undoItem.position = brushScale==1?ccp(256,5):ccp(614,15);

		[self addChild: mainMenu z:100];	
		
		colorLayer =  [CCNode node];
		[colorLayer setContentSize:CGSizeMake(brushScale==1?WIDTH:PAD_WIDTH, brushScale==1?HEIGHT:PAD_HEIGHT)];
		[colorLayer setPosition:ccp(0,brushScale==1?-HEIGHT:-PAD_HEIGHT)];
		ColorPickerLayer* layer = [ColorPickerLayer node];
		layer.position = ccp(0,10);
		layer.drawView = self;
		[layer setFirstColor];
		[colorLayer addChild:layer z:1 tag:COLORLAYER];
		[self addChild:colorLayer z:10];
		
		CCSprite* menuBar = [CCSprite spriteWithFile:SHImageString(@"gr", @"png")];
		menuBar.anchorPoint = ccp(0,0);
		[self addChild:menuBar z:10];
		
		history = [[stack alloc] init];
		velocity = 0.0f;
		state = BRUSH;
		statetemp = BRUSH;
		[brushItem selected];
		
		rBGColor = gBGColor = bBGColor = -1;
		brushType = 1;
		
		sr = [self getRandUint:0 Max:256];
		sg = [self getRandUint:0 Max:256];
		sb = [self getRandUint:0 Max:256];
		
		targetPicker = [[CCRenderTexture renderTextureWithWidth:brushScale==1?24:54 height:brushScale==1?29:66] retain];
		targetPicker.anchorPoint = ccp(0,0);
		[targetPicker setPosition:brushScale==1?ccp(223,30):ccp(534,73)];
		[self addChild:targetPicker z:100];		
		[self drawPickerColor];
		
		NSData *imageData = [target getUIImageAsDataFromBuffer:kCCImageFormatPNG];
		selectedImage = [[[UIImage alloc] initWithData:imageData] retain];
		[history push:selectedImage];
	}
	
	self.isTouchEnabled = YES;
	srand( ( unsigned )time( NULL ) );
	[self schedule:@selector(doStep:) interval:1.0f/60.0f];
	
	return self;
}

-(void)createClearImage:(UIImage*)image
{
	[self clearHistory];
	
	CCTexture2D* _text = [[CCTexture2D alloc] initWithImage: image];
	
	[clearImage release];
	clearImage = [[CCSprite spriteWithTexture:_text] retain];
	clearImage.anchorPoint = ccp(0,0);
	CGSize imageSize = clearImage.contentSize;
	clearImage.scale = width / imageSize.width;

	
	[clearBackgrond release];
	clearBackgrond = [[CCSprite spriteWithTexture:_text] retain];
	[clearBackgrond setPosition:ccp(sizeView.width/2, sizeView.height*3/5)];
	clearBackgrond.rotation = target.rotation;
	imageSize = clearBackgrond.contentSize;
	clearBackgrond.scale = width / imageSize.width;
	
	[target begin];
	[clearImage visit];
	[clearImage setBlendFunc:(ccBlendFunc){GL_ZERO, GL_SRC_ALPHA}];
	[clearImage visit];
	[target end];

	[selectedImage release];
	NSData *imageData = [target getUIImageAsDataFromBuffer:kCCImageFormatPNG];
	selectedImage = [[[UIImage alloc] initWithData:imageData] retain];
	[history push:selectedImage];
	
	rBGColor = gBGColor = bBGColor = -1;
}

-(void)createShadow:(UIImage*)image
{
	[shadow removeFromParentAndCleanup:YES];
	[shadow release];
	
	CCTexture2D* _text = [[CCTexture2D alloc] initWithImage: image];
	shadow = [[CCSprite spriteWithTexture:_text] retain];
	shadow.rotation = target.rotation;
	shadow.position = clearBackgrond.position;
	if (brushScale == 2) {
		shadow.scale = 2.0f;
	}
	
	[self addChild:shadow z:-2];
}

-(void) clearImage
{
	if (rBGColor != -1) {
		[target clear:rBGColor g:gBGColor b:bBGColor a:1.0f];
		[target begin];
		[clearImage setBlendFunc:(ccBlendFunc){GL_ZERO, GL_SRC_ALPHA}];
		[clearImage visit];
		[target end];		
	}else {
		[target begin];
		[clearImage setBlendFunc:(ccBlendFunc){GL_ZERO, GL_ZERO}];
		[clearImage visit];
		[clearImage setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE_MINUS_DST_ALPHA}];
		[clearImage visit];
		[target end];
		
	}
}

-(void) clearBackground
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	
	[targetOuter release];
	targetOuter = [[CCRenderTexture renderTextureWithWidth:size.width height:size.height] retain];
	[targetOuter setPosition:ccp(size.width/2, size.height/2)];
	
	[targetBottom removeFromParentAndCleanup:YES];
	[targetBottom release];
	
	targetBottom = [[CCRenderTexture renderTextureWithWidth:size.width height:size.height] retain];
	targetBottom.position = ccpSub(targetBottom.position, ccp(1,1));
	[targetBottom setPosition:ccp(size.width/2, size.height/2)];
	[self addChild:targetBottom z:-3];
}

-(void) clearHistory
{
	[history empty];
}

-(void) saveImage
{
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
	static int counter=0;
	
	NSString *str = [NSString stringWithFormat:@"image-%d.png", counter];
	[target saveBuffer:str format:kCCImageFormatPNG];
	NSLog(@"Image saved: %@", str);
	
	counter++;
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
	NSLog(@"CCRenderTexture Save is not supported yet");
#endif // __MAC_OS_X_VERSION_MAX_ALLOWED
}

-(void) saveImage:(NSString*)path
{
	NSData* writeData;
	if (path) {
		writeData = [target getUIImageAsDataFromBuffer:kCCImageFormatPNG];
		[writeData writeToFile:path atomically:YES];
	}
	else {
		UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:writeData], self, nil, nil);
	}	
}

-(NSData*) getImageData
{
	return [target getUIImageAsDataFromBuffer:kCCImageFormatPNG];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	firstTouch = YES;
	moveTouch = NO;
	
	location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	previousLocation = location;
	curNodePos = [target convertToNodeSpace:location];
	curNodePos.x += ratioX;
	curNodePos.y += ratioY;

	if (state == COLOR) 
	{
		if (location.y > (brushScale==1?HEIGHT:PAD_HEIGHT)) 
		{
			id move = [CCMoveBy actionWithDuration:0.2f position:ccp(0,brushScale==1?-HEIGHT:-PAD_HEIGHT)];
			[colorLayer runAction:[CCSequence actions:
								   move,
								   [CCCallFunc actionWithTarget:self selector:@selector(callback)],
								   nil]];
		}
		else
		{
			ColorPickerLayer* layer = (ColorPickerLayer*)[colorLayer getChildByTag:COLORLAYER];
			[layer setDrawPosition:location];
		}

	}
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	moveTouch = YES;
	location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	previousLocation = [touch previousLocationInView: [touch view]];
	previousLocation = [[CCDirector sharedDirector] convertToGL: previousLocation];

	
	if (state == BRUSH) {
//		[self renderDraw:location toPoint:previousLocation];
	} 
	else if (state == ROTATE)
	{
		CGPoint prev = [touch previousLocationInView:[touch view]];
		prev = [[CCDirector sharedDirector] convertToGL: prev];

		CGPoint pos1 = [target convertToNodeSpace:location];
		CGPoint pos2 = [target convertToNodeSpace:prev];

		double ang = atan(pos2.y/pos2.x) - atan(pos1.y/pos1.x);
		
		vel = ang * (180/M_PI);
		
		if (vel > MAX_V) {
			vel = MAX_V;
		}else if (vel < MIN_V) {
			vel = MIN_V;
		}
		
		if (velocity != 0) {
			if (velocity > 0) {
				if (vel > 0) {
					velocity = vel;
				}else {
					velocity += vel;
				}
			}else {
				if (vel < 0) {
					velocity = vel;
				}else {
					velocity += vel;
				}
			}
		}
		
		target.rotation += vel;
		clearBackgrond.rotation += vel;
		shadow.rotation += vel;
	}

}

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (state == BRUSH) {
		if (added) {
			NSData *imageData = [target getUIImageAsDataFromBuffer:kCCImageFormatPNG];
			UIImage* image = [[UIImage alloc] initWithData:imageData];

			[history push:image];
			//[image release];
			added = NO;
		}
	}else if (state == ROTATE) {
		velocity = vel;
	}
	
	firstTouch = NO;
	moveTouch = YES;
}

-(void)renderDraw:(CGPoint)start toPoint:(CGPoint)end
{
	[target begin];
	CGPoint pos1 = [target convertToNodeSpace:start];
	pos1.x += ratioX;
	pos1.y += ratioY;
	CGPoint pos2 = [target convertToNodeSpace:end];
	pos2.x += ratioX;
	pos2.y += ratioY;
	
	[self renderLineFromPoint:pos2 toPoint:pos1 add:YES];
	[clearImage setBlendFunc:(ccBlendFunc){GL_ZERO, GL_SRC_ALPHA}];
	[clearImage visit];
	[target end];	
	
	[targetOuter begin];
	[self renderLineFromPoint:end toPoint:start add:NO];
	[clearBackgrond setBlendFunc:(ccBlendFunc){GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
	[clearBackgrond visit];		
	[targetOuter end];
}

-(void) renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end add:(Boolean)add
{
	if (add) {
		added = YES;
	}
	int count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
	for (int i = 0; i < count; i++)
	{
		CGPoint pos;
		pos.x = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count);
		pos.y = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count);
		[self brush_Patten:pos add:add];
	}	
}

-(void)pattenDraw:(CGPoint)pos repeat:(int)repeat len1:(int)len1 len2:(int)len2 size1:(int)size1 size2:(int)size2 add:(bool)add
{
	for (int i = 0; i < repeat; i++) {
		double nLen = [self getRandUint:len1 Max:len2];
		double rotate = [self getRandUint:0 Max:360] * (M_PI/180.0);
		int nx = cos(rotate) * nLen;
		int ny = sin(rotate) * nLen;
		brushSize = (double)[self getRandUint:size1 Max:size2] / 200;
		
		BrushInfo* _info;
		_info = [[BrushInfo alloc] init];
		
		rotate = angle * (3.141592/180.0);
		
		int x = pos.x + nx;
		int y = pos.y + ny;
		
		if (brushType == 2) {
			rColor = [self getRandUint:0 Max:256];
			gColor = [self getRandUint:0 Max:256];
			bColor = [self getRandUint:0 Max:256];
		}else if (brushType == 3) {				
			rColor = sr;
			gColor = sg;
			bColor = sb;
			
			sr++;
			sg++;
			sb++;
			
			if (sr > 255) {
				sr = [self getRandUint:0 Max:256];
			}
			if (sg > 255) {
				sg = [self getRandUint:0 Max:256];
			}
			if (sb > 255) {
				sb = [self getRandUint:0 Max:256];
			}
		}
		brushSize = brushSize * brushScale;
		
		[brush setPosition:ccp(x, y)];
		[brush setScale:brushSize];
		[brush setColor:ccc3(rColor, gColor, bColor)];
		
		[brush setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE_MINUS_SRC_ALPHA}];
		[brush visit];

		[_info release];
	}
}

-(void)brush_Patten:(CGPoint)pos add:(bool)add
{
	switch (pattern) {
		case SMALL:
			[self pattenDraw:pos repeat:2 len1:1 len2:4 size1:30 size2:40 add:add];
			[self pattenDraw:pos repeat:2 len1:5 len2:25 size1:15 size2:25 add:add];
			break;
		case MEDIUM:
			[self pattenDraw:pos repeat:2 len1:1 len2:6 size1:35 size2:45 add:add];
			[self pattenDraw:pos repeat:2 len1:7 len2:28 size1:20 size2:30 add:add];
			break;
		case LARGE:
			[self pattenDraw:pos repeat:2 len1:1 len2:8 size1:40 size2:50 add:add];
			[self pattenDraw:pos repeat:2 len1:8 len2:31 size1:25 size2:35 add:add];
			break;
	}
}

-(void) onColorPicker
{
	[self unselected];
	[colorItem selected];
	
	if (state == COLOR) {
		return;
	}
	
	statetemp = state;
	id move = [CCMoveBy actionWithDuration:0.2f position:ccp(0,brushScale==1?HEIGHT:PAD_HEIGHT)];
	[colorLayer runAction:[CCSequence actions:
						   move,
						   [CCCallFunc actionWithTarget:self selector:@selector(callColor)],
						   nil]];
}

-(void)callback
{
	state = statetemp;
	
	[self unselected];
	if (state == BRUSH) {
		[brushItem selected];
	}else if (state == ROTATE) {
		[rotateItem selected];
	}
}

-(void)callColor
{
	state = COLOR;
}

-(void)onBrushState
{	
	[self unselected];
	[brushItem selected];
	statetemp = BRUSH;
	
	if (state == COLOR) {
		id move = [CCMoveBy actionWithDuration:0.2f position:ccp(0,brushScale==1?-HEIGHT:-PAD_HEIGHT)];
		[colorLayer runAction:[CCSequence actions:
							   move,
							   [CCCallFunc actionWithTarget:self selector:@selector(callback)],
							   nil]];
	}else {
		state = BRUSH;
	}
}

-(void)onRotateState
{
	if (state == COLOR)
		return;

	[self unselected];
	[rotateItem selected];
	
	state = ROTATE;
	angle = target.rotation;
	velocity = 0.0f;
}

-(void) setBrushColor:(float)r g:(float)g b:(float)b
{
	rColor = r;
	gColor = g;
	bColor = b;
	brushType = 1;
	[self drawPickerColor];
}

-(void) setBGColor:(float)r g:(float)g b:(float)b
{
	rBGColor = r/255.0f;
	gBGColor = g/255.0f;
	bBGColor = b/255.0f;
	
	[target clear:rBGColor g:gBGColor b:bBGColor a:1.0f];
	[target begin];
	[clearImage setBlendFunc:(ccBlendFunc){GL_ZERO, GL_SRC_ALPHA}];
	[clearImage visit];
	[target end];
	
	[targetOuter begin];
	[clearBackgrond setBlendFunc:(ccBlendFunc){GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
	[clearBackgrond visit];		
	[targetOuter end];
	
	[targetBottom begin];
	[targetOuter visit];
	[targetBottom end];
	
	[self clearHistory];
	NSData *imageData = [target getUIImageAsDataFromBuffer:kCCImageFormatPNG];
	UIImage* image = [[UIImage alloc] initWithData:imageData];
	[history push:image];
}

-(void) setBGCurrentColor
{
	rBGColor = rColor/255.0f;
	gBGColor = gColor/255.0f;
	bBGColor = bColor/255.0f;
	
	[target clear:rBGColor g:gBGColor b:bBGColor a:1.0f];
	[target begin];
	[clearImage setBlendFunc:(ccBlendFunc){GL_ZERO, GL_SRC_ALPHA}];
	[clearImage visit];
	[target end];
	
	[targetOuter begin];
	[clearBackgrond setBlendFunc:(ccBlendFunc){GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
	[clearBackgrond visit];		
	[targetOuter end];
	
	[targetBottom begin];
	[targetOuter visit];
	[targetBottom end];	

	[self clearHistory];
	NSData *imageData = [target getUIImageAsDataFromBuffer:kCCImageFormatPNG];
	UIImage* image = [[UIImage alloc] initWithData:imageData];
	[history push:image];
}

-(void) onUndo
{
	if (state == COLOR)
		return;

	int nCount = [history getCount];
	if (nCount == 0) {
		return;
	}
	
	[history pop];
	
	[self clearImage];
	
	[target begin];
	nCount = [history getCount];
	UIImage* image = [history getData:nCount];
	CCSprite* sprite = [[CCSprite alloc] initWithCGImage:image.CGImage];
	sprite.anchorPoint = ccp(0,0);
	[sprite visit];
	[target end];
}

- (void)doStep:(ccTime)delta
{
	target.rotation += velocity;
	clearBackgrond.rotation += velocity;
	shadow.rotation += velocity;

	if (state == BRUSH) {
		if (firstTouch) {
			if (moveTouch)
			{
				[target begin];
				CGPoint pos1 = [target convertToNodeSpace:location];
				pos1.x += ratioX;
				pos1.y += ratioY;
				[self renderLineFromPoint:curNodePos toPoint:pos1 add:YES];
				[clearImage setBlendFunc:(ccBlendFunc){GL_ZERO, GL_SRC_ALPHA}];
				[clearImage visit];
				[target end];
				curNodePos = pos1;
				
				[targetOuter begin];
				[self renderLineFromPoint:previousLocation toPoint:location add:NO];
				[clearBackgrond setBlendFunc:(ccBlendFunc){GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
				[clearBackgrond visit];		
				[targetOuter end];				
			}
			else
			{
				[target begin];
				CGPoint pos = [target convertToNodeSpace:location];
				pos.x += ratioX;
				pos.y += ratioY;
				[self renderLineFromPoint:curNodePos toPoint:pos add:YES];
				[clearImage setBlendFunc:(ccBlendFunc){GL_ZERO, GL_SRC_ALPHA}];
				[clearImage visit];
				[target end];
				curNodePos = pos;				
			}
			
			[targetBottom begin];
			[targetOuter visit];
			[targetBottom end];						
		}
	} else {
	}
}

-(void)draw
{
}

-(void) setPattern:(uint)kind
{
	switch (kind) {
		case 0:
			pattern = SMALL;
			break;
		case 1:
			pattern = MEDIUM;
			break;
		case 2:
			pattern = LARGE;
			break;
	}
}

-(int) getRandInt:(int)min Max:(int)max
{
	int nCount = abs(rand() % (max-min)) + min;
	
	if (rand() % 2 == 0) {
		nCount *= -1;
	}
//	return abs(rand() % (max-min)) + min;
	return nCount;
}

-(int) getRandUint:(int)min Max:(int)max{
	return abs(rand() % (max-min)) + min;
}


- (void) ShowMainMenu
{
	[appDelegate.viewController ShowMainMenu:selectedImage];
}

-(void) onActionMenu
{
	if (state == COLOR)
		return;
	
	statetemp = state;
	state = MENU;
	
	[self setMainMenuEnable:NO];
	
	[self addChild:opecity z:100];
	
	CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:SHImageString(@"new_a", @"png") selectedImage:SHImageString(@"new", @"png") target:self selector:@selector(onNew)];
	CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:SHImageString(@"share_a", @"png") selectedImage:SHImageString(@"share", @"png") target:self selector:@selector(onShare)];
	CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:SHImageString(@"help_a", @"png") selectedImage:SHImageString(@"help", @"png") target:self selector:@selector(onHelp)];
	CCMenuItemImage *item4 = [CCMenuItemImage itemFromNormalImage:SHImageString(@"about_a", @"png") selectedImage:SHImageString(@"about", @"png") target:self selector:@selector(onAbout)];
	
	actionMenu = [CCMenu menuWithItems:item1, item2, item3, item4, nil];
	actionMenu.position = CGPointZero;
	
	item1.anchorPoint = ccp(1,0);
	item1.position = brushScale==1?ccp(0,480):ccp(0,1024);
	id move1 = [CCMoveBy actionWithDuration:0.15f position:brushScale==1?ccp(160,-240):ccp(384,-512)];
	[item1 runAction:move1];
	
	item2.anchorPoint = ccp(0,0);
	item2.position = brushScale==1?ccp(320,480):ccp(768,1024);
	id move2 = [CCMoveBy actionWithDuration:0.15f position:brushScale==1?ccp(-160,-240):ccp(-384,-512)];
	[item2 runAction:move2];
	
	item3.anchorPoint = ccp(1,1);
	item3.position = ccp(0,0);
	id move3 = [CCMoveBy actionWithDuration:0.15f position:brushScale==1?ccp(160,240):ccp(384,512)];
	[item3 runAction:move3];
	
	item4.anchorPoint = ccp(0,1);
	item4.position = brushScale==1?ccp(320,0):ccp(768,0);
	id move4 = [CCMoveBy actionWithDuration:0.15f position:brushScale==1?ccp(-160,240):ccp(-384,512)];
	[item4 runAction:move4];
	
	[self addChild: actionMenu z:102];
}

-(void)onNew
{
	state = statetemp;
	[self setMainMenuEnable:YES];
	[self selected:state];
	
	[actionMenu removeFromParentAndCleanup:YES];
	[self ShowMainMenu];
}

-(void)onShare
{
	state = statetemp;
	[self setMainMenuEnable:YES];
	[actionMenu removeFromParentAndCleanup:YES];
	[self selected:state];
	
	NSData *imageData = [target getUIImageAsDataFromBuffer:kCCImageFormatPNG];
	UIImage* image = [[UIImage alloc] initWithData:imageData];
	[appDelegate.viewController ShowShareView:image];
	NSLog(@"%d", [image retainCount]);
	[image release];
}

-(void)onHelp
{
	state = statetemp;
	[self setMainMenuEnable:YES];
	[self selected:state];
	
	[actionMenu removeFromParentAndCleanup:YES];
	[appDelegate.viewController ShowHelpView];
}

-(void)onAbout
{
	state = statetemp;
	[self setMainMenuEnable:YES];
	[self selected:state];
	
	[actionMenu removeFromParentAndCleanup:YES];
	[appDelegate.viewController ShowAboutView];
}

-(void)setMainMenuEnable:(bool)enable
{
	selectItem.isEnabled = enable;
	rotateItem.isEnabled = enable;
	brushItem.isEnabled = enable;
	colorItem.isEnabled = enable;
	undoItem.isEnabled = enable;	
	
	[opecity removeFromParentAndCleanup:YES];
}

-(void)sendMail
{
	[appDelegate.viewController sendMail];
}

-(void)unselected
{
	[selectItem unselected];
	[rotateItem unselected];
	[brushItem unselected];
	[colorItem unselected];
	[undoItem unselected];
}

-(void)selected:(int)kind
{
	if (kind == BRUSH) {
		[brushItem selected];
	}else if (kind == ROTATE) {
		[rotateItem selected];
	}
}

-(void)setBrushType:(int)type
{
	brushType = type;
	
	[self drawPickerColor];
}

-(void)drawPickerColor
{
	[targetPicker begin];
	if (brushType == 1) {
		CCSprite* type = [CCSprite spriteWithFile:SHImageString(@"pickerColor", @"png")];
		[type setColor:ccc3(rColor, gColor, bColor)];
		type.anchorPoint = ccp(0,0);
		[type visit];		
	}else if (brushType == 2) {
		CCSprite* type = [CCSprite spriteWithFile:SHImageString(@"pattern1", @"png")];
		type.anchorPoint = ccp(0,0);
		[type visit];
	}else if (brushType == 3) {
		CCSprite* type = [CCSprite spriteWithFile:@"pattern2.png"];
		type.anchorPoint = ccp(0,0);
		[type visit];
	}
	[targetPicker end];
}

- (void) dealloc
{
	[super dealloc];
}
@end
