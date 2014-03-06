#import "P1ViewController.h"
#import "P1GreetModel.h"

@interface P1ViewController ()
@end


@implementation P1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showModel:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Handlers

- (IBAction)showModel:(id)sender {
    P1GreetModel *model = [[P1GreetModel alloc] init];
    [model setContent:@"World"];
    
    [self renderModel:model];
}

- (IBAction)resetModel:(id)sender {
    [self renderModel:nil];
}

#pragma mark - Render Model into View

- (void)renderModel:(P1GreetModel *)model {
    if (model != nil) {
        NSString *text = [NSString stringWithFormat:@"Hello, %@!",
                          model.content];
        [self.modelPlaceHolder setText:text];
    }
    else {
        [self.modelPlaceHolder setText:nil];
    }
}

@end
