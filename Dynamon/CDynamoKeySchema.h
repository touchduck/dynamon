//
//  CDynamoIndex.h
//  Rabbit
//
//  Created by Touch Duck on 2016/06/10.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoType.h"

@interface CDynamoKeySchema : NSObject

@property(nonatomic, strong) NSString *attributeName;
@property(nonatomic, assign) CDynamoKeyType keyType;
@property(nonatomic, assign) CDynamoScalarAttributeType scalarAttributeType;

@property(nonatomic, assign) CDynamoComparisonOperator comparisonOperator;
@property(nonatomic, strong) NSString *inputValue;


- (NSString *)keyTypeToString;

- (NSString *)scalarAttributeTypeToString;

- (void)printInfo;

@end

typedef NSMutableArray<CDynamoKeySchema *> CDynamoKeySchemas;
