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
+ (NSString *)primaryKey;

@optional
+ (NSArray *)ignoreColumnNames;
@end
