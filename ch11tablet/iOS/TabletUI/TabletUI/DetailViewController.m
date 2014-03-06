#import "DetailViewController.h"

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  self.title = @"Detail";
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self configureView];
}

#pragma mark - Managing the detail item

- (void)updateDetailItem:(id)newDetailItem
{
  self.detailItem = newDetailItem;
  
  [self configureView];
  
  // 화면에서 Popover 사라지도록 함
  // iPhone 환경의 경우 항상 nil
  if (self.masterPopoverController != nil) {
    [self.masterPopoverController dismissPopoverAnimated:YES];
  }
}

- (void)configureView
{
  if (self.detailItem != nil) {
    self.detailDescriptionLabel.text = self.detailItem;
  } else {
    self.detailDescriptionLabel.text = @"";
  }
}

#pragma mark - Split view

// Landscape에서 Portrait로 전환시 'Master' 버튼 터치시 Popover 나타나도록 함
// iPhone 환경의 경우 호출되지 않음 (AppDelegate 참고)
- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
  barButtonItem.title = @"Master";
  [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
  
  self.masterPopoverController = popoverController;
}

// Portrait에서 Landscape로 전환시 'Master' 버튼 없애기
// iPhone 환경의 경우 호출되지 않음 (AppDelegate 참고)
- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
  [self.navigationItem setLeftBarButtonItem:nil animated:YES];
  
  self.masterPopoverController = nil;
}

@end
