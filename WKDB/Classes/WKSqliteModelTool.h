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

+ (void)saveModel:(id)model;

@end
