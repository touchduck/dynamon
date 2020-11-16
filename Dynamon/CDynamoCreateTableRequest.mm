//
//  CDynamoCreateTableRequest.m
//  Dynamon
//
//  Created by Touch Duck on 2016/10/25.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoCreateTableRequest.h"

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

@implementation CDynamoCreateTableRequest

- (void)makeRequest {

    Aws::String tableName = "userInfo";

    Aws::String partitionKeyName = "email";

    Aws::String sortKeyName = "userId";

    long readCapacityUnits = 1;
    long writeCapacityUnits = 1;
    bool canUseLocalIndex = true;

    Aws::Vector<KeySchemaElement> keySchema;

    KeySchemaElement keySchemaElement;
    keySchemaElement.WithAttributeName(partitionKeyName).WithKeyType(KeyType::HASH);
    keySchema.push_back(keySchemaElement);

    Aws::Vector<AttributeDefinition> attributeDefinitions;

    AttributeDefinition attributeDefinition;
    attributeDefinition.WithAttributeName(partitionKeyName);
    attributeDefinition.WithAttributeType(ScalarAttributeType::S);
    attributeDefinitions.push_back(attributeDefinition);

    KeySchemaElement keySchemaElement2;
    keySchemaElement2.WithAttributeName(sortKeyName).WithKeyType(KeyType::RANGE);
    keySchema.push_back(keySchemaElement2);

    if (sortKeyName.size() > 0) {
        AttributeDefinition attributeDefinition2;
        attributeDefinition2.WithAttributeName(sortKeyName);
        attributeDefinition2.WithAttributeType(ScalarAttributeType::N);
        attributeDefinitions.push_back(attributeDefinition2);
    }

    CreateTableRequest request;
    request.WithTableName(tableName);
    request.WithKeySchema(keySchema);

    ProvisionedThroughput provisionedThroughput;
    provisionedThroughput.WithReadCapacityUnits(readCapacityUnits);
    provisionedThroughput.WithWriteCapacityUnits(writeCapacityUnits);
    request.WithProvisionedThroughput(provisionedThroughput);


    if (canUseLocalIndex) {

        Aws::Vector<LocalSecondaryIndex> localSecondaryIndexes;

        LocalSecondaryIndex localSecondaryIndex;
        localSecondaryIndex.WithIndexName("email-index-userId");

        Aws::Vector<KeySchemaElement> keySchema;

        keySchema.push_back(KeySchemaElement().WithAttributeName(partitionKeyName).WithKeyType(KeyType::HASH));
        keySchema.push_back(KeySchemaElement().WithAttributeName(sortKeyName).WithKeyType(KeyType::RANGE));

        localSecondaryIndex.WithKeySchema(keySchema);

        localSecondaryIndex.WithProjection(Projection().WithProjectionType(ProjectionType::ALL));
        localSecondaryIndexes.push_back(localSecondaryIndex);

        request.SetLocalSecondaryIndexes(localSecondaryIndexes);
    }

    request.SetAttributeDefinitions(attributeDefinitions);


//    auto tableDescription = result.GetTableDescription();
//    
//    auto tableStatus = tableDescription.GetTableStatus();
//    switch (tableStatus) {
//        case TableStatus::CREATING:
//            break;
//        case TableStatus::UPDATING:
//            break;
//        case TableStatus::DELETING:
//            break;
//        case TableStatus::ACTIVE:
//            break;
//        default:
//            break;
//    }

    // return nullptr;

}

@end
