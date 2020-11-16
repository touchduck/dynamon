//
//  CDynamoTable.h
//  CDynamoDB
//
//  Created by Touch Duck on 2016/01/19.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoType.h"
#import "CDynamoKeySchema.h"

#import "CDynamoLocalSecondaryIndex.h"
#import "CDynamoGlobalSecondaryIndex.h"

#import "CDynamoHeader.h"
#import "CDynamoItem.h"

@interface CDynamoTable : NSObject

@property(nonatomic, strong) NSString *tableName;

@property(nonatomic, strong) CDynamoKeySchemas *keySchemas;

@property(nonatomic, strong) CDynamoLocalSecondaryIndexes *localSecondaryIndexes;
@property(nonatomic, strong) CDynamoGlobalSecondaryIndexs *globalSecondaryIndexes;

@property(nonatomic, strong) CDynamoHeaders *headers;
@property(nonatomic, strong) NSMutableArray<CDynamoItems *> *items;

- (void)setDescribeTable:(void *)describeTable;

- (void)addHeader:(CDynamoHeader *)header;

- (BOOL)isExistHeader:(NSString *)attributeName;

- (CDynamoScalarAttributeType)findAttributeType:(NSString *)attributeName;

- (NSString *)findAttributeTypeToString:(NSString *)attributeName;

@end
