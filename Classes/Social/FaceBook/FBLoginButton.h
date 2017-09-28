@interface FBLoginButton : UIButton {
  BOOL  _isLoggedIn;
}

@property(nonatomic) BOOL isLoggedIn; 

- (void) updateImage;

@end
