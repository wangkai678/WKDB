//
//  WKStudent.m
//  WKDB
//
//  Created by 王凯 on 17/10/13.
//  Copyright © 2017年 wangkai_678@163.com. All rights reserved.
//

#import "WKStudent.h"

@implementation WKStudent

+ (NSString *)primaryKey {
    return @"stuNum";
}


+ (NSArray *)ignoreColumnNames {
    return @[@"b",@"score2"];
}

@end
