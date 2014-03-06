#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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

- (void)loadView {
    
    // 뷰컨트롤러 기본뷰 정의
    
    UIView *newView = [[UIView alloc]
                       initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    newView.backgroundColor = [UIColor whiteColor];
    self.view = newView;
    
    // UITextField 정의
    
    UITextField *newTextField = [[UITextField alloc]
                                 initWithFrame:CGRectMake(10, 30, 300, 30)];
    newTextField.placeholder = @"TextField 입력상자";
    newTextField.backgroundColor = [UIColor whiteColor];
    newTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    // 기본뷰의 하위뷰로 추가
    [self.view addSubview:newTextField];
    // 뷰컨트롤러의 프로퍼티로 설정
    self.textField = newTextField;
    
    // UIButton 정의
    
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newButton.frame = CGRectMake(10, 80, 300, 30);
    [newButton setTitle:@"버튼" forState:UIControlStateNormal];
    
    // UIButton 액션 메소드 설정
    [newButton addTarget:self
                  action:@selector(buttonAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    // 기본뷰의 하위뷰로 추가
    [self.view addSubview:newButton];
    // 뷰컨트롤러의 프로퍼티로 설정
    self.button = newButton;
}

#pragma mark - Methods

- (IBAction)buttonAction:(id)sender {
    [self.textField resignFirstResponder];
}

@end
