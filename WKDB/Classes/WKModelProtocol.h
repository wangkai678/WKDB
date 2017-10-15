//
//  WKModelProtocol.h
//  Pods
//
//  Created by 王凯 on 17/10/12.
//
//

#import <Foundation/Foundation.h>

@protocol WKModelProtocol <NSObject>

@required
//主键字符串
+ (NSString *)primaryKey;

@optional
//忽略的字段数组
+ (NSArray *)ignoreColumnNames;

//新字段名称
+ (NSDictionary *)newNameToOldNameDic;

@end
