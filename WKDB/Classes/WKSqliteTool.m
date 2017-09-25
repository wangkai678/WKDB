//
//  WKSqliteTool.m
//  Pods
//
//  Created by 王凯 on 17/9/25.
//
//

#import "WKSqliteTool.h"
#import "sqlite3.h"

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject


@implementation WKSqliteTool

+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid {
    NSString *dbName = @"common.sqlite";
    if (uid.length != 0) {
        dbName = [NSString stringWithFormat:@"%@.sqlite",uid];
    }
    
    NSString * dbPath = [kCachePath stringByAppendingPathComponent:dbName];
    
    //打开一个数据库没有救打开
    sqlite3 *ppDb = nil;
    if (sqlite3_open(dbPath.UTF8String, &ppDb) != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    //执行语句
    BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    
    //关闭数据库
    sqlite3_close(ppDb);
    return result;
}

@end
