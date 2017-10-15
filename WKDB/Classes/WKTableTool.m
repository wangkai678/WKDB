//
//  WKTableTool.m
//  Pods
//
//  Created by 王凯 on 17/10/13.
//
//

#import "WKTableTool.h"
#import "WKModelTool.h"
#import "WKSqliteTool.h"

@implementation WKTableTool

+ (NSArray *)tableSortedColumnNames:(Class)cls uid:(NSString *)uid {
   
   NSString *tableName = [WKModelTool tableName:cls];
    
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'",tableName];
    NSMutableDictionary *dic = [WKSqliteTool querySql:queryCreateSqlStr uid:uid].firstObject;
    NSString *createTableSql = [dic[@"sql"] lowercaseString];
    if (createTableSql.length == 0) {
        return nil;
    }
    
//    createTableSql = [createTableSql stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\"\n\t"]];这种方法不行
   createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\"" withString:@""];
   createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\n" withString:@""];
   createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSString *nameTypeStr = [createTableSql componentsSeparatedByString:@"("][1];
    NSArray *nameTypeArray = [nameTypeStr componentsSeparatedByString:@","];
    NSMutableArray *names = [NSMutableArray array];
    for (NSString *nameType in nameTypeArray) {
        if ([nameType containsString:@"primary"]) {
            continue;
        }
        NSString *nameTypes2 = [nameType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        NSString *name = [nameTypes2 componentsSeparatedByString:@" "].firstObject;
        [names addObject:name];
    }
    
   [names sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    
    return names;
}

+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid {
    NSString *tableName = [WKModelTool tableName:cls];
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'",tableName];
    NSMutableArray *result = [WKSqliteTool querySql:queryCreateSqlStr uid:uid];
    return result.count > 0;
}

@end
