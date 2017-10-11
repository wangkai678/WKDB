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

+ (NSDictionary *)classIvarNameTypeDic:(Class)cls;

@end
