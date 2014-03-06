#import "ViewController.h"
#import "MyAnnotation.h"

// ViewController 프로퍼티 정의
@interface ViewController ()

@property CLLocationManager *locationManager;
@property (copy) CLLocation *currentLoc;

@end

// ViewController 구현 코드
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // CLLocationManager 초기화
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = 500;
    
    // CLLocationManager 위치정보 탐색 시작
    
    [self.locationManager startUpdatingLocation];
    
    // MKMapView 초기화
    
    self.mapView.showsUserLocation = YES; // 사용자 위치 표시
    self.mapView.delegate = self;
    [self makeMapViewPins];
}

- (void)makeMapViewPins
{
    // '서울' 어노테이션(핀) 추가
    
    CLLocationCoordinate2D seoulLoc =
    CLLocationCoordinate2DMake(37.566351, 126.977921);
    
    MyAnnotation *annotation1 =
    [[MyAnnotation alloc] initWithCoordinate:seoulLoc];
    annotation1.title = @"서울";
    annotation1.subtitle = @"내가 살아가는 도시";
    
    // '공항' 어노테이션(핀) 추가
    
    CLLocationCoordinate2D airportLoc =
    CLLocationCoordinate2DMake(37.559309, 126.796002);
    
    MyAnnotation *annotation2 =
    [[MyAnnotation alloc] initWithCoordinate:airportLoc];
    annotation2.title = @"공항";
    annotation2.subtitle = @"여행의 시작과 끝";
    
    // 다수의 어노테이션은 리스트로 만들어 MapView에 추가
    
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:2];
    [annotations addObject:annotation1];
    [annotations addObject:annotation2];
    
    [self.mapView addAnnotations:annotations];
}

#pragma mark - Handle Buttons

// 지도 위치를 현재 위치로 이동
- (IBAction)refreshButton:(id)sender {
    [self.locationManager startUpdatingLocation];
}

// 지도 위치를 '서울'로 이동 및 지도범위(10km) 설정
- (IBAction)seoulButton:(id)sender {
    CLLocationCoordinate2D loc =
    CLLocationCoordinate2DMake(37.566351, 126.977921);
    
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(loc, 10000, 10000);
    
    self.mapView.region = region;
    [self updateTextView:loc];
}

// 지도 위치를 '제주'로 이동 및 지도범위(10km) 설정
- (IBAction)jejuButton:(id)sender
{
    CLLocationCoordinate2D loc =
    CLLocationCoordinate2DMake(33.500179, 126.532288);
    
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(loc, 10000, 10000);
    
    [self.mapView setRegion:region];
    [self updateTextView:loc];
}

- (void)updateTextView:(CLLocationCoordinate2D)coordinate
{
    // 위치정보의 값을 TextView에 나타내기
    NSString *text = [NSString stringWithFormat:@"위도: %+.6f\n경도: %+.6f\n",
                      coordinate.latitude,
                      coordinate.longitude];
    self.textView.text = text;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    // 업데이트된 위치정보를 받으면 탐색 종료
    [manager stopUpdatingLocation];
    
    // 현재 위치를 TextField
    CLLocation* location = [locations lastObject];
    [self updateTextView:location.coordinate];
    
    // 어노테이션과 현재 위치 거리 계산에 사용하기 위해 위치정보 저장
    self.currentLoc = location;
    
    // 지도 표시 위치 변경을 위한 데이터 초기화. 지도 반경 50km
    // 50km 고정값을 사용하는 대신 위치정보 정확도 값인
    // location.horizontalAccuracy를 활용하여
    // 지도의 확대 수준을 계산하여 사용할 수도 있다.
    double kiloPerDegree = 111;
    MKCoordinateSpan fiftyKilo = MKCoordinateSpanMake(50.0f / kiloPerDegree,
                                                      50.0f / kiloPerDegree);
    MKCoordinateRegion r;
    r.center = location.coordinate; // 지도 표시 위치
    r.span = fiftyKilo; // 지도 반경
    
    self.mapView.region = r; // 실제 지도 표시 위치 변경
}

#pragma mark - MKMapViewDelegate

// 어노테이션 선택 해제시 호출되는 메소드
- (void)mapView:(MKMapView *)mapView
didDeselectAnnotationView:(MKAnnotationView *)view
{
    // 선택된 어노테이션 인스턴스
    MyAnnotation *annotation = view.annotation;
    
    // 어노테이션에 설정된 위치정보
    double latitude = annotation.coordinate.latitude;
    double longitude = annotation.coordinate.longitude;
    CLLocation *annoLoc = [[CLLocation alloc]
                           initWithLatitude:latitude
                           longitude:longitude];
    
    // 현재 위치정볼와 어노테이션 위치정보 사이의 거리 계산
    CLLocationDistance d = [self.currentLoc distanceFromLocation:annoLoc];
    
    // 거리 정보를 UIAlertView로 나타내기
    NSString *title = [NSString stringWithFormat:@"%@부터 현재위치 거리",
                       annotation.title];
    NSString *msg = [NSString stringWithFormat:@"%f m", d];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

@end