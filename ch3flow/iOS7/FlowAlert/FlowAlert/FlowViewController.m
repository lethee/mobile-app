#import "FlowViewController.h"

@interface FlowViewController ()

@end

@implementation FlowViewController

- (void)showYesDialog {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"다이얼로그"
                          message:@"다이얼로그 메시지는 이렇게 표시됩니다."
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)showYesNoDialog {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"다이얼로그"
                          message:@"다이얼로그가 보이나요?\n 예, 혹은 아니오를 선택해주세요"
                          delegate:self
                          cancelButtonTitle:@"아니오"
                          otherButtonTitles:@"예", nil];
    [alert show];
}

- (void)showYesNoOtherDialog {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"다이얼로그"
                          message:@"다이얼로그가 보이나요?\n 버튼을 선택해주세요."
                          delegate:self
                          cancelButtonTitle:@"아니오"
                          otherButtonTitles:@"예", @"모르겠어요", nil];
    [alert show];
}

- (IBAction)showDialog:(id)sender {
    //[self showYesDialog];
    //[self showYesNoDialog];
    [self showYesNoOtherDialog];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *msg = [NSString stringWithFormat:
                     @"선택한 버튼의 ID는 %ld 입니다", (long)buttonIndex];
    [self.label setText:msg];
}

@end
