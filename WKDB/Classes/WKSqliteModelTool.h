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

//更新表格
+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid;

//保存或更新表格
+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid;


@end
