//
//  CDynamoQueryRequest.m
//  Dynamon
//
//  Created by Touch Duck on 2016/10/20.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoQueryRequest.h"

#include <aws/core/Aws.h>
#include <aws/core/utils/HashingUtils.h>

#include <aws/dynamodb/model/QueryRequest.h>
#include <aws/dynamodb/model/AttributeValueValue.h>

using namespace Aws::Utils;
using namespace Aws::Utils::Json;

using namespace Aws::DynamoDB;
using namespace Aws::DynamoDB::Model;

@implementation CDynamoQueryRequest {
    QueryRequest queryRequest;
    Aws::Map<Aws::String, Condition> keyMapping;
    Aws::Map<Aws::String, Condition> filterMapping;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self clear];
    }
    return self;
}

- (void)clear {
    self.tableName = @"";
    self.indexName = @"";
    self.limit = 0;
    self.sleepTime = 0.0f;
    self.isStop = NO;
    keyMapping.clear();
    filterMapping.clear();
}

- (void *)makeRequest {
    queryRequest.SetKeyConditions(keyMapping);
    queryRequest.SetQueryFilter(filterMapping);
    return &queryRequest;
}

- (void)config {

    queryRequest.WithTableName([_tableName UTF8String]);

    if (_limit > 0) {
        queryRequest.WithLimit((int) _limit);
    }

    if (_indexName.length > 0) {
        queryRequest.WithIndexName([_indexName UTF8String]);
    }
}

- (void)setFilter:(CDynamoKeySchema *)keySchema {

    Aws::Vector<AttributeValue> filterValues;

    auto inputValue = [[keySchema inputValue] UTF8String];

    Condition filterCondition;

    switch ([keySchema scalarAttributeType]) {
        case CDynamoScalarAttributeType_N:
            if ([[keySchema inputValue] length] > 0) {
                filterValues.push_back(AttributeValue().SetN(inputValue));
            }
            break;

        case CDynamoScalarAttributeType_S:
            if ([[keySchema inputValue] length] > 0) {
                filterValues.push_back(AttributeValue().SetS(inputValue));
            }
            break;
        case CDynamoScalarAttributeType_B:
            if ([[keySchema inputValue] length] > 0) {
                auto text = [[keySchema inputValue] UTF8String];
                auto buffer = HashingUtils::Base64Decode(text);
                filterValues.push_back(AttributeValue().SetB(buffer));
            }
            break;

        default:
            break;
    }

    filterCondition.SetAttributeValueList(filterValues);

    switch ([keySchema comparisonOperator]) {
        case CDynamoComparisonOperator_EQ:
            filterCondition.SetComparisonOperator(ComparisonOperator::EQ);
            break;
        case CDynamoComparisonOperator_NE:
            filterCondition.SetComparisonOperator(ComparisonOperator::NE);
            break;
        case CDynamoComparisonOperator_IN:
            filterCondition.SetComparisonOperator(ComparisonOperator::IN);
            break;
        case CDynamoComparisonOperator_LE:
            filterCondition.SetComparisonOperator(ComparisonOperator::LE);
            break;
        case CDynamoComparisonOperator_LT:
            filterCondition.SetComparisonOperator(ComparisonOperator::LT);
            break;
        case CDynamoComparisonOperator_GE:
            filterCondition.SetComparisonOperator(ComparisonOperator::GE);
            break;
        case CDynamoComparisonOperator_GT:
            filterCondition.SetComparisonOperator(ComparisonOperator::GT);
            break;
        case CDynamoComparisonOperator_BETWEEN:
            filterCondition.SetComparisonOperator(ComparisonOperator::BETWEEN);
            break;
        case CDynamoComparisonOperator_NOT_NULL:
            filterCondition.SetComparisonOperator(ComparisonOperator::NOT_NULL);
            break;
        case CDynamoComparisonOperator_NULL_:
            filterCondition.SetComparisonOperator(ComparisonOperator::NULL_);
            break;
        case CDynamoComparisonOperator_CONTAINS:
            filterCondition.SetComparisonOperator(ComparisonOperator::CONTAINS);
            break;
        case CDynamoComparisonOperator_NOT_CONTAINS:
            filterCondition.SetComparisonOperator(ComparisonOperator::NOT_CONTAINS);
            break;
        case CDynamoComparisonOperator_BEGINS_WITH:
            filterCondition.SetComparisonOperator(ComparisonOperator::BEGINS_WITH);
            break;
        default:
            filterCondition.SetComparisonOperator(ComparisonOperator::NOT_SET);
            break;
    }

    auto name = [[keySchema attributeName] UTF8String];
    filterMapping[name] = filterCondition;
}

- (void)setHashKey:(CDynamoKeySchema *)keySchema {

    Aws::Vector<AttributeValue> hashValues;

    auto inputValue = [[keySchema inputValue] UTF8String];

    switch ([keySchema scalarAttributeType]) {
        case CDynamoScalarAttributeType_N:
            hashValues.push_back(AttributeValue().SetN(inputValue));
            break;

        case CDynamoScalarAttributeType_S:
            hashValues.push_back(AttributeValue().SetS(inputValue));
            break;

        case CDynamoScalarAttributeType_B: {
            auto text = [[keySchema inputValue] UTF8String];
            auto buffer = HashingUtils::Base64Decode(text);
            hashValues.push_back(AttributeValue().SetB(buffer));
        }
            break;

        default:
            break;
    }

    Condition hashKeyCondition;
    hashKeyCondition.SetAttributeValueList(hashValues);

    switch ([keySchema comparisonOperator]) {
        case CDynamoComparisonOperator_EQ:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::EQ);
            break;
        case CDynamoComparisonOperator_NE:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::NE);
            break;
        case CDynamoComparisonOperator_IN:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::IN);
            break;
        case CDynamoComparisonOperator_LE:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::LE);
            break;
        case CDynamoComparisonOperator_LT:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::LT);
            break;
        case CDynamoComparisonOperator_GE:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::GE);
            break;
        case CDynamoComparisonOperator_GT:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::GT);
            break;
        case CDynamoComparisonOperator_BETWEEN:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::BETWEEN);
            break;
        case CDynamoComparisonOperator_NOT_NULL:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::NOT_NULL);
            break;
        case CDynamoComparisonOperator_NULL_:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::NULL_);
            break;
        case CDynamoComparisonOperator_CONTAINS:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::CONTAINS);
            break;
        case CDynamoComparisonOperator_NOT_CONTAINS:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::NOT_CONTAINS);
            break;
        case CDynamoComparisonOperator_BEGINS_WITH:
            hashKeyCondition.SetComparisonOperator(ComparisonOperator::BEGINS_WITH);
            break;
        default:
            break;
    }

    auto name = [[keySchema attributeName] UTF8String];
    keyMapping[name] = hashKeyCondition;
}

- (void)setRangeKey:(CDynamoKeySchema *)keySchema {
    Aws::Vector<AttributeValue> rangeValues;

    if ([[keySchema inputValue] length] == 0) {
        return;
    }

    auto inputValue = [[keySchema inputValue] UTF8String];

    switch ([keySchema scalarAttributeType]) {
        case CDynamoScalarAttributeType_N:
            rangeValues.push_back(AttributeValue().SetN(inputValue));
            break;

        case CDynamoScalarAttributeType_S:
            rangeValues.push_back(AttributeValue().SetS(inputValue));
            break;

        case CDynamoScalarAttributeType_B: {
            auto text = [[keySchema inputValue] UTF8String];
            auto buffer = HashingUtils::Base64Decode(text);
            rangeValues.push_back(AttributeValue().SetB(buffer));
        }
            break;

        default:
            break;
    }

    Condition rangeKeyCondition;
    rangeKeyCondition.SetAttributeValueList(rangeValues);

    switch ([keySchema comparisonOperator]) {
        case CDynamoComparisonOperator_EQ:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::EQ);
            break;
        case CDynamoComparisonOperator_NE:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::NE);
            break;
        case CDynamoComparisonOperator_IN:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::IN);
            break;
        case CDynamoComparisonOperator_LE:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::LE);
            break;
        case CDynamoComparisonOperator_LT:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::LT);
            break;
        case CDynamoComparisonOperator_GE:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::GE);
            break;
        case CDynamoComparisonOperator_GT:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::GT);
            break;
        case CDynamoComparisonOperator_BETWEEN:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::BETWEEN);
            break;
        case CDynamoComparisonOperator_NOT_NULL:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::NOT_NULL);
            break;
        case CDynamoComparisonOperator_NULL_:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::NULL_);
            break;
        case CDynamoComparisonOperator_CONTAINS:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::CONTAINS);
            break;
        case CDynamoComparisonOperator_NOT_CONTAINS:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::NOT_CONTAINS);
            break;
        case CDynamoComparisonOperator_BEGINS_WITH:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::BEGINS_WITH);
            break;
        default:
            rangeKeyCondition.SetComparisonOperator(ComparisonOperator::NOT_SET);
            break;
    }

    auto name = [[keySchema attributeName] UTF8String];
    keyMapping[name] = rangeKeyCondition;
}

@end
