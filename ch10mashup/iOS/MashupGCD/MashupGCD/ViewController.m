#import "ViewController.h"

@interface ViewController ()

@property NSArray *results;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (IBAction)refresh:(id)sender
{
  [self callApiUsingGCD];
}

#pragma mark - GCD and UI update method

- (void)callApiUsingGCD
{
  NSURL *url = [NSURL URLWithString:@"http://search.twitter.com/search.json?q=ios"];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSData* data = [NSData dataWithContentsOfURL:url];
    [self performSelectorOnMainThread:@selector(fetchedData:)
                           withObject:data
                        waitUntilDone:YES];
  });
}

- (void)fetchedData:(NSData *)responseData
{
  NSError* error;
  NSDictionary* json = [NSJSONSerialization
                        JSONObjectWithData:responseData
                        options:kNilOptions
                        error:&error];
  
  self.results = [json objectForKey:@"results"];
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
  if (self.results != nil) {
    return self.results.count;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"cell";
  
  UITableViewCell *cell = [tableView
                           dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:identifier];
  }

  cell.textLabel.text = [[self.results objectAtIndex:indexPath.row] objectForKey:@"text"];
  
  return cell;
}


@end
