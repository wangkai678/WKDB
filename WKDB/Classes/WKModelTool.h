//
//  WKModelTool.h
//  Pods
//
//  Created by wangkai on 2017/10/11.
//
//

#import <Foundation/Foundation.h>

@interface WKModelTool : NSObject

+ (NSString *)tableName:(Class)cls;

//所有成员变量以及对应的类型
+ (NSDictionary *)classIvarNameTypeDic:(Class)cls;

//所有的成员变量以及成员变量映射到数据库里面对应的类型
+ (NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls;

+ (NSString *)columnNamesAndTypesStr:(Class)cls;


@end
