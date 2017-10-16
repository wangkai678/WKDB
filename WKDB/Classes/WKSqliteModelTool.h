//
//  WKSqliteModelTool.h
//  Pods
//
//  Created by wangkai on 2017/10/11.
//
//

#import <Foundation/Foundation.h>
#import "WKModelProtocol.h"

typedef NS_ENUM(NSUInteger, ColumnNameToValueRelationType) {
    ColumnNameToValueRelationTypeMore,
    ColumnNameToValueRelationTypeLess,
    ColumnNameToValueRelationTypeEqual,
    ColumnNameToValueRelationTypeMoreEqual,
    ColumnNameToValueRelationTypeLessEqual,
};

@interface WKSqliteModelTool : NSObject

+ (BOOL)createTable:(Class)cls uid:(NSString *)uid;

//数据库表是否需要更新
+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;

//更新表格
+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid;

//保存或更新表格
+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid;

#pragma mark - 删除
//根据模型删除数据库里面的数据
+ (BOOL)deleteModel:(id)model uid:(NSString *)uid;

//根据条件删除
+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid;

+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

#pragma mark - 查询
+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid;

+ (NSArray *)queryModels:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

+ (NSArray *)queryModels:(Class)cls withSql:(NSString *)sql uid:(NSString *)uid;

@end
