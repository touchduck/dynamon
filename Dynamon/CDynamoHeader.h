//
//  CDynamoColumn.h
//  CDynamoDB
//
//  Created by Touch Duck on 2016/01/19.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoType.h"

@interface CDynamoHeader : NSObject

@property(nonatomic, assign) CDynamoItemType attributeType;

@property(nonatomic, strong) NSString *attributeName;

@property(nonatomic, strong) NSString *headerName;

+ (NSString *)makeHeaderWithAttributeName:(NSString *)attributeName withAttributeType:(CDynamoItemType)attributeType;

@end

typedef NSMutableArray<CDynamoHeader *> CDynamoHeaders;
