//
//  WKStudent.h
//  WKDB
//
//  Created by 王凯 on 17/10/13.
//  Copyright © 2017年 wangkai_678@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKModelProtocol.h"

@interface WKStudent : NSObject<WKModelProtocol>
{
    int b;
}

@property (nonatomic, assign) int stuNum;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) float score;
@property (nonatomic, assign) float score2;

@end
