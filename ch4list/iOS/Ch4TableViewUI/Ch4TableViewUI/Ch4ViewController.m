#import "Ch4ViewController.h"

@interface Ch4ViewController ()

@end

@implementation Ch4ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textTitle.delegate = self;
    self.textDescription.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.textTitle resignFirstResponder];
            [self.textDescription resignFirstResponder];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

            NSString *msg = [NSString stringWithFormat:@"제목: %@\n내용: %@",
                             self.textTitle.text,
                             self.textDescription.text];
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message:msg delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}

#pragma - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
