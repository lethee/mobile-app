#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
  self.title = @"Master";
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    // Popover의 사이즈
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
  }

  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  if (self.objects == nil) {
    self.objects = [[NSMutableArray alloc] init];
    
    [self.objects addObject:@"Item 1"];
    [self.objects addObject:@"Item 2"];
    [self.objects addObject:@"Item 3"];
    [self.objects addObject:@"Item 4"];
  }
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(insertNewObject:)];
  
  self.navigationItem.rightBarButtonItem = addButton;
}

#pragma mark - Custom Method

- (void)insertNewObject:(id)sender
{
  [_objects insertObject:@"Item New" atIndex:0];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.tableView insertRowsAtIndexPaths:@[indexPath]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
  return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:CellIdentifier];
  }
  
  cell.textLabel.text = [self.objects objectAtIndex:indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *object = [self.objects objectAtIndex:indexPath.row];
  
  // iPhone 환경이면 detailItem 설정 후 pushViewController
  // iPad 환경이면 detailItem 설정
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    self.detailViewController = [[DetailViewController alloc]
                                   initWithNibName:@"DetailViewController_iPhone"
                                   bundle:nil];
    [self.detailViewController updateDetailItem:object];
    [self.navigationController pushViewController:self.detailViewController
                                         animated:YES];
  } else {
    [self.detailViewController updateDetailItem:object];
  }
}

@end
