//
//  CDynamoUpdateItemRequest.m
//  Dynamon
//
//  Created by Touch Duck on 2016/10/25.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoUpdateItemRequest.h"

#include <aws/core/Aws.h>
#include <aws/core/utils/HashingUtils.h>
#include <aws/dynamodb/model/AttributeValueValue.h>

#include <aws/dynamodb/model/ListTablesRequest.h>
#include <aws/dynamodb/model/DescribeTableRequest.h>

#include <aws/dynamodb/model/CreateTableRequest.h>
#include <aws/dynamodb/model/DeleteTableRequest.h>
#include <aws/dynamodb/model/UpdateTableRequest.h>

#include <aws/dynamodb/model/ScanRequest.h>
#include <aws/dynamodb/model/QueryRequest.h>

#include <aws/dynamodb/model/GetItemRequest.h>
#include <aws/dynamodb/model/PutItemRequest.h>

#include <aws/dynamodb/model/UpdateItemRequest.h>
#include <aws/dynamodb/model/DeleteItemRequest.h>

#include <aws/dynamodb/model/BatchWriteItemRequest.h>
#include <aws/dynamodb/model/BatchGetItemRequest.h>

using namespace Aws::Utils;
using namespace Aws::Utils::Json;

using namespace Aws::DynamoDB;
using namespace Aws::DynamoDB::Model;

@implementation CDynamoUpdateItemRequest

- (void)makeRequest {

    UpdateItemRequest request;

    auto tablename = [self.tableName UTF8String];
    request.WithTableName(tablename);

    Aws::Map<Aws::String, AttributeValue> keys;

    for (CDynamoKeySchema *keySchema in self.keys) {

        auto itemName = [[keySchema attributeName] UTF8String];
        auto itemValue = [[keySchema inputValue] UTF8String];

        AttributeValue attributeValue;

        switch (keySchema.scalarAttributeType) {
            case CDynamoScalarAttributeType_B: {
                auto buffer = HashingUtils::Base64Decode(itemValue);
                attributeValue.SetB(buffer);
            }
                break;

            case CDynamoScalarAttributeType_N:
                attributeValue.SetN(itemValue);
                break;

            case CDynamoScalarAttributeType_S:
                attributeValue.SetS(itemValue);
                break;

            default:
                break;
        }

        keys[itemName] = attributeValue;
    }

    request.WithKey(keys);
    request.WithConditionalOperator(ConditionalOperator::AND);

    Aws::Map<Aws::String, AttributeValueUpdate> values;

    for (id item in self.items) {

        auto itemName = [[item name] UTF8String];
        auto itemValue = [[item stringValue] UTF8String];

        AttributeValueUpdate attributeValueUpdate;

        attributeValueUpdate.SetAction(AttributeAction(AttributeAction::PUT));
        attributeValueUpdate.SetValue(AttributeValue().SetS(itemValue));

        values[itemName] = attributeValueUpdate;
    }

    request.WithAttributeUpdates(values);

    //return &request;
}

@end
