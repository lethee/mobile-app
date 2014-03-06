#import "Ch4ViewController.h"

@interface Ch4ViewController ()

@end

@implementation Ch4ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    NSMutableArray *weekArray = [NSMutableArray array];
    [weekArray addObject:@"월요일"];
    [weekArray addObject:@"화요일"];
    [weekArray addObject:@"수요일"];
    [weekArray addObject:@"목요일"];
    [weekArray addObject:@"금요일"];
    [weekArray addObject:@"토요일"];
    [weekArray addObject:@"일요일"];
    
    [self setArrayModel:weekArray];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.arrayModel.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // part1: 재사용
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // part2: 데이터 그려내기
    [cell.textLabel
     setText:[self.arrayModel objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *msg = [NSString stringWithFormat:@"%@!\n%d 섹션 %d 번째 아이템 선택!",
                     [self.arrayModel objectAtIndex:indexPath.row],
                     indexPath.section, indexPath.row];
    
    UIAlertView *av = [[UIAlertView alloc]
                       initWithTitle:nil message:msg delegate:nil
                       cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

@end
