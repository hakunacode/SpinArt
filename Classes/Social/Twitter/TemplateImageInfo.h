//
//  TemplateImageInfo.h
//  CoolFlyrsMain
//
//  Created by apple apple on 06/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TemplateImageInfo : NSObject {

	int Templateid;
	NSData *TemplateImage;
	
}
@property int Templateid;
@property (nonatomic,retain) NSData *TemplateImage;
-(id)initWithName:(int)Lid Name:(NSData *)N; 
@end

