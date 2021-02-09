//
//  CDynamo.m
//  CDynamoDB
//
//  Created by Touch Duck on 2016/01/19.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoClient.h"

#include <aws/core/Aws.h>

#include <aws/core/utils/Outcome.h>

#include <aws/dynamodb/DynamoDBClient.h>

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
using namespace Aws::DynamoDB;
using namespace Aws::DynamoDB::Model;

typedef std::map<std::string, CDynamoItemType> HeaderMap;

Aws::String error(Aws::Client::AWSError<Aws::DynamoDB::DynamoDBErrors> error) {
    NSString *exceptionName = CSTR_TO_STR(error.GetExceptionName());
    NSLog(@"%@", exceptionName);
    NSString *message = CSTR_TO_STR(error.GetMessage());
    NSLog(@"%@", message);
    return error.GetMessage();
}

@implementation CDynamoClient {
    std::shared_ptr<DynamoDBClient> client;
}

- (void)initialization {
    client = nullptr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)setClient:(void *)dynamoDBClient {
    client = *(std::shared_ptr<DynamoDBClient> *) dynamoDBClient;
}

- (void)listTables:(CDynamoListTablesCompletion)completion faild:(CDynamoError)faild {

    NSMutableArray<NSString *> *tableNames = [NSMutableArray new];

    ListTablesRequest request;
    ListTablesOutcome outcome = client->ListTables(request);

    if (!outcome.IsSuccess()) {
        auto message = error(outcome.GetError());
        if (faild) faild(CSTR_TO_STR(message));
        return;
    }

    auto result = outcome.GetResult();

    for (auto strTableName: result.GetTableNames()) {
        [tableNames addObject:CSTR_TO_STR(strTableName)];
    }

    if (completion) completion(tableNames);

    //[self dropTableSample];
    //[self cerateTableTestWithFaild:nil];
    //[self sampleData];
    //[self updateData];
    //[self deleteData];
}

- (void)describeTable:(NSString *)tableName completion:(CDynamoDescribeTableCompletion)completion faild:(CDynamoError)faild {

    Aws::String strTableName = [tableName UTF8String];

    CDynamoTable *dynamoTable = [CDynamoTable new];
    [dynamoTable setTableName:tableName];

    DescribeTableRequest request;
    request.SetTableName(strTableName);

    DescribeTableOutcome outcome = client->DescribeTable(request);

    if (!outcome.IsSuccess()) {
        auto message = error(outcome.GetError());
        if (faild) faild(CSTR_TO_STR(message));
        return;
    }

    if (outcome.GetResult().GetTable().GetTableStatus() == TableStatus::ACTIVE) {
        TableDescription table = outcome.GetResult().GetTable();
        [dynamoTable setDescribeTable:&table];
        if (completion) completion(dynamoTable);
    }

}

- (void)scan:(CDynamoScanRequest *)scanRequest completion:(CDynamoScanCompletion)completion faild:(CDynamoError)faild end:(CDynamoEnd)end {

    ScanRequest request = *(ScanRequest *) [scanRequest makeRequest];

    Aws::Map<Aws::String, AttributeValue> exclusiveStartKey;

    HeaderMap headerMap;

    BOOL canUseSleep = NO;

    do {

        if ([scanRequest sleepTime] > 0.0f && canUseSleep) {
            [NSThread sleepForTimeInterval:[scanRequest sleepTime]];
        }
        canUseSleep = YES;

        if ([scanRequest isStop]) {
            NSLog(@"scan break");
            if (end) end();
            break;
        }

        ScanOutcome outcome = client->Scan(request);

        if (!outcome.IsSuccess()) {
            auto message = error(outcome.GetError());
            if (faild) faild(CSTR_TO_STR(message));
            if (end) end();
            return;
        }

        NSMutableArray *scanItems = [NSMutableArray new];

        for (auto items: outcome.GetResult().GetItems()) {
            CDynamoItems *dynamoItems = [CDynamoItems new];
            for (auto item: items) {
                CDynamoItem *dynamoItem = [CDynamoItem initWithAttributeValue:&item.second
                                                            withAttributeName:CSTR_TO_STR(item.first)];
                [dynamoItems addObject:dynamoItem];
                headerMap.insert(HeaderMap::value_type([dynamoItem.attributeName UTF8String], dynamoItem.attributeType));
            }
            [scanItems addObject:dynamoItems];
        }

        if (completion) {
            CDynamoHeaders *dynamoHeaders = [NSMutableArray new];
            for (auto it = headerMap.begin(); it != headerMap.end(); ++it) {
                CDynamoHeader *dynamoHeader = [CDynamoHeader new];
                [dynamoHeader setAttributeType:it->second];
                [dynamoHeader setAttributeName:CSTR_TO_STR(it->first)];
                [dynamoHeaders addObject:dynamoHeader];
            }
            completion(dynamoHeaders, scanItems);
        }

        exclusiveStartKey = outcome.GetResult().GetLastEvaluatedKey();
        request.WithExclusiveStartKey(exclusiveStartKey);

    } while (exclusiveStartKey.size() > 0);

    if (end) end();
}


- (void)query:(CDynamoQueryRequest *)queryRequest completion:(CDynamoQueryCompletion)completion faild:(CDynamoError)faild end:(CDynamoEnd)end {

    QueryRequest request = *(QueryRequest *) [queryRequest makeRequest];

    Aws::Map<Aws::String, AttributeValue> exclusiveStartKey;

    HeaderMap headerMap;

    BOOL canUseSleep = NO;

    do {

        if ([queryRequest sleepTime] > 0.0f && canUseSleep) {
            [NSThread sleepForTimeInterval:[queryRequest sleepTime]];
        }
        canUseSleep = YES;

        if ([queryRequest isStop]) {
            NSLog(@"query break");
            if (end) end();
            break;
        }

        QueryOutcome outcome = client->Query(request);

        if (!outcome.IsSuccess()) {
            auto message = error(outcome.GetError());
            if (faild) faild(CSTR_TO_STR(message));
            if (end) end();
            return;
        }

        NSMutableArray *queryItems = [NSMutableArray new];

        for (auto items: outcome.GetResult().GetItems()) {
            CDynamoItems *dynamoItems = [CDynamoItems new];
            for (auto item: items) {
                CDynamoItem *dynamoItem = [CDynamoItem initWithAttributeValue:&item.second
                                                            withAttributeName:CSTR_TO_STR(item.first)];
                [dynamoItems addObject:dynamoItem];
                headerMap.insert(HeaderMap::value_type([dynamoItem.attributeName UTF8String], dynamoItem.attributeType));
            }
            [queryItems addObject:dynamoItems];
        }

        if (completion) {
            CDynamoHeaders *dynamoHeaders = [NSMutableArray new];
            for (auto it = headerMap.begin(); it != headerMap.end(); ++it) {
                CDynamoHeader *dynamoHeader = [CDynamoHeader new];
                [dynamoHeader setAttributeType:it->second];
                [dynamoHeader setAttributeName:CSTR_TO_STR(it->first)];
                [dynamoHeaders addObject:dynamoHeader];
            }
            completion(dynamoHeaders, queryItems);
        }

        exclusiveStartKey = outcome.GetResult().GetLastEvaluatedKey();
        request.WithExclusiveStartKey(exclusiveStartKey);

    } while (exclusiveStartKey.size() > 0);

    if (end) end();
}

@end

