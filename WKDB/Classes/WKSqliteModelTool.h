//
//  WKSqliteModelTool.h
//  Pods
//
//  Created by wangkai on 2017/10/11.
//
//

#import <Foundation/Foundation.h>
#import "WKModelProtocol.h"

@interface WKSqliteModelTool : NSObject

+ (BOOL)createTable:(Class)cls uid:(NSString *)uid;

//数据库表是否需要更新
+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;

+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid;

+ (void)saveModel:(id)model;


@end
