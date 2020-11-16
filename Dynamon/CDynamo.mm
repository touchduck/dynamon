//
//  CDynamoClient.m
//  Dynamon
//
//  Created by Touch Duck on 2016/09/19.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import "CDynamo.h"

#include <aws/core/Aws.h>
#include <aws/core/auth/AWSCredentialsProviderChain.h>
#include <aws/core/utils/ratelimiter/DefaultRateLimiter.h>
#include <aws/dynamodb/DynamoDBClient.h>

using namespace Aws::Auth;
using namespace Aws::Http;
using namespace Aws::Client;
using namespace Aws::DynamoDB;
using namespace Aws::DynamoDB::Model;

static CDynamo *sharedData_ = nil;

@implementation CDynamo {
    Aws::SDKOptions options;
    Aws::Client::ClientConfiguration config;
    std::shared_ptr<DynamoDBClient> m_client;
}

+ (CDynamo *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData_ = [CDynamo new];
    });
    return sharedData_;
}

- (void)initialization {
    Aws::InitAPI(options);
    _allocationTag = [NSString stringWithFormat:@"dynamon-%@", [[NSUUID UUID] UUIDString]];
    [self clear];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)clear {
    _awsAccessKeyId = @"";
    _awsSecretKey = @"";

    _awsEndpointOverride = @"";

    _awsProxyHost = @"";
    _awsProxyPort = 0;

    _awsRegion = @"us-east-1";
    _awsScheme = CDynamoScheme_HTTPS;

    _client = [CDynamoClient new];

    config.proxyHost = "";
    config.proxyPort = 0;
    config.endpointOverride = "";
}

- (void)config {

    options.loggingOptions.logLevel = Aws::Utils::Logging::LogLevel::Info;

    config.connectTimeoutMs = 30000;
    config.requestTimeoutMs = 30000;

    Aws::String tag = [_allocationTag UTF8String];
    config.readRateLimiter = Aws::MakeShared<Aws::Utils::RateLimits::DefaultRateLimiter<>>(tag.c_str(), 200000);
    config.writeRateLimiter = Aws::MakeShared<Aws::Utils::RateLimits::DefaultRateLimiter<>>(tag.c_str(), 200000);

    config.httpLibOverride = Aws::Http::TransferLibType::DEFAULT_CLIENT;

    switch (_awsScheme) {
        case CDynamoScheme_HTTP:
            config.scheme = Scheme::HTTP;
            break;
        case CDynamoScheme_HTTPS:
            config.scheme = Scheme::HTTPS;
            break;
        default:
            break;
    }

    config.region = Aws::String(_awsRegion.UTF8String);

    if ([_awsProxyHost length] > 0) {
        config.proxyHost = [_awsProxyHost UTF8String];
    }

    if (_awsProxyPort > 0) {
        config.proxyPort = (int) _awsProxyPort;
    }

    if ([_awsEndpointOverride length] > 0) {
        config.endpointOverride = [_awsEndpointOverride UTF8String];
    }

    auto credentials = AWSCredentials([_awsAccessKeyId UTF8String], [_awsSecretKey UTF8String]);
    m_client = Aws::MakeShared<DynamoDBClient>(tag.c_str(), credentials, config);
    [self.client setClient:&m_client];

}

- (void)dealloc {
    Aws::ShutdownAPI(options);
}

@end

