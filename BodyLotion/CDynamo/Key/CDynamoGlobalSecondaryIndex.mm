//
//  CDynamoIndex.m
//  Rabbit
//
//  Created by Touch Duck on 2016/06/10.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoGlobalSecondaryIndex.h"

@implementation CDynamoGlobalSecondaryIndex

- (instancetype)init {
    self = [super init];
    if (self) {
        _indexName = @"";
        _indexArn = @"";
        _keySchemas = [NSMutableArray new];
    }
    return self;
}

@end
