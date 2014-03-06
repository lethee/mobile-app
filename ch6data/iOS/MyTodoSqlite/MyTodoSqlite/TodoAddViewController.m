#import <sqlite3.h>
#import "TodoAddViewController.h"

@interface TodoAddViewController ()

@end

@implementation TodoAddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // 도큐먼트의 디렉토리를 가져온다.
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask,
                                                   YES);
    
    docsDir = dirPaths[0];
    
    // 데이터베이스 파일의 경로를 만든다.
    self.databasePath = [[NSString alloc] initWithString:
                         [docsDir stringByAppendingPathComponent:@"todo.db"]];
    
}

- (IBAction)addItem:(id)sender
{
    if([self.itemField.text isEqualToString:@""])
    {
        return;
    }
    
    // 저장할 데이터 준비
    NSString *content = self.itemField.text;
    NSDate* now = [NSDate date];
    
    sqlite3 *_contactDB;
    sqlite3_stmt    *statement;
    const char *dbpath = [self.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO TODO (content, createDate)"
                               @" VALUES (\"%@\", \"%f\")",
                               content, [now timeIntervalSince1970]];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Task saved");
        }
        else
        {
            NSLog(@"saving task is failed");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelAddItem:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
