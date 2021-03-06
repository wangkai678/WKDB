//
//  WKSqliteModelTool.m
//  Pods
//
//  Created by wangkai on 2017/10/11.
//
//

#import "WKSqliteModelTool.h"
#import "WKModelTool.h"
#import "WKSqliteTool.h"
#import "WKTableTool.h"

@implementation WKSqliteModelTool

+ (BOOL)createTable:(Class)cls uid:(NSString *)uid {
    //创建表格的sql语句拼接出来
    
    //获取表名
    NSString *tableName = [WKModelTool tableName:cls];
    
    if (![cls  respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"必须要实现这个方法，提供主键");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    
//    NSString *dropTableSql = @"drop table if exists WKStudent";
    
    //获取一个模型里面所有的字段，以及类型
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))",tableName,[WKModelTool columnNamesAndTypesStr:cls],primaryKey];
    
    //执行
    return [WKSqliteTool deal:createTableSql uid:uid];
}

+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid {
    NSArray *modelNames = [WKModelTool allTableSortedIvarNames:cls];
    NSArray *tableNames = [WKTableTool tableSortedColumnNames:cls uid:uid];
    return ![modelNames isEqualToArray:tableNames];
}

+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid {
    
    //创建一个拥有正确机构的临时表
    
    NSString *tmpTableName = [WKModelTool tmpTableName:cls];
    NSString *tableName = [WKModelTool tableName:cls];
    
    if (![cls  respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"必须要实现这个方法，提供主键");
        return NO;
    }
    NSMutableArray *execSqls = [NSMutableArray array];
    NSString *primaryKey = [cls primaryKey];
    
    //获取一个模型里面所有的字段，以及类型
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));",tmpTableName,[WKModelTool columnNamesAndTypesStr:cls],primaryKey];
    [execSqls addObject:createTableSql];
    //临时表插入主键数据
    NSString *insertPrimaryKeyData = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;",tmpTableName,primaryKey,primaryKey,tableName];
    [execSqls addObject:insertPrimaryKeyData];

    //根据主键，把所有的数据更新到表里面
    NSArray *oldNames = [WKTableTool tableSortedColumnNames:cls uid:uid];
    NSArray *newNames = [WKModelTool allTableSortedIvarNames:cls];
    
    //获取更名的字典
    NSDictionary *newNameToOldNameDic = @{};
    if ([cls respondsToSelector:@selector(newNameToOldNameDic)]) {
        newNameToOldNameDic = [cls newNameToOldNameDic];
    }
    
    for (NSString *columnName in newNames) {
        //更新临时表,当更改模型的成员变量名称的时候
        NSString *oldName = columnName;
        if ([newNameToOldNameDic[columnName] length] != 0) {
            oldName = newNameToOldNameDic[columnName];
        }
        
        if ((![oldNames containsObject:columnName] && ![oldNames containsObject:oldName]) || [columnName isEqualToString:primaryKey]) {
            continue;
        }
        
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)",tmpTableName,columnName,oldName,tableName,tmpTableName,primaryKey,tableName,primaryKey];
        [execSqls addObject:updateSql];
    }
    
    //删除旧表
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@",tableName];
    [execSqls addObject:deleteOldTable];

    //更改新表的名称
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@",tmpTableName,tableName];
    [execSqls addObject:renameTableName];
    
    return [WKSqliteTool dealSqls:execSqls uid:uid];
}

+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid{
   
    //判断表格是否存在，不存在则创建
    Class cls = [model class];
    if (![WKTableTool isTableExists:cls uid:uid]) {
        [self createTable:cls uid:uid];
    }
    
    //检测表格是否需要更新，需要则更新
    if ([self isTableRequiredUpdate:cls uid:uid]) {
        [self updateTable:cls uid:uid];
    }
    
    //判断记录是否存在，如果在则更新，否则插入
    NSString *tableName = [WKModelTool tableName:cls];
    
    if (![cls  respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"必须要实现这个方法，提供主键");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    
    NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",tableName,primaryKey,primaryValue];
    NSArray *result = [WKSqliteTool querySql:checkSql uid:uid];
    
    //获取字段名称数组
    NSArray *columnNames = [WKModelTool classIvarNameTypeDic:cls].allKeys;
    
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *columnName in columnNames) {
        id value = [model valueForKeyPath:columnName];
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //把字典或者数据处理成字符串，保存到数据库里面去
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        [values addObject:value];
    }
    
    NSInteger count = columnNames.count;
    NSMutableArray *setValueArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        NSString *name = columnNames[i];
        id value = values[i];
        NSString *setStr = [NSString stringWithFormat:@"%@='%@'",name,value];
        [setValueArray addObject:setStr];
    }
    
    NSString *execSql = @"";
    if (result.count > 0) {
        //更新
        execSql = [NSString stringWithFormat:@"update %@ set %@ where %@ = '%@'",tableName,[setValueArray componentsJoinedByString:@","],primaryKey,primaryValue];
    } else {
        //插入
        execSql = [NSString stringWithFormat:@"insert into %@(%@) values('%@')",tableName,[columnNames componentsJoinedByString:@","],[values componentsJoinedByString:@"','"]];
    }
    return [WKSqliteTool deal:execSql uid:uid];
}

+ (BOOL)deleteModel:(id)model uid:(NSString *)uid {
    Class cls = [model class];
    NSString *tableName = [WKModelTool tableName:cls];
    
    if (![cls  respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"必须要实现这个方法，提供主键");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];

    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",tableName,primaryKey,primaryValue];
    
    return [WKSqliteTool deal:deleteSql uid:uid];
}

+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid {
    NSString *tableName = [WKModelTool tableName:cls];
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@",tableName];
    if (whereStr.length > 0) {
        deleteSql = [deleteSql stringByAppendingFormat:@" where %@",whereStr];
    }
    return [WKSqliteTool deal:deleteSql uid:uid];
}

+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid {
    NSString *tableName = [WKModelTool tableName:cls];
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ %@ '%@'",tableName,name,self.ColumnNameToValueRelationTypeDic[@(relation)],value];
    return [WKSqliteTool deal:deleteSql uid:uid];
}

+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid  {
    NSString *tableName = [WKModelTool tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",tableName];
    NSArray <NSDictionary *>*results = [WKSqliteTool querySql:sql uid:uid];
    
    return [self parseResults:results withClass:cls];
}

+ (NSArray *)queryModels:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid {
    NSString *tableName = [WKModelTool tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ %@ '%@'",tableName,name,self.ColumnNameToValueRelationTypeDic[@(relation)],value];
    NSArray <NSDictionary *>*results = [WKSqliteTool querySql:sql uid:uid];
    
    return [self parseResults:results withClass:cls];
}

+ (NSArray *)queryModels:(Class)cls withSql:(NSString *)sql uid:(NSString *)uid {
    NSArray <NSDictionary *>*results = [WKSqliteTool querySql:sql uid:uid];
     return [self parseResults:results withClass:cls];
}

+ (NSArray *)parseResults:(NSArray <NSDictionary *>*)results withClass:(Class)cls {
    NSMutableArray *models = [NSMutableArray array];
    
    //属性名称类型
    NSDictionary *nameTypeDic = [WKModelTool classIvarNameTypeDic:cls];
    
    for (NSDictionary *modelDic in results) {
        id model = [[cls alloc] init];
        [models addObject:model];
        [modelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *type = nameTypeDic[key];
            id resultValue = obj;
            if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSDictionary"]) {
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            }else if ([type isEqualToString:@"NSMutableArray"] || [type isEqualToString:@"NSMutableDictionary"]){
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            [model setValue:resultValue forKeyPath:key];
        }];
    }
    return models;
}


+ (NSDictionary *)ColumnNameToValueRelationTypeDic {
    return @{
             @(ColumnNameToValueRelationTypeMore):@">",
              @(ColumnNameToValueRelationTypeLess):@"<",
              @(ColumnNameToValueRelationTypeEqual):@"=",
              @(ColumnNameToValueRelationTypeMoreEqual):@">=",
              @(ColumnNameToValueRelationTypeLessEqual):@"<="
             };
}

@end
