#import "TodoAddViewController.h"
#import "TodoAppDelegate.h"

@implementation TodoAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (IBAction)addItem:(id)sender
{
  if([self.itemField.text isEqualToString:@""]) {
    return;
  }
  
  TodoAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  NSManagedObjectContext *context = [appDelegate managedObjectContext];
  
  NSManagedObject *newItem;
  newItem = [NSEntityDescription
             insertNewObjectForEntityForName:@"TodoItem"
             inManagedObjectContext:context];
  
  NSDate* now = [NSDate date];
  
  [newItem setValue: self.itemField.text  forKey:@"content"];
  [newItem setValue: now forKey:@"createDate"];
  [context insertObject:newItem];
  
  NSError *error = nil;
  [context save:&error];
  
  if(error != nil) {
    NSLog(@"fail");
    return;
  }
  
  NSLog(@"success");
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAddItem:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}


@end
