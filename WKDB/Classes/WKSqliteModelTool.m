//
//  WKSqliteModelTool.m
//  Pods
//
//  Created by wangkai on 2017/10/11.
//
//

#import "WKSqliteModelTool.h"
#import "WKModelTool.h"

@implementation WKSqliteModelTool

+ (void)createTable:(Class)cls uid:(NSString *)uid {
    //创建表格的sql语句拼接出来
    
    //获取表名
    NSString *tableName = [WKModelTool tableName:cls];
    
    //获取一个模型里面所有的字段，以及类型
    
}

+ (void)saveModel:(id)model {
    
}

@end
