//
//  CDynamoItemAttrType.h
//  CDynamoDB
//
//  Created by Touch Duck on 2016/01/19.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    // NOT SET
    CDynamoItemTypeNotSet,
    
    // A Binary data type.
    // Type: Blob
    // Required: No
    CDynamoItemTypeB,
    
    // A Boolean data type.
    // Type: Boolean
    // Required: No
    CDynamoItemTypeBool,
    
    // A Binary Set data type.
    // Type: array of Blobs
    // Required: No
    CDynamoItemTypeBS,
    
    // A List of attribute values.
    // Type: array of AttributeValue objects
    // Required: No
    CDynamoItemTypeL,
    
    // A Map of attribute values.
    // Type: String to AttributeValue object map
    // Required: No
    CDynamoItemTypeM,
    
    // A Number data type.
    // Type: String
    // Required: No
    CDynamoItemTypeN,
    
    // A Number Set data type.
    // Type: array of Strings
    // Required: No
    CDynamoItemTypeNS,
    
    // A Null data type.
    // Type: Boolean
    // Required: No
    CDynamoItemTypeNull,
    
    // A String data type.
    // Type: String
    // Required: No
    CDynamoItemTypeS,
    
    // A String Set data type.
    // Type: array of Strings
    // Required: No
    CDynamoItemTypeSS,
    
} CDynamoItemType;

typedef enum : NSUInteger {
    CDynamoScheme_HTTP,
    CDynamoScheme_HTTPS
} CDynamoScheme;

typedef enum : NSUInteger {
    CDynamoKeyType_NOT_SET,
    CDynamoKeyType_HASH,
    CDynamoKeyType_RANGE,
} CDynamoKeyType;

typedef enum : NSUInteger {
    CDynamoScalarAttributeType_NOT_SET,
    CDynamoScalarAttributeType_S,
    CDynamoScalarAttributeType_N,
    CDynamoScalarAttributeType_B,
} CDynamoScalarAttributeType;

typedef enum : NSUInteger {
    CDynamoComparisonOperator_NOT_SET,
    CDynamoComparisonOperator_EQ,
    CDynamoComparisonOperator_NE,
    CDynamoComparisonOperator_IN, // not using?
    CDynamoComparisonOperator_LE,
    CDynamoComparisonOperator_LT,
    CDynamoComparisonOperator_GE,
    CDynamoComparisonOperator_GT,
    CDynamoComparisonOperator_BETWEEN,
    CDynamoComparisonOperator_NOT_NULL,
    CDynamoComparisonOperator_NULL_,
    CDynamoComparisonOperator_CONTAINS,
    CDynamoComparisonOperator_NOT_CONTAINS,
    CDynamoComparisonOperator_BEGINS_WITH
} CDynamoComparisonOperator;

typedef enum : NSUInteger {
    CDynamoAttributeAction_NOT_SET,
    CDynamoAttributeAction_ADD,
    CDynamoAttributeAction_PUT,
    CDynamoAttributeAction_DELETE_
} CDynamoAttributeAction;

typedef void (^CDynamoError)(NSString *message);

typedef void (^CDynamoEnd)();

@interface CDynamoType : NSObject
@end

#define CSTR_TO_STR(text) [NSString stringWithUTF8String:text.c_str()]
