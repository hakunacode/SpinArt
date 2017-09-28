//
//  RendTexture.h
//  SpinArt
//
//  Created by Rim Rami on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RendTexture : CCRenderTexture {
	float r, g, b, a;
}
+(id)renderTextureWithWidth:(NSString*)filename;
//+(id)renderTextureMask:(NSString*)filename;
-(id)initWithWidth:(CCTexture2DPixelFormat) format filename:(NSString*)filename;
//-(id)initMask:(CCTexture2DPixelFormat) format filename:(NSString*)filename;
-(void) saveGLstate;
-(void) initImage:(CCTexture2DPixelFormat) format filename:(NSString*)filename;
-(void) setBackGrounColor:(float)rColor gColor:(float)gColor bColor:(float)bColor alpha:(float)alpha;
@end
