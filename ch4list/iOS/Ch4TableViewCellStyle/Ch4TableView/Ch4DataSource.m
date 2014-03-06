#import "Ch4DataSource.h"

const int tableViewStylesCount = 7;
UITableViewCellStyle tableViewStyles[tableViewStylesCount] = {
  UITableViewCellStyleDefault,
  UITableViewCellStyleValue1,
  UITableViewCellStyleValue2,
  UITableViewCellStyleSubtitle,
  UITableViewCellStyleDefault,
  UITableViewCellStyleDefault,
  UITableViewCellStyleDefault,
};
UITableViewCellAccessoryType tableViewAccType[tableViewStylesCount] = {
  UITableViewCellAccessoryCheckmark,
  UITableViewCellAccessoryCheckmark,
  UITableViewCellAccessoryCheckmark,
  UITableViewCellAccessoryNone,
  UITableViewCellAccessoryDisclosureIndicator,
  UITableViewCellAccessoryDetailDisclosureButton,
  UITableViewCellAccessoryCheckmark,
};

@implementation Ch4DataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
  return tableViewStylesCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell =
  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    UITableViewCellStyle style = tableViewStyles[indexPath.row];
    
    cell = [[UITableViewCell alloc]
            initWithStyle:style
            reuseIdentifier:CellIdentifier];
  }
  
  
  [cell.textLabel setText:
   [NSString stringWithFormat:@"제목 %d", indexPath.row]];
  [cell.detailTextLabel setText:
   [NSString stringWithFormat:@"보조 설명 %d", indexPath.row]];
  [cell setAccessoryType:tableViewAccType[indexPath.row]];
  
  return cell;
}

@end
