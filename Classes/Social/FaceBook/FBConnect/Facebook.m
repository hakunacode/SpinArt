#import "Facebook.h"
#import "FBLoginDialog.h"
#import "FBRequest.h"

static NSString* kOAuthURL = @"https://www.facebook.com/dialog/oauth";
static NSString* kFBAppAuthURL = @"fbauth://authorize";
static NSString* kRedirectURL = @"fbconnect://success";
static NSString* kGraphBaseURL = @"https://graph.facebook.com/";
static NSString* kRestApiURL = @"https://api.facebook.com/method/";
static NSString* kUIServerBaseURL = @"http://www.facebook.com/connect/uiserver.php";

static NSString* kUIServerSecureURL = @"https://www.facebook.com/connect/uiserver.php";
static NSString* kCancelURL = @"fbconnect://cancel";
static NSString* kLogin = @"login";
static NSString* kSDK = @"ios";
static NSString* kSDKVersion = @"2";

@implementation Facebook

@synthesize accessToken = _accessToken,
         expirationDate = _expirationDate,
        sessionDelegate = _sessionDelegate,
      forceOldStyleAuth = _forceOldStyleAuth;

- (void)dealloc {
  [_accessToken release];
  [_expirationDate release];
  [_request release];
  [_loginDialog release];
  [_fbDialog release];
  [_appId release];
  [_permissions release];
  [super dealloc];
}

- (void)openUrl:(NSString *)url
         params:(NSMutableDictionary *)params
     httpMethod:(NSString *)httpMethod
       delegate:(id<FBRequestDelegate>)delegate {
  [params setValue:@"json" forKey:@"format"];
  [params setValue:kSDK forKey:@"sdk"];
  [params setValue:kSDKVersion forKey:@"sdk_version"];
  if ([self isSessionValid]) {
    [params setValue:self.accessToken forKey:@"access_token"];
  }

  [_request release];
  _request = [[FBRequest getRequestWithParams:params
                                   httpMethod:httpMethod
                                     delegate:delegate
                                   requestURL:url] retain];
  [_request connect];
}

- (void)authorizeWithFBAppAuth:(BOOL)tryFBAppAuth
                    safariAuth:(BOOL)trySafariAuth {
  NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _appId, @"client_id",
                                 @"user_agent", @"type",
                                 kRedirectURL, @"redirect_uri",
                                 @"touch", @"display",
                                 kSDKVersion, @"sdk",
                                 nil];

  if (_permissions != nil) {
    NSString* scope = [_permissions componentsJoinedByString:@","];
    [params setValue:scope forKey:@"scope"];
  }

  BOOL didOpenOtherApp = NO;
  UIDevice *device = [UIDevice currentDevice];
  if ([device respondsToSelector:@selector(isMultitaskingSupported)] && [device isMultitaskingSupported]) {
    if (tryFBAppAuth) {
      NSString *fbAppUrl = [FBRequest serializeURL:kFBAppAuthURL params:params];
      didOpenOtherApp = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbAppUrl]];
    }

    if (trySafariAuth && !didOpenOtherApp) {
      NSString *nextUrl = [NSString stringWithFormat:@"fb%@://authorize", _appId];
      [params setValue:nextUrl forKey:@"redirect_uri"];

      NSString *fbAppUrl = [FBRequest serializeURL:kOAuthURL params:params];
      didOpenOtherApp = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbAppUrl]];
    }
  }

  if (!didOpenOtherApp) {
    [_loginDialog release];
    _loginDialog = [[FBLoginDialog alloc] initWithURL:kOAuthURL
                                          loginParams:params
                                             delegate:self];

    [_loginDialog show];
  }
}

- (NSDictionary*)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
    [[kv objectAtIndex:1]
     stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
  return params;
}

- (void)authorize:(NSString *)application_id
      permissions:(NSArray *)permissions
         delegate:(id<FBSessionDelegate>)delegate {
  [_appId release];
  _appId = [application_id copy];

  [_permissions release];
  _permissions = [permissions retain];

  _sessionDelegate = delegate;

	_forceOldStyleAuth = YES;
  [self authorizeWithFBAppAuth:!_forceOldStyleAuth safariAuth:!_forceOldStyleAuth];
}

- (BOOL)handleOpenURL:(NSURL *)url {
  if (![[url absoluteString] hasPrefix:[NSString stringWithFormat:@"fb%@://authorize", _appId]]) {
    return NO;
  }

  NSString *query = [url fragment];

  if (!query) {
    query = [url query];
  }

  NSDictionary *params = [self parseURLParams:query];
  NSString *accessToken = [params valueForKey:@"access_token"];

  if (!accessToken) {
    NSString *errorReason = [params valueForKey:@"error"];
    
    if (errorReason && [errorReason isEqualToString:@"service_disabled_use_browser"]) {
      [self authorizeWithFBAppAuth:NO safariAuth:YES];
      return YES;
    }
    
    if (errorReason && [errorReason isEqualToString:@"service_disabled"]) {
      [self authorizeWithFBAppAuth:NO safariAuth:NO];
      return YES;
    }

    NSString *errorCode = [params valueForKey:@"error_code"];

    BOOL userDidCancel =
      !errorCode && (!errorReason || [errorReason isEqualToString:@"access_denied"]);
    [self fbDialogNotLogin:userDidCancel];
    return YES;
  }

  NSString *expTime = [params valueForKey:@"expires_in"];
  NSDate *expirationDate = [NSDate distantFuture];
  if (expTime != nil) {
    int expVal = [expTime intValue];
    if (expVal != 0) {
      expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
    }
  }

  [self fbDialogLogin:accessToken expirationDate:expirationDate];
  return YES;
}

- (void)logout:(id<FBSessionDelegate>)delegate {

  _sessionDelegate = delegate;

  NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
  [self requestWithMethodName:@"auth.expireSession"
                    andParams:params andHttpMethod:@"GET"
                  andDelegate:nil];

  [params release];
  [_accessToken release];
  _accessToken = nil;
  [_expirationDate release];
  _expirationDate = nil;

  NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  NSArray* facebookCookies = [cookies cookiesForURL:
    [NSURL URLWithString:@"http://login.facebook.com"]];

  for (NSHTTPCookie* cookie in facebookCookies) {
    [cookies deleteCookie:cookie];
  }

  if ([self.sessionDelegate respondsToSelector:@selector(fbDidLogout)]) {
    [_sessionDelegate fbDidLogout];
  }
}

- (void)requestWithParams:(NSMutableDictionary *)params
              andDelegate:(id <FBRequestDelegate>)delegate {
  if ([params objectForKey:@"method"] == nil) {
    NSLog(@"API Method must be specified");
    return;
  }

  NSString * methodName = [params objectForKey:@"method"];
  [params removeObjectForKey:@"method"];

  [self requestWithMethodName:methodName
                    andParams:params
                andHttpMethod:@"GET"
                  andDelegate:delegate];
}

- (void)requestWithMethodName:(NSString *)methodName
                    andParams:(NSMutableDictionary *)params
                andHttpMethod:(NSString *)httpMethod
                  andDelegate:(id <FBRequestDelegate>)delegate {
  NSString * fullURL = [kRestApiURL stringByAppendingString:methodName];
  [self openUrl:fullURL params:params httpMethod:httpMethod delegate:delegate];
}

- (void)requestWithGraphPath:(NSString *)graphPath
                 andDelegate:(id <FBRequestDelegate>)delegate {

  [self requestWithGraphPath:graphPath
                   andParams:[NSMutableDictionary dictionary]
               andHttpMethod:@"GET"
                 andDelegate:delegate];
}

- (void)requestWithGraphPath:(NSString *)graphPath
                   andParams:(NSMutableDictionary *)params
                 andDelegate:(id <FBRequestDelegate>)delegate {
  [self requestWithGraphPath:graphPath
                   andParams:params
               andHttpMethod:@"GET"
                 andDelegate:delegate];
}

- (void)requestWithGraphPath:(NSString *)graphPath
                   andParams:(NSMutableDictionary *)params
               andHttpMethod:(NSString *)httpMethod
                 andDelegate:(id <FBRequestDelegate>)delegate {
  NSString * fullURL = [kGraphBaseURL stringByAppendingString:graphPath];
  [self openUrl:fullURL params:params httpMethod:httpMethod delegate:delegate];
}

- (void)dialog:(NSString *)action
   andDelegate:(id<FBDialogDelegate>)delegate {
  NSMutableDictionary * params = [NSMutableDictionary dictionary];
  [self dialog:action andParams:params andDelegate:delegate];
}

- (void)dialog:(NSString *)action
     andParams:(NSMutableDictionary *)params
   andDelegate:(id <FBDialogDelegate>)delegate {

  NSString *dialogURL = nil;
  [params setObject:@"touch" forKey:@"display"];
  [params setObject: kSDKVersion forKey:@"sdk"];

  if (action == kLogin) {
    [params setObject:@"user_agent" forKey:@"type"];
    [params setObject:kRedirectURL forKey:@"redirect_uri"];

    [_fbDialog release];
    _fbDialog = [[FBLoginDialog alloc] initWithURL:kOAuthURL loginParams:params delegate:self];

  } else {
    [params setObject:action forKey:@"method"];
    [params setObject:kRedirectURL forKey:@"next"];
    [params setObject:kCancelURL forKey:@"cancel_url"];

    if ([self isSessionValid]) {
      [params setValue:
       [self.accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                forKey:@"access_token"];
      dialogURL = [kUIServerSecureURL copy];
    } else {
      dialogURL = [kUIServerBaseURL copy];
    }

    [_fbDialog release];
    _fbDialog = [[FBDialog alloc] initWithURL:dialogURL
                                       params:params
                                     delegate:delegate];
    [dialogURL release];

  }

  [_fbDialog show];
}

- (BOOL)isSessionValid {
  return (self.accessToken != nil && self.expirationDate != nil
           && NSOrderedDescending == [self.expirationDate compare:[NSDate date]]);

}

- (void)fbDialogLogin:(NSString *)token expirationDate:(NSDate *)expirationDate {
  self.accessToken = token;
  self.expirationDate = expirationDate;
  if ([self.sessionDelegate respondsToSelector:@selector(fbDidLogin)]) {
    [_sessionDelegate fbDidLogin];
  }

}

- (void)fbDialogNotLogin:(BOOL)cancelled {
  if ([self.sessionDelegate respondsToSelector:@selector(fbDidNotLogin:)]) {
    [_sessionDelegate fbDidNotLogin:cancelled];
  }
}


- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
  NSLog(@"Failed to expire the session");
}

@end
