#import "TodoViewController.h"
#import "TodoAppDelegate.h"
#import "TodoItem.h"

@implementation TodoViewController

- (void)viewWillAppear:(BOOL)animated
{
  if(self.tableView != nil)
  {
    [self loadData];
    [self.tableView reloadData];
  }
}

#pragma mark - Methods

- (void)loadData
{
  TodoAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  NSManagedObjectContext *context = [appDelegate managedObjectContext];
  NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"TodoItem"
                                                inManagedObjectContext:context];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entityDesc];
  
  NSError *error;
  NSArray *objects = [context executeFetchRequest:request error:&error];
  
  self.todoModel = [[[NSMutableArray alloc] initWithArray:objects] autorelease];
}

- (void)removeItem:(NSIndexPath*)indexPath
{
  NSInteger index = indexPath.row;
  TodoItem *todoItem = [self.todoModel objectAtIndex:index];
  
  TodoAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];  
  NSManagedObjectContext *context = [appDelegate managedObjectContext];
  
  [context deleteObject:todoItem];
  
  [self.todoModel removeObjectAtIndex:index];
  [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                        withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
  return [self.todoModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell =
   [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                   forIndexPath:indexPath];
  
  if(cell == nil) {
    cell = [[[UITableViewCell alloc]
             initWithStyle:UITableViewCellStyleDefault
             reuseIdentifier:CellIdentifier] autorelease];
  }
  
  TodoItem *item = [self.todoModel objectAtIndex:indexPath.row];
  cell.textLabel.text = item.content;
  
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self removeItem:indexPath];
  }
}

@end
