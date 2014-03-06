#import "ModalViewController.h"

@interface ModalViewController ()

@end

@implementation ModalViewController

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
