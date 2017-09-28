#import "FBDialog.h"

@protocol FBLoginDialogDelegate;

@interface FBLoginDialog : FBDialog {
  id<FBLoginDialogDelegate> _loginDelegate;
}

-(id) initWithURL:(NSString *) loginURL
      loginParams:(NSMutableDictionary *) params
      delegate:(id <FBLoginDialogDelegate>) delegate;
@end

@protocol FBLoginDialogDelegate <NSObject>
- (void)fbDialogLogin:(NSString*)token expirationDate:(NSDate*)expirationDate;
- (void)fbDialogNotLogin:(BOOL)cancelled;

@end


