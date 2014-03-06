#import <UIKit/UIKit.h>

@interface TodoAddViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *itemField;

- (IBAction)addItem:(id)sender;
- (IBAction)cancelAddItem:(id)sender;

@end
