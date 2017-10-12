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
    
    unsigned int outCount = 0;
    Ivar *varList = class_copyIvarList(cls, &outCount);
    NSMutableDictionary *nameTypeDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = varList[i];
        //成员变量名称
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([ivarName hasPrefix:@"_"]) {
            ivarName = [ivarName substringFromIndex:1];
        }
        
        //成员变量类型
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        //去掉字符里面带
       type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        [nameTypeDic setValue:type forKey:ivarName];
    }
    
    return nameTypeDic;
}

+ (NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls {
    NSMutableDictionary *dic = [[self classIvarNameTypeDic:cls] mutableCopy];
    NSDictionary *typeDic = [self ocTypeToSqliteTypeDic];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"i"]) {
            dic[key] = typeDic[obj];
        }
    }];
    return  dic;
}

+ (NSString *)columnNamesAndTypesStr:(Class)cls {
    NSDictionary *nameTypeDic = [self classIvarNameSqliteTypeDic:cls];
    NSMutableArray *result = [NSMutableArray array];
    [nameTypeDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString * obj, BOOL * _Nonnull stop) {
        [result addObject:[NSString stringWithFormat:@"%@ %@",key,obj]];
    }];
    return [result componentsJoinedByString:@","];
}

#pragma mark - 私有的方法
+ (NSDictionary *)ocTypeToSqliteTypeDic {
    return @{
             @"d" : @"real",//double
             @"f" : @"real",//float
             
             @"i" : @"integer",// int
             @"q" : @"integer",// long
             @"Q" : @"integer",// long long
             @"B" : @"integer",// bool
            
             @"NSData" : @"blob",
             @"NSDictionary" : @"text",
             @"NSMutableDictionary" : @"text",
             @"NSArray" : @"text",
             @"NSMutableArray" : @"text",
             
             @"NSString" : @"text",
             };
}



@end
