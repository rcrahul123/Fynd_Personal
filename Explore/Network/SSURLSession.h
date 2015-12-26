//
//  SSURLSession.h
//  Explore
//
//  Created by Amboj Goyal on 7/26/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#define HOST_NOT_REACHABLE 1
#define APPLICATION_NOT_REACHABLE 0

typedef NS_OPTIONS(NSUInteger, SessionType) {
    SessionTypeDefaultSession = 0,
    SessionTypeBackgroundSession,
    SessionTypeEphemeralSession
};

typedef NS_OPTIONS(NSUInteger, SessionTaskType) {
    SessionDataTask = 0,
    SessionDownloadTask,
    SessionUploadTask
};
typedef void (^CompletionHandlerType)();
typedef void (^CompletionHandler)(id responseData,
                                  NSError *error);



@interface SSURLSession : NSURLSession<NSURLSessionDataDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>{
    //NSURLSessionDownloadDelegate
}
@property (nonatomic,strong) NSData *defaultSessionResponseData;
@property(nonatomic,strong) NSURLSessionDataTask *dataTask;
@property(nonatomic,strong) NSURLSession *defaultSession;
@property(nonatomic,strong) NSURLSessionConfiguration *defaultSessionConfigurator;

@property(nonatomic,strong) NSURLSession *sessionWithCaching;
@property(nonatomic,strong) NSURLSessionConfiguration *sessionConfiguratorWithCaching;

-(void)send:(NSURLRequest *)request withSessionType:(SessionType)sessionType andTask:(SessionTaskType)taskType withCompletionHandler:(CompletionHandler)completionBlock;

-(NSURLSessionDataTask *)sendRequestWithCaching:(NSURLRequest *)request withSessionType:(SessionType)sessionType andTask:(SessionTaskType)taskType withCompletionHandler:(CompletionHandler)completionBlock;


-(void)cleanUpData;

@end
