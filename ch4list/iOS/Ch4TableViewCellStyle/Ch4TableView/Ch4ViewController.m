#import "Ch4ViewController.h"
#import "Ch4DataSource.h"

@implementation Ch4ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"월요일"];
    [array addObject:@"화요일"];
    [array addObject:@"수요일"];
    [array addObject:@"목요일"];
    [array addObject:@"금요일"];
    [array addObject:@"토요일"];
    [array addObject:@"일요일"];
    
    Ch4DataSource *dataSource = [[Ch4DataSource alloc] init];
    dataSource.arrayModel = array;
    
    self.dataSource = dataSource;
    [self.tableView setDataSource:self.dataSource];
}

@end
