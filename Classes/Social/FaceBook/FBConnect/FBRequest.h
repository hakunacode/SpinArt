#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FBRequestDelegate;

@interface FBRequest : NSObject {
  id<FBRequestDelegate> _delegate;
  NSString*             _url;
  NSString*             _httpMethod;
  NSMutableDictionary*  _params;
  NSURLConnection*      _connection;
  NSMutableData*        _responseText;
}


@property(nonatomic,assign) id<FBRequestDelegate> delegate;
@property(nonatomic,copy) NSString* url;
@property(nonatomic,copy) NSString* httpMethod;
@property(nonatomic,retain) NSMutableDictionary* params;
@property(nonatomic,assign) NSURLConnection*  connection;
@property(nonatomic,assign) NSMutableData* responseText;
+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params;
+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod;
+ (FBRequest*)getRequestWithParams:(NSMutableDictionary *) params
                        httpMethod:(NSString *) httpMethod
                          delegate:(id<FBRequestDelegate>)delegate
                        requestURL:(NSString *) url;
- (BOOL) loading;
- (void) connect;
@end

@protocol FBRequestDelegate <NSObject>
@optional
- (void)requestLoading:(FBRequest *)request;
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error;
- (void)request:(FBRequest *)request didLoad:(id)result;
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data;

@end

