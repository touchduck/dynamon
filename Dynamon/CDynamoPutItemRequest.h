//
//  CDynamoPutItemRequest.h
//  Dynamon
//
//  Created by Touch Duck on 2016/10/25.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoType.h"
#import "CDynamoItem.h"

@interface CDynamoPutItemRequest : NSObject

@property(nonatomic, strong) NSString *tableName;

@property(nonatomic, strong) CDynamoItems *items;

- (void)makeRequest;

@end
