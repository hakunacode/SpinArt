#import "FBDialog.h"
#import "FBLoginDialog.h"

@implementation FBLoginDialog

- (id)initWithURL:(NSString*) loginURL 
      loginParams:(NSMutableDictionary*) params 
         delegate:(id <FBLoginDialogDelegate>) delegate{
  
  self = [super init];
  _serverURL = [loginURL retain];
  _params = [params retain];
  _loginDelegate = delegate;
  return self;
}

- (void) dialogDidSucceed:(NSURL*)url {
  NSString *q = [url absoluteString];
  NSString *token = [self getStringFromUrl:q needle:@"access_token="];
  NSString *expTime = [self getStringFromUrl:q needle:@"expires_in="];
  NSDate *expirationDate =nil;
  
  if (expTime != nil) {
    int expVal = [expTime intValue];
    if (expVal == 0) {
      expirationDate = [NSDate distantFuture];
    } else {
      expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
    } 
  } 
  
  if ((token == (NSString *) [NSNull null]) || (token.length == 0)) {
    [self dialogDidCancel:url];
    [self dismissWithSuccess:NO animated:YES];
  } else {
    if ([_loginDelegate respondsToSelector:@selector(fbDialogLogin:expirationDate:)]) {
      [_loginDelegate fbDialogLogin:token expirationDate:expirationDate];
    }
    [self dismissWithSuccess:YES animated:YES];
  }
  
}

- (void)dialogDidCancel:(NSURL *)url {
  [self dismissWithSuccess:NO animated:YES];
  if ([_loginDelegate respondsToSelector:@selector(fbDialogNotLogin:)]) {
    [_loginDelegate fbDialogNotLogin:YES];
  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  if (!(([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
        ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102))) {
    [super webView:webView didFailLoadWithError:error];
    if ([_loginDelegate respondsToSelector:@selector(fbDialogNotLogin:)]) {
      [_loginDelegate fbDialogNotLogin:NO];
    }
  }
}

@end
