//
//  CDynamoDeleteItemRequest.m
//  Dynamon
//
//  Created by Touch Duck on 2016/10/25.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoDeleteItemRequest.h"

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

@implementation CDynamoDeleteItemRequest

- (void)makeRequest {

    for (NSInteger i = 0; i < 50; i++) {

        DeleteItemRequest request;
        request.WithTableName("userInfo");

        Aws::Map<Aws::String, AttributeValue> value;

        auto email = [[NSString stringWithFormat:@"testman%@@mail.com", @(i)] UTF8String];
        value["email"] = AttributeValue().SetS(email);

        auto userId = [[NSString stringWithFormat:@"%@", @(i)] UTF8String];
        value["userId"] = AttributeValue().SetN(userId);

        request.WithKey(value);

    }


    //return nullptr;
}

@end
