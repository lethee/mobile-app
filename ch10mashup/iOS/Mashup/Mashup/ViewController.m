#import "ViewController.h"
#import "XMLReader.h"

@interface ViewController ()

// OpenAPI 네트워크 연결 및 전송에 사용. 스레드 처리.
@property NSURLConnection *connection;

// OpenAPI 데이터를 파싱 후에 담는 Dictionary
@property NSDictionary *dicData;

// 데이터 전송중임을 나타내는 UIActivityIndicatorView
@property UIActivityIndicatorView *actIndView;

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

#pragma mark - Activity Method

- (void)showActivityIndicatorView
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  
  self.actIndView = [[UIActivityIndicatorView alloc] init];
  self.actIndView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  self.actIndView.frame = self.view.bounds;
  self.actIndView.center = self.view.center;
  self.actIndView.backgroundColor = [UIColor grayColor];
  self.actIndView.alpha = 0.3f;
  self.actIndView.hidden = NO;
  [self.view addSubview:self.actIndView];
  [self.actIndView startAnimating];
}

- (void)hideActivityIndicatorView
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  
  [self.actIndView stopAnimating];
  self.actIndView.hidden = YES;
  [self.actIndView removeFromSuperview];
  self.actIndView = nil;
}

#pragma mark - Button

- (IBAction)refresh:(id)sender
{
  self.dicData = nil;
  
  NSString *urlForm = @"http://openapi.naver.com/search?key=%@&query=%@&target=%@";
  NSString *reqUrl = [NSString stringWithFormat:urlForm,
                      @"17627873b809271a1b87dfc14acbc43b",
                      @"movie",
                      @"ranktheme"];
  
  if (self.connection == nil) {
    NSURL *url = [NSURL URLWithString:reqUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self.connection start];
    
    [self showActivityIndicatorView];
  }
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
  [self hideActivityIndicatorView];
}

//
// Example Data:
// <?xml version="1.0" encoding="UTF-8"?>
// <result>
//   <item>
//    <R1><K>영화전망좋은집</K><S>+</S><V>66</V></R1>
//    <R2><K>박수건달</K><S>+</S><V>2</V></R2>
//    <R3><K>영화레미제라블</K><S>-</S><V>1</V></R3>
//    <R4><K>클라우드아틀라스</K><S>-</S><V>1</V></R4>
//    <R5><K>영화타워</K><S>*</S><V>0</V></R5>
//    <R6><K>은밀하게위대하게</K><S>+</S><V>6</V></R6>
//    <R7><K>더임파서블</K><S>+</S><V>17</V></R7>
//    <R8><K>라이프오브파이</K><S>-</S><V>2</V></R8>
//    <R9><K>명탐정코난:은빛날개의마술사</K><S>-</S><V>2</V></R9>
//    <R10><K>극장판포켓몬스터베스트위시:큐레무vs성검사케르디오</K><S>-</S><V>2</V></R10>
//   </item>
//  </result>
//
- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
  NSString *apiData = [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
  
  NSError *error = nil;
  NSDictionary *dicData = [XMLReader dictionaryForXMLString:apiData error:&error];
  self.dicData = [[dicData valueForKey:@"result"] valueForKey:@"item"];
  [self.tableView reloadData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  [self hideActivityIndicatorView];
  self.connection = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
  if (self.dicData != nil) {
    
    // 실시간 검색 아이템 갯수
    return self.dicData.allKeys.count;
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
  
  // 실시간 검색 아이템 텍스트
  
  NSString *key = [NSString stringWithFormat:@"R%d", indexPath.row + 1];
  NSDictionary *item = [self.dicData valueForKey:key];
  
  NSString *title = [NSString stringWithFormat:@"%@ (%@ %@)",
                     [[item objectForKey:@"K"] objectForKey:@"text"],
                     [[item objectForKey:@"S"] objectForKey:@"text"],
                     [[item objectForKey:@"V"] objectForKey:@"text"]];
  cell.textLabel.text = title;
  
  return cell;
}

@end