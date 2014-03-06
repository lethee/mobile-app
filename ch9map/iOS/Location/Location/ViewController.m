#import "ViewController.h"

@interface ViewController ()

// CLLocationManager 인스턴스
@property CLLocationManager *locationManager;

// CLLocationManager 동작 여부 체크
@property BOOL isLocationManagerRunning;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 뷰가 로드되면 LocationManager 초기화
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.desiredAccuracy =
    kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = 500;
    self.locationManager.delegate = self;
    
    self.isLocationManagerRunning = NO;
}

#pragma mark - Button

- (IBAction)watchLoc:(id)sender
{
    // 위치정보 허용 여부를 검사하여 허용하지 않는 경우 처리
    if (NO == [CLLocationManager locationServicesEnabled]) {
        return;
    }
    
    if (self.isLocationManagerRunning == NO) {
        
        // 위치정보를 탐색중이 아니라면 위치정보 탐색을 시작
        [self.locationManager startUpdatingLocation];
        self.isLocationManagerRunning = YES;
        
        // 버튼 타이틀 변경
        [self.buttonWatch setTitle:@"탐색 중지"
                          forState:UIControlStateNormal];
    } else {
        
        // 위치정보를 탐색중이 아니라면 위치정보 탐색을 종료
        [self.locationManager stopUpdatingLocation];
        self.isLocationManagerRunning = NO;
        
        // 버튼 타이틀 변경
        [self.buttonWatch setTitle:@"현재 위치 탐색"
                          forState:UIControlStateNormal];
    }
}

#pragma mark - CLLocationManagerDelegate

// iOS SDK 버전 6.0 이후에 위치정보를 전달받는 델리게이트의
// 메소드가 변경되었다. 따라서 6.0 이상과 이하 모든 버전을
// 지원해야 하는 경우 이 점을 고려해서 코드를 작성해야 한다.

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0

// iOS 6.0 이상에서 위치정보를 받는 메소드
-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations
{
    // 가장 최근 위치정보
    CLLocation *newLocation = [locations lastObject];
    
    // TextField에 위치정보 값을 나타내기
    self.textLatitude.text = [NSString stringWithFormat:@"%f",
                              newLocation.coordinate.latitude];
    self.textLongitude.text = [NSString stringWithFormat:@"%f",
                               newLocation.coordinate.longitude];
    self.textAccuracy.text = [NSString stringWithFormat:@"%f",
                              newLocation.horizontalAccuracy];
}

#else

// iOS 2.0 이상, 6.0 미만에서 위치정보를 받는 메소드
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    self.textLatitude.text = [NSString stringWithFormat:@"%f",
                              newLocation.coordinate.latitude];
    self.textLongitude.text = [NSString stringWithFormat:@"%f",
                               newLocation.coordinate.longitude];
    self.textAccuracy.text = [NSString stringWithFormat:@"%f",
                              newLocation.horizontalAccuracy];
}

#endif

@end
