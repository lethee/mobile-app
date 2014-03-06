#import <UIKit/UIKit.h>

@interface Ch4ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property id<UITableViewDataSource> dataSource;

@end
