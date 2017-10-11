//
//  WKModelTool.m
//  Pods
//
//  Created by wangkai on 2017/10/11.
//
//

#import "WKModelTool.h"
#import <objc/runtime.h>

@implementation WKModelTool

+ (NSString *)tableName:(Class)cls {
    return NSStringFromClass(cls);
}

+ (NSDictionary *)classIvarNameTypeDic:(Class)cls {
    
}

@end
