//
//  SSBaseRequestHandler.h
//  Explore
//
//  Created by Amboj Goyal on 7/26/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSURLSession.h"

typedef void (^BaseCompletionHandlerType)();
typedef void (^BaseCompletionHandler)(id responseData,
                                      NSError *error);

@interface SSBaseRequestHandler : NSObject{
    
    NSURLRequest *urlRequest;
}

@property (nonatomic, strong) NSMutableString *baseURLString;
@property (nonatomic,strong) SSURLSession *urlSession;

-(void)sendHttpRequestWithURL:(NSString *)URL withParameterArray:(NSArray *)paramArray withCompletionHandler:(BaseCompletionHandler)baseCompletion;

-(void)sendHttpRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion;
//-(void)sendCachedHttpRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion;
-(NSURLSessionDataTask *)sendCachedHttpRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion;
-(void)sendPostHttpRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion;

- (void)sendPostDataInMultipart:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion;

-(void)sendJSONPostHttpRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion;

-(void)sendJustPayAddRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion;
-(void)sendJusPayPostHttpRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion;

@end
