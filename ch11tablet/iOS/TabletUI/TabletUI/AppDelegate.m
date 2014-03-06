#import "AppDelegate.h"

#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    // iPhone 환경
    MasterViewController *masterVC = [[MasterViewController alloc]
                                      initWithNibName:@"MasterViewController_iPhone"
                                      bundle:nil];
    
    self.navigationController = [[UINavigationController alloc]
                                 initWithRootViewController:masterVC];
    
    self.window.rootViewController = self.navigationController;
  }
  else {
    // iPad 환경
    MasterViewController *masterVC = [[MasterViewController alloc]
                                      initWithNibName:@"MasterViewController_iPad"
                                      bundle:nil];
    UINavigationController *masterNav = [[UINavigationController alloc]
                                         initWithRootViewController:masterVC];
    
    DetailViewController *detailVC = [[DetailViewController alloc]
                                      initWithNibName:@"DetailViewController_iPad"
                                      bundle:nil];
    UINavigationController *detailNav = [[UINavigationController alloc]
                                         initWithRootViewController:detailVC];
  	masterVC.detailViewController = detailVC;
  	
    self.splitViewController = [[UISplitViewController alloc] init];
    self.splitViewController.delegate = detailVC;
    self.splitViewController.viewControllers = @[masterNav, detailNav];
    
    self.window.rootViewController = self.splitViewController;
  }
  
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
