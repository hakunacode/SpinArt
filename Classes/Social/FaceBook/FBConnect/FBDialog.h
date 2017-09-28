
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FBDialogDelegate;

@interface FBDialog : UIView <UIWebViewDelegate> {
  id<FBDialogDelegate> _delegate;
  NSMutableDictionary *_params;
  NSString * _serverURL;
  NSURL* _loadingURL;
  UIWebView* _webView;
  UIActivityIndicatorView* _spinner;
  UIImageView* _iconView;
  UILabel* _titleLabel;
  UIButton* _closeButton;
  UIDeviceOrientation _orientation;
  BOOL _showingKeyboard;

  UIView* _modalBackgroundView;
}

@property(nonatomic,assign) id<FBDialogDelegate> delegate;
@property(nonatomic, retain) NSMutableDictionary* params;
@property(nonatomic,copy) NSString* title;
- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle;
- (id)initWithURL: (NSString *) loadingURL
           params: (NSMutableDictionary *) params
         delegate: (id <FBDialogDelegate>) delegate;
- (void)show;
- (void)load;
- (void)loadURL:(NSString*)url
            get:(NSDictionary*)getParams;
- (void)dismissWithSuccess:(BOOL)success animated:(BOOL)animated;
- (void)dismissWithError:(NSError*)error animated:(BOOL)animated;
- (void)dialogWillAppear;
- (void)dialogWillDisappear;
- (void)dialogDidSucceed:(NSURL *)url;
- (void)dialogDidCancel:(NSURL *)url;
@end

@protocol FBDialogDelegate <NSObject>
@optional
- (void)dialogDidComplete:(FBDialog *)dialog;
- (void)dialogCompleteWithUrl:(NSURL *)url;
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url;
- (void)dialogDidNotComplete:(FBDialog *)dialog;
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error;
- (BOOL)dialog:(FBDialog*)dialog shouldOpenURLInExternalBrowser:(NSURL *)url;
@end
