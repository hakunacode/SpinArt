//
//  HelloWorldLayer.h
//  SpinArt
//
//  Created by Rim Rami on 10/13/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "stack.h"
#import "BrushInfo.h"
#import "SpinArtAppDelegate.h"
#import "GameConfig.h"

#define SMALL	1
#define MEDIUM	2
#define LARGE	3

#define ROTATE	0
#define BRUSH	1
#define COLOR	2
#define MENU	3

#define WIDTH	320
#define HEIGHT	192
#define PAD_WIDTH	768
#define PAD_HEIGHT	440

#define COLORLAYER 1

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	SpinArtAppDelegate* appDelegate;
	
	CCRenderTexture* target;
	CCRenderTexture* targetOuter;
	CCRenderTexture* targetBottom;
	CCRenderTexture* targetPicker;
	
	CCNode* colorLayer;
	
	//Main menu
	CCMenuItem	*selectItem;
	CCMenuItem	*rotateItem;
	CCMenuItem	*brushItem;
	CCMenuItem	*colorItem;
	CCMenuItem	*undoItem;
	
	//pop Menu
	CCMenu* actionMenu;
	
	CCSprite* brush;
	CCSprite* clearImage, *clearBackgrond;
	CCSprite* opecity, *shadow;
	
	stack*		history;
//	CCArray*	data;
//	BrushInfo*	info;
	Boolean		added;
	
	uint brushType;
	uint brushScale;
	uint state, statetemp;
	uint pattern;
	double brushSize;
	float rColor, bColor, gColor, alpha;
	float rBGColor, bBGColor, gBGColor;
	float ratioX, ratioY;
	float angle, velocity, vel;
	float width, height;
	
//	CGPoint curPos;
	CGPoint curNodePos;
	
	CGPoint	location;
	CGPoint	previousLocation;
	Boolean	firstTouch;	
	Boolean	moveTouch;		
	
	CGSize sizeView;
	
	UIImage* selectedImage;
}

@property (nonatomic, retain) CCRenderTexture*	target;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void)createClearImage:(UIImage*)image;
-(void)createShadow:(UIImage*)image;
-(void) clearImage;
-(void) clearBackground;
-(void) clearHistory;
-(void) saveImage;
-(void) saveImage:(NSString*)path;
-(NSData*) getImageData;
-(int) getRandInt:(int)min Max:(int)max;
-(int) getRandUint:(int)min Max:(int)max;
-(void)renderDraw:(CGPoint)start toPoint:(CGPoint)end;
-(void) renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end add:(Boolean)add;
-(void)brush_Patten:(CGPoint)pos add:(bool)add;
-(void)pattenDraw:(CGPoint)pos repeat:(int)repeat len1:(int)len1 len2:(int)len2 size1:(int)size1 size2:(int)size2 add:(bool)add;
-(void) onUndo;
- (void)doStep:(ccTime)delta;
-(void)onRotateState;
-(void)onBrushState;
-(void) onColorPicker;
-(void) ShowMainMenu;
-(void) setPattern:(uint)kind;
-(void) setBrushColor:(float)r g:(float)g b:(float)b;
-(void) setBGColor:(float)r g:(float)g b:(float)b;
-(void) setBGCurrentColor;
-(void) onActionMenu;
-(void)setMainMenuEnable:(bool)enable;
-(void)onNew;
-(void)onShare;
-(void)onHelp;
-(void)onAbout;
-(void)callback;
-(void)callColor;
-(void)sendMail;
-(void)unselected;
-(void)selected:(int)kind;
-(void)setBrushType:(int)type;
-(void)drawPickerColor;
@end
