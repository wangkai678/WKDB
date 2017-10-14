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
sqlite3 *ppDb = nil;

+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid {
    
    //打开数据库
    if (![self openDB:uid]) {
        NSLog(@"打开失败");
        return NO;
    }
    
    //执行语句
    BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    
    //关闭数据库
    [self closeDB];
    return result;
}

+ (NSMutableArray<NSMutableDictionary *>*)querySql:(NSString *)sql uid:(NSString *)uid {
    [self openDB:uid];
    
    //准备语句
    //参数1:一个已经打开的数据库
    //参数2:需要执行的sql
    //参数3:参数2取出多少子节的长度，－1自动计算 \0
    //参数4准备语句
    //参数5:通过参数3，取出参数2的长度子节之后，剩下的字符串
    sqlite3_stmt *ppStmt = nil;
    if (sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        NSLog(@"准备语句编译失败");
        return nil;
    }
    
    //绑定数据
    
    //执行
    NSMutableArray *rowDicArray = [NSMutableArray array];
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        //获取所有列的个数
        int columnCount = sqlite3_column_count(ppStmt);
        NSMutableDictionary *rowDic = [NSMutableDictionary dictionary];
        [rowDicArray addObject:rowDic];
        //遍历所有的列
        for (int i = 0; i < columnCount; i++) {
            //获取列名
           const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            
            //获取列的类型
            //获取列值，不同的类型使用不同的函数进行获取

            int type = sqlite3_column_type(ppStmt, i);
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = @"";
                    break;
                case SQLITE3_TEXT:
                    value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(ppStmt, i)];
                    break;
                    
                default:
                    break;
            }
            [rowDic setValue:value forKey:columnName];
        }
    }
    
    //重置
    
    //释放资源
    sqlite3_finalize(ppStmt);
    
    [self closeDB];
    
    return rowDicArray;
}

+ (BOOL)dealSqls:(NSArray<NSString *>*)sqls uid:(NSString *)uid {
    [self beginTransaction:uid];
    for (NSString *sql in sqls) {
        BOOL result = [self deal:sql uid:uid];
        if (result == NO) {
            [self rollBackTransaction:uid];
            return NO;
        }
    }
    [self commitTransaction:uid];
    return YES;
}

//开始事务
+ (void)beginTransaction:(NSString *)uid {
    [self deal:@"begin transaction" uid:uid];
}

//提交事务
+ (void)commitTransaction:(NSString *)uid {
    [self deal:@"commit transaction" uid:uid];
}

//回滚事务
+ (void)rollBackTransaction:(NSString *)uid {
    [self deal:@"rollback transaction" uid:uid];
}

#pragma mark - 私有方法
+ (BOOL)openDB:(NSString *)uid {
    NSString *dbName = @"common.sqlite";
    if (uid.length != 0) {
        dbName = [NSString stringWithFormat:@"%@.sqlite",uid];
    }
    
    NSString * dbPath = [kCachePath stringByAppendingPathComponent:dbName];
    
    //打开一个数据库没有就创建
   return sqlite3_open(dbPath.UTF8String, &ppDb) == SQLITE_OK;
}

+ (void)closeDB {
    //关闭数据库
    sqlite3_close(ppDb);
}



@end
