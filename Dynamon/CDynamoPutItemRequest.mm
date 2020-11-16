//
//  CDynamoPutItemRequest.m
//  Dynamon
//
//  Created by Touch Duck on 2016/10/25.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoPutItemRequest.h"

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

@implementation CDynamoPutItemRequest

- (void)makeRequest {

    PutItemRequest request;

    auto tablename = [self.tableName UTF8String];
    request.WithTableName(tablename);

    Aws::Map<Aws::String, AttributeValue> values;

    for (id item in self.items) {
        auto itemName = [[item name] UTF8String];
        auto itemValue = [[item stringValue] UTF8String];
        values[itemName] = AttributeValue().SetS(itemValue);;
    }

    //return &request;
}

@end
