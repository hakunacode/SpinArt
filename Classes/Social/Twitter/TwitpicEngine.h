
#import <UIKit/UIKit.h>
#import "OFXMLMapper.h"

@protocol TwitpicEngineDelegate;

@interface TwitpicEngine : NSObject 
{
	@private
	id<TwitpicEngineDelegate> delegate;
}

- (id)initWithDelegate:(id)theDelegate;
- (BOOL)uploadImageToTwitpic:(NSData *)image withMessage:(NSString *)theMessage username:(NSString *)username password:(NSString *)password;

@end


@protocol TwitpicEngineDelegate <NSObject>
- (void)twitpicEngine:(TwitpicEngine *)engine didUploadImageWithResponse:(NSString *)response;
@end

