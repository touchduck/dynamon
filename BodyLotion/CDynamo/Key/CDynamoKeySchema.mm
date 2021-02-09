//
//  CDynamoIndex.m
//  Rabbit
//
//  Created by Touch Duck on 2016/06/10.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoKeySchema.h"

@implementation CDynamoKeySchema

- (instancetype)init {
    self = [super init];
    if (self) {
        _attributeName = @"";
        _keyType = CDynamoKeyType_NOT_SET;
        _scalarAttributeType = CDynamoScalarAttributeType_NOT_SET;

        _inputValue = @"";
        _comparisonOperator = CDynamoComparisonOperator_NOT_SET;
    }
    return self;
}

- (NSString *)keyTypeToString {
    switch (_scalarAttributeType) {

        case CDynamoKeyType_NOT_SET:
            return @"NOT_SET";
            break;

        case CDynamoKeyType_HASH:
            return @"Hash";
            break;

        case CDynamoKeyType_RANGE:
            return @"Range";
            break;
        default:
            break;
    }

    return @"ERROR";
}

- (NSString *)scalarAttributeTypeToString {

    switch (_scalarAttributeType) {

        case CDynamoScalarAttributeType_NOT_SET:
            return @"NOT_SET";
            break;

        case CDynamoScalarAttributeType_N:
            return @"N";
            break;

        case CDynamoScalarAttributeType_S:
            return @"S";
            break;

        case CDynamoScalarAttributeType_B:
            return @"B";
            break;
        default:
            break;
    }

    return @"ERROR";
}

- (void)printInfo {
    NSString *text = [NSString stringWithFormat:@"%@:%@(%@)",
                                                [self keyTypeToString],
                                                _attributeName,
                                                [self scalarAttributeTypeToString]];
    NSLog(@"%@", text);
}


@end
