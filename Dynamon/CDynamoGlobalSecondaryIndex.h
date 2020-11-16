//
//  CDynamoGlobalSecondaryIndexe.h
//  Rabbit
//
//  Created by Touch Duck on 2016/06/12.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoKeySchema.h"

@interface CDynamoGlobalSecondaryIndex : NSObject

@property(nonatomic, strong) NSString *indexName;
@property(nonatomic, strong) NSString *indexArn;

@property(nonatomic, strong) NSMutableArray<CDynamoKeySchema *> *keySchemas;

@end

typedef NSMutableArray<CDynamoGlobalSecondaryIndex *> CDynamoGlobalSecondaryIndexs;
