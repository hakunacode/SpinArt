#import "FBLoginDialog.h"
#import "FBRequest.h"

@protocol FBSessionDelegate;

@interface Facebook : NSObject<FBLoginDialogDelegate>{
  NSString* _accessToken;
  NSDate* _expirationDate;
  id<FBSessionDelegate> _sessionDelegate;
  FBRequest* _request;
  FBDialog* _loginDialog;
  FBDialog* _fbDialog;
  NSString* _appId;
  NSArray* _permissions;
  BOOL _forceOldStyleAuth;
}

@property(nonatomic, copy) NSString* accessToken;

@property(nonatomic, copy) NSDate* expirationDate;

@property(nonatomic, assign) id<FBSessionDelegate> sessionDelegate;

@property(nonatomic, assign) BOOL forceOldStyleAuth;

- (void)authorize:(NSString *)application_id
      permissions:(NSArray *)permissions
         delegate:(id<FBSessionDelegate>)delegate;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)logout:(id<FBSessionDelegate>)delegate;

- (void)requestWithParams:(NSMutableDictionary *)params
              andDelegate:(id <FBRequestDelegate>)delegate;

- (void)requestWithMethodName:(NSString *)methodName
                    andParams:(NSMutableDictionary *)params
                andHttpMethod:(NSString *)httpMethod
                  andDelegate:(id <FBRequestDelegate>)delegate;

- (void)requestWithGraphPath:(NSString *)graphPath
                 andDelegate:(id <FBRequestDelegate>)delegate;

- (void)requestWithGraphPath:(NSString *)graphPath
                   andParams:(NSMutableDictionary *)params
                 andDelegate:(id <FBRequestDelegate>)delegate;

- (void)requestWithGraphPath:(NSString *)graphPath
                   andParams:(NSMutableDictionary *)params
               andHttpMethod:(NSString *)httpMethod
                 andDelegate:(id <FBRequestDelegate>)delegate;

- (void)dialog:(NSString *)action
   andDelegate:(id<FBDialogDelegate>)delegate;

- (void)dialog:(NSString *)action
     andParams:(NSMutableDictionary *)params
   andDelegate:(id <FBDialogDelegate>)delegate;

- (BOOL)isSessionValid;

@end

@protocol FBSessionDelegate <NSObject>

@optional

- (void)fbDidLogin;

- (void)fbDidNotLogin:(BOOL)cancelled;

- (void)fbDidLogout;

@end
