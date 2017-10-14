//
//  WKViewController.m
//  WKDB
//
//  Created by wangkai_678@163.com on 09/25/2017.
//  Copyright (c) 2017 wangkai_678@163.com. All rights reserved.
//

#import "WKViewController.h"
#import "WKSqliteModelTool.h"
#import "WKStudent.h"

@interface WKViewController ()

@end

@implementation WKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [WKSqliteModelTool createTable:[WKStudent class] uid:@"123456"];
//    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject);
    
    [WKSqliteModelTool updateTable:[WKStudent class] uid:@"123456"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
