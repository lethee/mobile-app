#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// iPhone 환경
@property (strong, nonatomic) UINavigationController *navigationController;

// iPad 환경
@property (strong, nonatomic) UISplitViewController *splitViewController;

@end