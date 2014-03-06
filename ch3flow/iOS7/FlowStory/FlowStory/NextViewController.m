#import "NextViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
