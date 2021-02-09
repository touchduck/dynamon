//
//  CDynamoItem.m
//  CDynamoDB
//
//  Created by Touch Duck on 2016/01/19.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamoItem.h"
#import "CDynamoHeader.h"

#include <aws/core/utils/HashingUtils.h>
#include <aws/core/utils/StringUtils.h>

#include <aws/dynamodb/model/AttributeValueValue.h>
#include <aws/dynamodb/model/UpdateItemRequest.h>

using namespace Aws::Utils;
using namespace Aws::Utils::Json;

using namespace Aws::DynamoDB;
using namespace Aws::DynamoDB::Model;

@implementation CDynamoItem {
    AttributeValue attributeValue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _attributeType = CDynamoItemTypeNotSet;
        _attributeTypeString = @"";
    }
    return self;
}

- (NSString *)display {
    if (_stringValue) {
        return _stringValue;
    }

    auto mapJson = attributeValue.Jsonize().View().GetAllObjects();
    auto it = mapJson.begin();

    switch (self.attributeType) {
        case CDynamoItemTypeB: {
            auto buffer = HashingUtils::Base64Encode(attributeValue.GetB());
            _stringValue = CSTR_TO_STR(buffer);
        }
            break;

        case CDynamoItemTypeBS: {
            NSMutableString *mutableString = [NSMutableString new];
            for (auto it = attributeValue.GetBS().begin(); it != attributeValue.GetBS().end(); ++it) {
                auto buffer = HashingUtils::Base64Encode(*it);
                [mutableString appendFormat:@"%@, ", CSTR_TO_STR(buffer)];
            }
            _stringValue = [NSString stringWithFormat:@"{ %@ }",
                                                      [mutableString substringToIndex:[mutableString length] - 2]];
        }
            break;

        case CDynamoItemTypeS:
            _stringValue = CSTR_TO_STR(attributeValue.GetS());
            break;

        case CDynamoItemTypeSS: {
            NSMutableString *mutableString = [NSMutableString new];
            for (auto it = attributeValue.GetSS().begin(); it != attributeValue.GetSS().end(); ++it) {
                [mutableString appendFormat:@"\"%@\", ", CSTR_TO_STR((*it))];
            }
            _stringValue = [NSString stringWithFormat:@"{ %@ }",
                                                      [mutableString substringToIndex:[mutableString length] - 2]];
        }
            break;

        case CDynamoItemTypeN:
            _stringValue = CSTR_TO_STR(attributeValue.GetN());
            break;

        case CDynamoItemTypeNS: {
            NSMutableString *mutableString = [NSMutableString new];
            for (auto it = attributeValue.GetNS().begin(); it != attributeValue.GetNS().end(); ++it) {
                [mutableString appendFormat:@"%@, ", CSTR_TO_STR((*it))];
            }
            _stringValue = [NSString stringWithFormat:@"{ %@ }",
                                                      [mutableString substringToIndex:[mutableString length] - 2]];
        }
            break;

            //case CDynamoItemTypeL:
            //case CDynamoItemTypeM:
            //case CDynamoItemTypeNull:
            //case CDynamoItemTypeBool:
        default:
            _stringValue = CSTR_TO_STR(it->second.WriteCompact());
            break;
    }

    return _stringValue;
}

- (NSString *)headerName {
    if (_headerName) {
        return _headerName;
    }
    _headerName = [CDynamoHeader makeHeaderWithAttributeName:_attributeName withAttributeType:_attributeType];
    return _headerName;
}

+ (CDynamoItem *)initWithAttributeValue:(void *)attributeValuePtr withAttributeName:(NSString *)attributeName {

    CDynamoItem *dynamoItem = [CDynamoItem new];
    [dynamoItem mappingAttributeValue:attributeValuePtr withAttributeName:attributeName];

    return dynamoItem;
}

- (void)mappingAttributeValue:(void *)valuePtr withAttributeName:(NSString *)itemName {

    attributeValue = *(AttributeValue *) valuePtr;

    _attributeName = itemName;

    auto mapJson = attributeValue.Jsonize().View().GetAllObjects();
    auto it = mapJson.begin();

    _attributeTypeString = CSTR_TO_STR(it->first);

    if (it->first == "B") {
        self.attributeType = CDynamoItemTypeB;
    } else if (it->first == "BOOL") {
        self.attributeType = CDynamoItemTypeBool;
    } else if (it->first == "BS") {
        self.attributeType = CDynamoItemTypeBS;
    } else if (it->first == "L") {
        self.attributeType = CDynamoItemTypeL;
    } else if (it->first == "M") {
        self.attributeType = CDynamoItemTypeM;
    } else if (it->first == "N") {
        self.attributeType = CDynamoItemTypeN;
    } else if (it->first == "NS") {
        self.attributeType = CDynamoItemTypeNS;
    } else if (it->first == "NULL") {
        self.attributeType = CDynamoItemTypeNull;
    } else if (it->first == "S") {
        self.attributeType = CDynamoItemTypeS;
    } else if (it->first == "SS") {
        self.attributeType = CDynamoItemTypeSS;
    }
}

+ (void)mappingToAttributeValue:(CDynamoItem *)item toAttributeValue:(void *)ptr {

    //AttributeAction
    //  NOT_SET,
    //  ADD,
    //  PUT,
    //  DELETE_

    AttributeValue *attributeValue = (AttributeValue *) ptr;

    //auto itemName = [[item attributeTypeString] UTF8String];
    auto itemValue = [[item stringValue] UTF8String];

    AttributeValueUpdate attributeValueUpdate;

    attributeValueUpdate.SetAction(AttributeAction(AttributeAction::ADD));
    attributeValueUpdate.SetValue(AttributeValue().SetS(itemValue));

    switch ([item attributeType]) {
        case CDynamoItemTypeB: {
            auto buffer = HashingUtils::Base64Decode(itemValue);
            attributeValue->SetB(buffer);
        }
            break;
        case CDynamoItemTypeBool:
            //attributeValue->SetBool(bool value)
            break;
        case CDynamoItemTypeBS:
            //attributeValue->SetBS(const Aws::Vector<Aws::Utils::ByteBuffer> &bs)
            break;
        case CDynamoItemTypeL:
            //attributeValue->SetL(const Aws::Vector<std::shared_ptr<AttributeValue> > &list)
            break;
        case CDynamoItemTypeM:
            //attributeValue->SetM(const Aws::Map<Aws::String, const std::shared_ptr<AttributeValue> > &map)
            break;
        case CDynamoItemTypeN:
            attributeValue->SetN(itemValue);
            break;
        case CDynamoItemTypeNS:
            //attributeValue->SetNS(const Aws::Vector<Aws::String> &ns)
            break;
        case CDynamoItemTypeNull:
            //attributeValue->SetNS(const Aws::Vector<Aws::String> &ns)
            break;
        case CDynamoItemTypeS:
            attributeValue->SetS(itemValue);
            break;
        case CDynamoItemTypeSS:
            //attributeValue->SetSS(const Aws::Vector<Aws::String> &ss)
            break;
        default:
            break;
    }

}

@end
