#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.idField.delegate = self;
    self.passwordField.delegate = self;
    
    // UserDefaults 서비스
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // UserDefaults에 저장한 데이터 가져오기
    NSString *idText = [userDefaults objectForKey:@"id"];
    NSString *passwordText = [userDefaults objectForKey:@"password"];
    
    self.idField.text = idText;
    self.passwordField.text = passwordText;
}

-(IBAction)login:(id)sender {
    [self.idField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    NSString *idText = self.idField.text;
    NSString *passwordText = self.passwordField.text;
    
    // UserDefaults 서비스
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // UserDefaults에 데이터 저장하기
    [userDefaults setObject:idText forKey:@"id"];
    [userDefaults setObject:passwordText forKey:@"password"];
    
    // UserDefaults에 실제로 데이터 저장하기
    [userDefaults synchronize];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"로그인 정보 저장"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)logout:(id)sender {
    [self.idField resignFirstResponder]; // 키보드 화면에서 사라지도록 설정
    [self.passwordField resignFirstResponder]; // 키보드 화면에서 사라지도록 설정
    
    // UserDefaults 서비스
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // UserDefaults에 데이터 삭제하기
    [userDefaults removeObjectForKey:@"id"];
    [userDefaults removeObjectForKey:@"password"];
    
    self.idField.text = @"";
    self.passwordField.text = @"";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"로그인 정보 초기화"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
