//
//  CDynamoQueryRequest.h
//  Dynamon
//
//  Created by Touch Duck on 2016/10/20.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoType.h"
#import "CDynamoKeySchema.h"

#import "CDynamoLocalSecondaryIndex.h"
#import "CDynamoGlobalSecondaryIndex.h"

#import "CDynamoHeader.h"
#import "CDynamoItem.h"

@interface CDynamoQueryRequest : NSObject

@property(nonatomic, retain) NSString *tableName;
@property(nonatomic, retain) NSString *indexName;
@property(nonatomic, assign) NSInteger limit;
@property(nonatomic, assign) CGFloat sleepTime;
@property(nonatomic, assign) BOOL isStop;

- (void)clear;

- (void)config;

- (void *)makeRequest;

- (void)setFilter:(CDynamoKeySchema *)keySchema;

- (void)setHashKey:(CDynamoKeySchema *)keySchema;

- (void)setRangeKey:(CDynamoKeySchema *)keySchema;

@end
