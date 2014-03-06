//
//  ViewController2.m
//  UIProject2
//
//  Created by Sean Lee on 13. 11. 6..
//  Copyright (c) 2013년 Sean Lee. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"액션시트"
                                  delegate:self
                                  cancelButtonTitle:@"취소"
                                  destructiveButtonTitle:@"닫기"
                                  otherButtonTitles:@"버튼1", @"버튼2", nil];
    [actionSheet showInView:self.view];
}

// UIActionSheet 델리게이트 메소드
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"ButtonIndex: %d", buttonIndex);
    switch (buttonIndex) {
        default:
            [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
