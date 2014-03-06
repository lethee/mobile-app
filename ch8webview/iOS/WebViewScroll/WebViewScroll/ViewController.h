#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
