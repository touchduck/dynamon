//
//  CDynamoScanRequest.m
//  Dynamon
//
//  Created by Touch Duck on 2016/10/20.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoScanRequest.h"

#include <aws/core/Aws.h>
#include <aws/dynamodb/model/ScanRequest.h>
#include <aws/dynamodb/model/AttributeValueValue.h>
#include <aws/core/utils/HashingUtils.h>

using namespace Aws::Utils;
using namespace Aws::Utils::Json;

using namespace Aws::DynamoDB;
using namespace Aws::DynamoDB::Model;

@implementation CDynamoScanRequest {
    ScanRequest scanSequest;
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
    filterMapping.clear();
}

- (void *)makeRequest {
    scanSequest.SetScanFilter(filterMapping);
    return &scanSequest;
}

- (void)config {

    scanSequest.WithTableName([_tableName UTF8String]);

    if (_limit >= 0) {
        scanSequest.WithLimit((int) _limit);
    }

    if (_indexName.length > 0) {
        scanSequest.WithIndexName([_indexName UTF8String]);
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

@end
