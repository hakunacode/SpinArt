#import "FBLoginButton.h"
#import "Facebook.h"

#import <dlfcn.h>

@implementation FBLoginButton

@synthesize isLoggedIn = _isLoggedIn;

- (UIImage*)buttonImage {
  if (_isLoggedIn) {
    return [UIImage imageNamed:@"FBConnect.bundle/images/LogoutNormal.png"];
  } else {
    return [UIImage imageNamed:@"FBConnect.bundle/images/LoginWithFacebookNormal.png"];
  }
}

- (UIImage*)buttonHighlightedImage {
  if (_isLoggedIn) {
    return [UIImage imageNamed:@"FBConnect.bundle/images/LogoutPressed.png"];
  } else {
    return [UIImage imageNamed:@"FBConnect.bundle/images/LoginWithFacebookPressed.png"];
  }
}

- (void)updateImage {
  self.imageView.image = [self buttonImage];
  [self setImage: [self buttonImage]
                  forState: UIControlStateNormal];

  [self setImage: [self buttonHighlightedImage]
                  forState: UIControlStateHighlighted |UIControlStateSelected];

}

@end 
