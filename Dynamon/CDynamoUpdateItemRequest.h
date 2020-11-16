//
//  CDynamoUpdateItemRequest.h
//  Dynamon
//
//  Created by Touch Duck on 2016/10/25.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoType.h"
#import "CDynamoKeySchema.h"
#import "CDynamoItem.h"

@interface CDynamoUpdateItemRequest : NSObject

@property(nonatomic, strong) NSString *tableName;

@property(nonatomic, strong) CDynamoKeySchemas *keys;
@property(nonatomic, strong) CDynamoItems *items;

- (void)makeRequest;

@end
