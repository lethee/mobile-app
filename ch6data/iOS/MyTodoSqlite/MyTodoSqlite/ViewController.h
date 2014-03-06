#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (strong) NSMutableArray *todoModel;
@property (strong) NSString *databasePath;

@end
