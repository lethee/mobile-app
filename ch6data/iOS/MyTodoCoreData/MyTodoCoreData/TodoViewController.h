#import <UIKit/UIKit.h>

@interface TodoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *todoModel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void)loadData;
- (void)removeItem:(NSIndexPath*)indexPath;
@end
