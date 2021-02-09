//
//  CDynamoItem.h
//  CDynamoDB
//
//  Created by Touch Duck on 2016/01/19.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoType.h"

@interface CDynamoItem : NSObject

@property(nonatomic, assign) CDynamoItemType attributeType;

@property(nonatomic, assign) NSString *attributeTypeString;

@property(nonatomic, strong) NSString *headerName;

@property(nonatomic, strong) NSString *attributeName;

@property(nonatomic, strong, readonly) NSString *stringValue;

@property(nonatomic, strong, readonly) NSString *display;

+ (CDynamoItem *)initWithAttributeValue:(void *)attributeValuePtr withAttributeName:(NSString *)attributeName;

@end

typedef NSMutableArray<CDynamoItem *> CDynamoItems;
