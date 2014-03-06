#import "Ch4AppDelegate.h"
#import "Ch4ViewController.h"

@implementation Ch4AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  self.viewController = [[Ch4ViewController alloc]
                         initWithNibName:@"Ch4ViewController" bundle:nil];
  self.window.rootViewController = self.viewController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
