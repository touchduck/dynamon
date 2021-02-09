//
//  CDynamoColumn.m
//  CDynamoDB
//
//  Created by Touch Duck on 2016/01/19.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoHeader.h"

@implementation CDynamoHeader

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setAttributeName:(NSString *)attributeName {
    _attributeName = attributeName;
    _headerName = [[self class] makeHeaderWithAttributeName:_attributeName withAttributeType:_attributeType];
}

+ (NSString *)makeHeaderWithAttributeName:(NSString *)attributeName withAttributeType:(CDynamoItemType)attributeType {

    NSString *name = @"";

    switch (attributeType) {
        case CDynamoItemTypeB:
            name = [NSString stringWithFormat:@"%@ %@", attributeName, @"[B]"];
            break;
        case CDynamoItemTypeBool:
            name = [NSString stringWithFormat:@"%@ %@", attributeName, @"[BOOL]"];
            break;
        case CDynamoItemTypeBS:
            name = [NSString stringWithFormat:@"%@ %@", attributeName, @"[BS]"];
            break;
        case CDynamoItemTypeL:
            name = [NSString stringWithFormat:@"%@ %@", attributeName, @"[L]"];
            break;
        case CDynamoItemTypeM:
            name = [NSString stringWithFormat:@"%@ %@", attributeName, @"[M]"];
            break;
        case CDynamoItemTypeN:
            name = [NSString stringWithFormat:@"%@ %@", attributeName, @"[N]"];
            break;
        case CDynamoItemTypeNS:
            name = [NSString stringWithFormat:@"%@ %@", attributeName, @"[NS]"];
            break;
        case CDynamoItemTypeNull:
            name = [NSString stringWithFormat:@"%@ %@", attributeName, @"[NULL]"];
            break;
        case CDynamoItemTypeS:
            name = [NSString stringWithFormat:@"%@ %@", attributeName, @"[S]"];
            break;
        case CDynamoItemTypeSS:
            name = [NSString stringWithFormat:@"%@ %@", attributeName, @"[SS]"];
            break;
        default:
            break;
    }

    return name;
}

@end
