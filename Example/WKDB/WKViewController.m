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
    
//    [WKSqliteModelTool updateTable:[WKStudent class] uid:@"123456"];
//    @property (nonatomic, assign) int stuNum;
//    @property (nonatomic, copy) NSString *name;
//    @property (nonatomic, assign) int age;
//    @property (nonatomic, assign) float score;
//    @property (nonatomic, assign) float score2;
    WKStudent *s = [[WKStudent alloc] init];
    s.stuNum = 1;
    s.name = @"名字";
    s.age = 16;
    s.score = 100;
    s.score2 = 122;
    [WKSqliteModelTool saveOrUpdateModel:s uid:@"123"] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
