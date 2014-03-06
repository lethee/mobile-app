#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textLatitude;

@property (weak, nonatomic) IBOutlet UITextField *textLongitude;

@property (weak, nonatomic) IBOutlet UITextField *textAccuracy;

@property (weak, nonatomic) IBOutlet UIButton *buttonWatch;

@end
