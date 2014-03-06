//
//  ViewController.m
//  WebViewEx
//
//  Created by Sean Lee on 13. 10. 31..
//  Copyright (c) 2013년 Sean Lee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    [self home:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Button Action

- (IBAction)home:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)call:(id)sender {
    NSString *javaScriptCode = @"userJavaScriptFunc1('Native Value');";
    NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:javaScriptCode];
    
    NSLog(@"javaScriptCode result: %@", result);
}

#pragma - UserFunction

- (void)userFunc1
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"userFunc1"
                                                    message:@"userFunc1"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)userFunc2:(NSString *)param
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"userFunc2"
                                                    message:param
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"request : %@", request);
    
    // URL starts with 'local://...'
    if ([@"local" isEqualToString:request.URL.scheme]) {
        NSLog(@"url: %@", request.URL);
        if ([request.URL.host isEqualToString:@"userFunc1"]) {
            [self userFunc1];
        }
        if ([request.URL.host isEqualToString:@"userFunc2"]) {
            NSLog(@"param: %@", request.URL.query);
            [self userFunc2:request.URL.query];
        }
        return NO;
    }
    
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
