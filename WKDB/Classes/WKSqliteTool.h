//
//  WKSqliteTool.h
//  Pods
//
//  Created by 王凯 on 17/9/25.
//
//

#import <Foundation/Foundation.h>

@interface WKSqliteTool : NSObject

+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid;

+ (NSMutableArray<NSMutableDictionary *>*)querySql:(NSString *)sql uid:(NSString *)uid;
@end
