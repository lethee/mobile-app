#import <UIKit/UIKit.h>

@interface TodoAddViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *itemField;

@property (strong) NSString *databasePath;

@end