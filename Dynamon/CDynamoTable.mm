//
//  CDynamoTable.m
//  CDynamoDB
//
//  Created by Touch Duck on 2016/01/19.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoTable.h"

#include <aws/core/Aws.h>
#include <aws/dynamodb/DynamoDBClient.h>

using namespace Aws::Auth;
using namespace Aws::Http;
using namespace Aws::Client;
using namespace Aws::DynamoDB;
using namespace Aws::DynamoDB::Model;

@implementation CDynamoTable {
    TableDescription *awsDescribeTable;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _tableName = [NSMutableString new];
        _keySchemas = [NSMutableArray new];
        _localSecondaryIndexes = [NSMutableArray new];
        _globalSecondaryIndexes = [NSMutableArray new];
        _headers = [NSMutableArray new];
        _items = [NSMutableArray new];
    }
    return self;
}

- (void)setDescribeTable:(void *)describeTable {

    [_keySchemas removeAllObjects];

    awsDescribeTable = (TableDescription *) describeTable;

    for (auto keySchema: awsDescribeTable->GetKeySchema()) {

        CDynamoKeySchema *newKey = [CDynamoKeySchema new];
        NSString *attributeName = CSTR_TO_STR(keySchema.GetAttributeName());
        newKey.attributeName = attributeName;

        switch (keySchema.GetKeyType()) {
            case Aws::DynamoDB::Model::KeyType::NOT_SET:
                newKey.keyType = CDynamoKeyType_NOT_SET;
                break;

            case Aws::DynamoDB::Model::KeyType::HASH:
                newKey.keyType = CDynamoKeyType_HASH;
                break;

            case Aws::DynamoDB::Model::KeyType::RANGE:
                newKey.keyType = CDynamoKeyType_RANGE;
                break;

            default:
                break;
        }

        CDynamoScalarAttributeType attrubutedType = [self findAttributeType:attributeName];
        [newKey setScalarAttributeType:attrubutedType];
        [self.keySchemas addObject:newKey];
    }

    [self makeLocalSecondaryIndexes];
    [self makeGlobalSecondaryIndexes];
}

- (BOOL)isExistHeader:(NSString *)attributeName {
    for (CDynamoHeader *header in _headers) {
        if ([header.attributeName isEqualToString:attributeName]) {
            return YES;
        }
    }
    return NO;
}

- (void)addHeader:(CDynamoHeader *)header {
    if (![self isExistHeader:header.attributeName]) {
        [_headers addObject:header];
    }
}

- (void)makeLocalSecondaryIndexes {

    [_localSecondaryIndexes removeAllObjects];

    auto secondaryIndexes = awsDescribeTable->GetLocalSecondaryIndexes();

    for (auto secondaryIndex: secondaryIndexes) {

        CDynamoLocalSecondaryIndex *newIndex = [CDynamoLocalSecondaryIndex new];

        NSString *indexName = CSTR_TO_STR(secondaryIndex.GetIndexName());
        [newIndex setIndexName:indexName];

        NSString *indexArn = CSTR_TO_STR(secondaryIndex.GetIndexArn());
        [newIndex setIndexArn:indexArn];

        for (auto schema: secondaryIndex.GetKeySchema()) {

            CDynamoKeySchema *newKey = [CDynamoKeySchema new];

            NSString *attrName = CSTR_TO_STR(schema.GetAttributeName());
            [newKey setAttributeName:attrName];

            switch (schema.GetKeyType()) {
                case Aws::DynamoDB::Model::KeyType::HASH:
                    [newKey setKeyType:CDynamoKeyType_HASH];
                    break;
                case Aws::DynamoDB::Model::KeyType::RANGE:
                    [newKey setKeyType:CDynamoKeyType_RANGE];
                    break;
                default:
                    [newKey setKeyType:CDynamoKeyType_NOT_SET];
                    break;
            }

            CDynamoScalarAttributeType attrubutedType = [self findAttributeType:attrName];
            [newKey setScalarAttributeType:attrubutedType];

            [newIndex.keySchemas addObject:newKey];
        }

        [self.localSecondaryIndexes addObject:newIndex];
    }

}

- (void)makeGlobalSecondaryIndexes {

    [_globalSecondaryIndexes removeAllObjects];

    auto secondaryIndexes = awsDescribeTable->GetGlobalSecondaryIndexes();

    for (auto secondaryIndex: secondaryIndexes) {

        CDynamoGlobalSecondaryIndex *newIndex = [CDynamoGlobalSecondaryIndex new];

        NSString *indexName = CSTR_TO_STR(secondaryIndex.GetIndexName());
        [newIndex setIndexName:indexName];

        NSString *indexArn = CSTR_TO_STR(secondaryIndex.GetIndexArn());
        [newIndex setIndexArn:indexArn];

        for (auto schema: secondaryIndex.GetKeySchema()) {

            CDynamoKeySchema *newKey = [CDynamoKeySchema new];

            NSString *attrName = CSTR_TO_STR(schema.GetAttributeName());
            [newKey setAttributeName:attrName];

            switch (schema.GetKeyType()) {
                case Aws::DynamoDB::Model::KeyType::HASH:
                    [newKey setKeyType:CDynamoKeyType_HASH];
                    break;
                case Aws::DynamoDB::Model::KeyType::RANGE:
                    [newKey setKeyType:CDynamoKeyType_RANGE];
                    break;
                default:
                    [newKey setKeyType:CDynamoKeyType_NOT_SET];
                    break;
            }

            CDynamoScalarAttributeType attrubutedType = [self findAttributeType:attrName];
            [newKey setScalarAttributeType:attrubutedType];

            [newIndex.keySchemas addObject:newKey];
        }

        [self.globalSecondaryIndexes addObject:newIndex];
    }

}

- (NSString *)findAttributeTypeToString:(NSString *)attributeName {

    auto attributeType = [self findAttributeType:attributeName];

    switch (attributeType) {
        case CDynamoScalarAttributeType_N:
            return @"N";
        case CDynamoScalarAttributeType_S:
            return @"S";
        case CDynamoScalarAttributeType_B:
            return @"B";
        default:
            break;
    }
    return @"NOT_SET";
}

- (CDynamoScalarAttributeType)findAttributeType:(NSString *)attributeName {

    for (auto attributeDefinition: awsDescribeTable->GetAttributeDefinitions()) {

        NSString *attrName = CSTR_TO_STR(attributeDefinition.GetAttributeName());

        if (![attributeName isEqualToString:attrName]) {
            continue;
        }

        switch (attributeDefinition.GetAttributeType()) {
            case Aws::DynamoDB::Model::ScalarAttributeType::N:
                return CDynamoScalarAttributeType_N;
            case Aws::DynamoDB::Model::ScalarAttributeType::S:
                return CDynamoScalarAttributeType_S;
            case Aws::DynamoDB::Model::ScalarAttributeType::B:
                return CDynamoScalarAttributeType_B;
            default:
                break;
        }
    }

    return CDynamoScalarAttributeType_NOT_SET;
}

- (void)printInfo {

    NSLog(@"%@ (Table)", _tableName);

    for (CDynamoKeySchema *keySchema in self.keySchemas) {
        [keySchema printInfo];
    }

    for (CDynamoLocalSecondaryIndex *lsi in self.localSecondaryIndexes) {
        NSString *text = [NSString stringWithFormat:@"%@ (Local Secondary Index)", lsi.indexName];
        NSLog(@"%@", text);
        for (CDynamoKeySchema *keySchema in lsi.keySchemas) {
            [keySchema printInfo];
        }
    }

    for (CDynamoGlobalSecondaryIndex *gsi in self.globalSecondaryIndexes) {
        NSString *text = [NSString stringWithFormat:@"%@ (Global Secondary Index)", gsi.indexName];
        NSLog(@"%@", text);
        for (CDynamoKeySchema *keySchema in gsi.keySchemas) {
            [keySchema printInfo];
        }
    }

}

@end
