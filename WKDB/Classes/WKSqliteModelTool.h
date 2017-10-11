//
//  WKSqliteModelTool.h
//  Pods
//
//  Created by wangkai on 2017/10/11.
//
//

#import <Foundation/Foundation.h>

@interface WKSqliteModelTool : NSObject

+ (void)createTable:(Class)cls uid:(NSString *)uid;

+ (void)saveModel:(id)model;

@end
