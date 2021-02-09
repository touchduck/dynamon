//
//  CDynamo.h
//  CDynamoDB
//
//  Created by Touch Duck on 2016/01/19.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "CDynamoTable.h"

#import "CDynamoScanRequest.h"
#import "CDynamoQueryRequest.h"

#pragma mark typedef

typedef void (^CDynamoListTablesCompletion)(NSArray *tableNames);

typedef void (^CDynamoDescribeTableCompletion)(CDynamoTable *dynamoTable);

typedef void (^CDynamoScanCompletion)(NSArray<CDynamoHeader *> *headers, NSArray *items);

typedef void (^CDynamoQueryCompletion)(NSArray<CDynamoHeader *> *headers, NSArray *items);

#pragma mark interface

@interface CDynamoClient : NSObject

- (void)setClient:(void *)dynamoDBClient;

- (void)listTables:(CDynamoListTablesCompletion)completion
             faild:(CDynamoError)faild;

- (void)describeTable:(NSString *)tableName
           completion:(CDynamoDescribeTableCompletion)completion
                faild:(CDynamoError)faild;

- (void)scan:(CDynamoScanRequest *)scanRequest
  completion:(CDynamoScanCompletion)completion
       faild:(CDynamoError)faild
         end:(CDynamoEnd)end;

- (void)query:(CDynamoQueryRequest *)queryRequest
   completion:(CDynamoQueryCompletion)completion
        faild:(CDynamoError)faild
          end:(CDynamoEnd)end;

@end
