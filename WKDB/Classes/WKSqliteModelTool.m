//
//  WKSqliteModelTool.m
//  Pods
//
//  Created by wangkai on 2017/10/11.
//
//

#import "WKSqliteModelTool.h"
#import "WKModelTool.h"
#import "WKSqliteTool.h"
#import "WKTableTool.h"

@implementation WKSqliteModelTool

+ (BOOL)createTable:(Class)cls uid:(NSString *)uid {
    //创建表格的sql语句拼接出来
    
    //获取表名
    NSString *tableName = [WKModelTool tableName:cls];
    
    if (![cls  respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"必须要实现这个方法，提供主键");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    
//    NSString *dropTableSql = @"drop table if exists WKStudent";
    
    //获取一个模型里面所有的字段，以及类型
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))",tableName,[WKModelTool columnNamesAndTypesStr:cls],primaryKey];
    
    //执行
    return [WKSqliteTool deal:createTableSql uid:uid];
}

+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid {
    NSArray *modelNames = [WKModelTool allTableSortedIvarNames:cls];
    NSArray *tableNames = [WKTableTool tableSortedColumnNames:cls uid:uid];
    return ![modelNames isEqualToArray:tableNames];
}

+ (void)saveModel:(id)model {
    
}

@end
