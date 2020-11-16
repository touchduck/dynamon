//
//  CDynamo.h
//  CDynamoDB
//
//  Created by Touch Duck on 2016/01/19.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CDynamoClient.h"

#pragma mark interface

@interface CDynamo : NSObject

@property(nonatomic, assign) CDynamoScheme awsScheme;
@property(nonatomic, strong) NSString *awsRegion;

@property(nonatomic, strong) NSString *awsAccessKeyId;
@property(nonatomic, strong) NSString *awsSecretKey;

@property(nonatomic, strong) NSString *awsEndpointOverride;

@property(nonatomic, strong) NSString *awsProxyHost;
@property(nonatomic, assign) NSUInteger awsProxyPort;
@property(nonatomic, strong) CDynamoClient *client;

@property(nonatomic, strong) NSString *allocationTag;

+ (CDynamo *)sharedInstance;

- (void)clear;

- (void)config;

@end
