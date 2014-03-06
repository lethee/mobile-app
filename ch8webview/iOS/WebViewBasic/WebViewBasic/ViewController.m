#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
}

- (IBAction)back:(id)sender
{
    [self.webView goBack];
}

- (IBAction)refresh:(id)sender
{
    [self.webView reload];
}

- (IBAction)local:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSLog(@"path: %@", path);
    NSURL *url = [NSURL fileURLWithPath:path];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)apple:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
