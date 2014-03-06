#import <UIKit/UIKit.h>

@interface Ch4ViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textTitle;
@property (weak, nonatomic) IBOutlet UITextField *textDescription;

@end
