//
//  RendTexture.m
//  SpinArt
//
//  Created by Rim Rami on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RendTexture.h"


@implementation RendTexture

+(id)renderTextureWithWidth:(NSString*)filename
{
	return [[[self alloc] initWithWidth:kCCTexture2DPixelFormat_RGBA8888 filename:filename] autorelease];	
}
/*
+(id)renderTextureMask:(NSString*)filename
{
	return [[[self alloc] initMask:kCCTexture2DPixelFormat_RGBA8888 filename:filename] autorelease];	
}

-(id)initMask:(CCTexture2DPixelFormat) format filename:(NSString*)filename
{
	
}
*/
-(id)initWithWidth:(CCTexture2DPixelFormat) format filename:(NSString*)filename
{
	if ((self = [super init]))
	{
		[self initImage:format filename:filename];
	}
	return self;
}

-(void) initImage:(CCTexture2DPixelFormat) format filename:(NSString*)filename
{
	NSAssert(format != kCCTexture2DPixelFormat_A8,@"only RGB and RGBA formats are valid for a render texture");
	NSAssert(filename!=nil, @"Invalid filename for sprite");
	
	//		w *= CC_CONTENT_SCALE_FACTOR();
	//		h *= CC_CONTENT_SCALE_FACTOR();
	
	glGetIntegerv(CC_GL_FRAMEBUFFER_BINDING, &oldFBO_);
	
	// textures must be power of two
	//		NSUInteger powW = ccNextPOT(w);
	//		NSUInteger powH = ccNextPOT(h);
	
	//		void *data = malloc((int)(powW * powH * 4));
	//		memset(data, 0, (int)(powW * powH * 4));
	pixelFormat_=format; 
	
	//texture_ = [[CCTexture2D alloc] initWithData:data pixelFormat:pixelFormat_ pixelsWide:powW pixelsHigh:powH contentSize:CGSizeMake(w, h)];
	texture_ = [[CCTextureCache sharedTextureCache] addImage: filename];
	//		free( data );
	
	// generate FBO
	ccglGenFramebuffers(1, &fbo_);
	ccglBindFramebuffer(CC_GL_FRAMEBUFFER, fbo_);
	
	// associate texture with FBO
	ccglFramebufferTexture2D(CC_GL_FRAMEBUFFER, CC_GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture_.name, 0);
	
	// check if it worked (probably worth doing :) )
	GLuint status = ccglCheckFramebufferStatus(CC_GL_FRAMEBUFFER);
	if (status != CC_GL_FRAMEBUFFER_COMPLETE)
	{
		[NSException raise:@"Render Texture" format:@"Could not attach texture to framebuffer"];
	}
	[texture_ setAliasTexParameters];
	
	sprite_ = [CCSprite spriteWithTexture:texture_];
	
	[texture_ release];
	[sprite_ setScaleY:-1];
	[self addChild:sprite_];
	
	// issue #937
	[sprite_ setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE_MINUS_SRC_ALPHA}];
	
	ccglBindFramebuffer(CC_GL_FRAMEBUFFER, oldFBO_);	
}

-(void) setBackGrounColor:(float)rColor gColor:(float)gColor bColor:(float)bColor alpha:(float)alpha
{
	r = rColor; b = bColor; g = gColor; a = alpha;
}

-(void)begin
{
	// issue #878 save opengl state
	[self saveGLstate];
	
	CC_DISABLE_DEFAULT_GL_STATES();
	// Save the current matrix
	glPushMatrix();
	
	CGSize texSize = [texture_ contentSizeInPixels];
	
	// Calculate the adjustment ratios based on the old and new projections
	CGSize size = [[CCDirector sharedDirector] displaySizeInPixels];
	float widthRatio = size.width / texSize.width;
	float heightRatio = size.height / texSize.height;
	
	// Adjust the orthographic propjection and viewport
	ccglOrtho((float)-1.0 / widthRatio,  (float)1.0 / widthRatio, (float)-1.0 / heightRatio, (float)1.0 / heightRatio, -1,1);
	glViewport(0, 0, texSize.width, texSize.height);
	
	glGetIntegerv(CC_GL_FRAMEBUFFER_BINDING, &oldFBO_);
	ccglBindFramebuffer(CC_GL_FRAMEBUFFER, fbo_);//Will direct drawing to the frame buffer created above
	
	CC_ENABLE_DEFAULT_GL_STATES();	
//	[self clear:r g:g b:b a:a];
}

-(void) saveGLstate
{
	glGetFloatv(GL_COLOR_CLEAR_VALUE,clearColor_); 
}

@end
