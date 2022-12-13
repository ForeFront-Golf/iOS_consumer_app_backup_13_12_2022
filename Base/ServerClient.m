//
//  ServerClient.m
//  GolfConsumer
//
//  Created by Matt Michels on 1/26/16.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "ServerClient.h"

@implementation ServerClient

+ (instancetype) sharedClient
{
    static ServerClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ServerClient alloc] initWithBaseURL:[NSURL URLWithString:kServerURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        _sharedClient.requestSerializer = requestSerializer;
        _sharedClient.operationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}

+ (void)setSessionId:(NSString*)sessionId
{
    ServerClient *sharedClient = [self sharedClient];
    [sharedClient.requestSerializer setValue:sessionId forHTTPHeaderField:@"Authorization"];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
+ (void)get:(NSString*)url withBlock:(void (^)(NSDictionary *results, NSError *error))block
{
    [[ServerClient sharedClient] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *response)
     {
        NSLog(@"url-----------------%@",url);
        NSLog(@"response----------------%@",response);
         block(response, nil);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
         if(![User processError:response.statusCode])
         {
             block(nil, error);
         }
     }];
}

+ (void)post:(NSString*)url withParameters:(NSDictionary*)parameters withBlock:(void (^)(NSDictionary *results, NSError *error))block
{
    [[ServerClient sharedClient] POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *response)
     {
        NSLog(@"url-----------------%@",url);
        NSLog(@"parameter---------------%@",parameters);
        NSLog(@"response----------------%@",response);
         block(response, nil);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
         if(![User processError:response.statusCode])
         {
             block(nil, error);
         }
     }];
}

+ (void)put:(NSString*)url withParameters:(NSDictionary*)parameters withBlock:(void (^)(NSDictionary *results, NSError *error))block
{
    [[ServerClient sharedClient] PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task,  NSDictionary *response)
     {
        NSLog(@"url-----------------%@",url);
        NSLog(@"parameter---------------%@",parameters);
        NSLog(@"response----------------%@",response);
         block(response, nil);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
         if(![User processError:response.statusCode])
         {
             block(nil, error);
         }
     }];
}

#pragma clang diagnostic pop

@end

