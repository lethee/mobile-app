#import <sqlite3.h>
#import "ViewController.h"
#import "TodoItem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setDataSource:self];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // 도큐먼트의 디렉토리를 가져온다.
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask,
                                                   YES);
    docsDir = dirPaths[0];
    
    // 데이터베이스 파일의 경로를 만든다.
    self.databasePath = [docsDir stringByAppendingPathComponent:@"todo.db"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.databasePath ] == NO) {
        const char *dbpath = [self.databasePath UTF8String];
        sqlite3 *contactDB;
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
            char *errMsg;
            
            // 테이블이 없으면 만드는 쿼리문
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS TODO ("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT, "
            "CONTENT TEXT, "
            "CREATEDATE REAL)";
            
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create table");
            }
            
            sqlite3_close(contactDB);
            NSLog(@"database created");
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
}

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
    const char *dbpath = [self.databasePath UTF8String];
    sqlite3 *contactDB;
    sqlite3_stmt *statement;
    NSMutableArray *objects = [NSMutableArray array];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT content, createDate FROM todo";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL)
            == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *content = [[NSString alloc]
                                     initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                
                NSDate *createDate = [[NSDate alloc] initWithTimeIntervalSince1970:
                                      (NSTimeInterval)sqlite3_column_double(statement, 1)];
                
                TodoItem *item = [[TodoItem alloc] init];
                [item setContent:content];
                item.createDate = createDate;
                [objects addObject:item];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    self.todoModel = objects;
}

- (void)removeItem:(NSIndexPath*)indexPath
{
    NSInteger index = indexPath.row;
    TodoItem *item = [self.todoModel objectAtIndex:index];
    
    sqlite3 *contactDB;
    sqlite3_stmt *statement;
    const char *dbpath = [self.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:
                               @"DELETE FROM TODO WHERE createDate=\"%f\"",
                               [item.createDate timeIntervalSince1970]];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(contactDB, delete_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Task deleted");
        }
        else
        {
            NSLog(@"deleting task is failed");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
        
        [self.todoModel removeObjectAtIndex:index];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableView

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellIdentifier];
    }
    
    TodoItem *item = [self.todoModel objectAtIndex:indexPath.row];
    cell.textLabel.text = item.content;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
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
