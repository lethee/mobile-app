//
//  Ch4ViewController.m
//  Ch4TableView
//
//  Created by Sean Lee on 13. 10. 29..
//  Copyright (c) 2013년 Sean Lee. All rights reserved.
//

#import "Ch4ViewController.h"
#import "Ch4DataSource.h"

@interface Ch4ViewController ()

@end

@implementation Ch4ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableArray *weekArray = [NSMutableArray array];
    [weekArray addObject:@"월요일"];
    [weekArray addObject:@"화요일"];
    [weekArray addObject:@"수요일"];
    [weekArray addObject:@"목요일"];
    [weekArray addObject:@"금요일"];
    [weekArray addObject:@"토요일"];
    [weekArray addObject:@"일요일"];
    
    Ch4DataSource *dataSource = [[Ch4DataSource alloc] init];
    [dataSource setArrayModel:weekArray];
    
    [self setDataSource:dataSource];
    [self.tableView setDataSource:self.dataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
