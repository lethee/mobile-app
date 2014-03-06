#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
    
  self.webView.delegate = self;
  self.webView.scrollView.delegate = self;
  
  NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"html/index" ofType:@"html"]isDirectory:NO];
  
  [self.webView loadRequest:[NSURLRequest requestWithURL:file]];
  
  [self.webView.scrollView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSLog(@"scrollViewDidScroll %f" ,scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.size.height));
}

@end
