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

+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid {
    
    //创建一个拥有正确机构的临时表
    
    NSString *tmpTableName = [WKModelTool tmpTableName:cls];
    NSString *tableName = [WKModelTool tableName:cls];
    
    if (![cls  respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"必须要实现这个方法，提供主键");
        return NO;
    }
    NSMutableArray *execSqls = [NSMutableArray array];
    NSString *primaryKey = [cls primaryKey];
    
    //获取一个模型里面所有的字段，以及类型
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));",tmpTableName,[WKModelTool columnNamesAndTypesStr:cls],primaryKey];
    [execSqls addObject:createTableSql];
    //临时表插入主键数据
    NSString *insertPrimaryKeyData = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;",tmpTableName,primaryKey,primaryKey,tableName];
    [execSqls addObject:insertPrimaryKeyData];

    //根据主键，把所有的数据更新到表里面
    NSArray *oldNames = [WKTableTool tableSortedColumnNames:cls uid:uid];
    NSArray *newNames = [WKModelTool allTableSortedIvarNames:cls];
    for (NSString *columnName in newNames) {
        if (![oldNames containsObject:columnName]) {
            continue;
        }
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)",tmpTableName,columnName,columnName,tableName,tmpTableName,primaryKey,tableName,primaryKey];
        [execSqls addObject:updateSql];
    }
    
    //删除旧表
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@",tableName];
    [execSqls addObject:deleteOldTable];

    //更改新表的名称
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@",tmpTableName,tableName];
    [execSqls addObject:renameTableName];
    
    return [WKSqliteTool dealSqls:execSqls uid:uid];
}

+ (void)saveModel:(id)model {
    
}

@end
