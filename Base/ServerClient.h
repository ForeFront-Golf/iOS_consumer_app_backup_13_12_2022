//
//  ServerClient.h
//  GolfConsumer
//
//  Created by Matt Michels on 1/26/16.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface ServerClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
+ (void)setSessionId:(NSString*)sessionId;

+ (void)get:(NSString*)url withBlock:(void (^)(NSDictionary *results, NSError *error))block;
+ (void)put:(NSString*)url withParameters:(NSDictionary*)parameters withBlock:(void (^)(NSDictionary *results, NSError *error))block;
+ (void)post:(NSString*)url withParameters:(NSDictionary*)parameters withBlock:(void (^)(NSDictionary *results, NSError *error))block;

@end
