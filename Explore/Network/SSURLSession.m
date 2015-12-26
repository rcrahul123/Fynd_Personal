//
//  SSURLSession.m
//  Explore
//
//  Created by Amboj Goyal on 7/26/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SSURLSession.h"

@interface SSURLSession(){
    NSURLSessionConfiguration *backgroundSessionConfigurator;
    //Creating the Sessions.
    NSURLSession *backgroundSession;
    
    NSURLSession *ephemeralSession;
    
    //Creating the sessionTasks.
    
    NSURLSessionDownloadTask *downloadTask;
    
    //Common Variables.
    NSMutableURLRequest *sessionMutableRequest;

    NSMutableData *responseData;
    NSHTTPURLResponse *httpResponse;
    NSMutableURLRequest *urlRequest;
}
@end



@implementation SSURLSession

#pragma mark - NSURLSession Setup Methods
-(void)setupDefaultSessionWithCachingEnabled:(BOOL)isCachingEnbled{
    self.defaultSessionConfigurator = [NSURLSessionConfiguration
                                       defaultSessionConfiguration];
    
    self.defaultSessionConfigurator.allowsCellularAccess = YES;
    self.defaultSessionConfigurator.timeoutIntervalForRequest = 120.0;
    self.defaultSessionConfigurator.timeoutIntervalForResource = 120.0;
    if (isCachingEnbled) {
        self.defaultSessionConfigurator.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
        self.defaultSessionConfigurator.URLCache = [NSURLCache sharedURLCache];
    }else{
        self.defaultSessionConfigurator.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    }
    
    
    NSURLSession *theSession = [NSURLSession sessionWithConfiguration:self.defaultSessionConfigurator
                                                        delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    if (isCachingEnbled) {
        self.sessionWithCaching = theSession;
    }else{
        self.defaultSession = theSession;
    }
}

-(void)setupBackgroundSession{
    backgroundSessionConfigurator = [NSURLSessionConfiguration
                                     backgroundSessionConfiguration: @"backgroundSessionConfigurationIdentifier"];
    backgroundSessionConfigurator.allowsCellularAccess = YES;
    backgroundSessionConfigurator.timeoutIntervalForRequest = 30.0;
    backgroundSessionConfigurator.timeoutIntervalForResource = 60.0;
    backgroundSessionConfigurator.HTTPMaximumConnectionsPerHost = 1;
    
    backgroundSession = [NSURLSession sessionWithConfiguration:
                         backgroundSessionConfigurator delegate: self delegateQueue: [NSOperationQueue mainQueue]];
}
-(void)send:(NSURLRequest *)request withSessionType:(SessionType)sessionType andTask:(SessionTaskType)taskType withCompletionHandler:(CompletionHandler)completionBlock{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    if([reachability isReachable]){
        
        urlRequest = [request copy];
        NSArray *availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[urlRequest URL]];
        NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
        
        if([availableCookies count] >0)
            [urlRequest setAllHTTPHeaderFields:[headers copy]];

        [self setupDefaultSessionWithCachingEnabled:FALSE];

//        [self setupDefaultSession];
        
        self.dataTask = [self.defaultSession dataTaskWithRequest:[urlRequest copy] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (completionBlock) {
                if (error) {
                    completionBlock(nil,error);
                }else{
//                    if ([data isGzippedData]) {
//                        self.defaultSessionResponseData = [[data gunzippedData] copy];
//                    }else{
                        self.defaultSessionResponseData = [data copy];
//             [Not A Type release]: message sent to deallocated instance       }

                    NSHTTPURLResponse *theURLResponse = (NSHTTPURLResponse *)response;
//                    NSUInteger statusCode = [theURLResponse statusCode];

                    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[theURLResponse allHeaderFields] forURL:[urlRequest URL]];
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:[urlRequest URL] mainDocumentURL:[urlRequest URL]];
                    
//                    if(statusCode >= 200 && statusCode <=400)
                    {
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_defaultSessionResponseData options:0 error:nil];

                        if(json && ([json isKindOfClass:[NSDictionary class]] || [json isKindOfClass:[NSArray class]])){
                            completionBlock(json,nil);
                        }
                        else{
                            completionBlock(nil,error);
                        }
                    }/* else {
//                        completionBlock(nil,[self getCustomErrorObjectForCode:statusCode]);
                       
                    }*/
                }
            }
        }];
        [self.dataTask resume];
        
    }else{
        //Network or Application is not reachable
        if (completionBlock) {
            completionBlock(nil,[self getCustomErrorObjectForCode:APPLICATION_NOT_REACHABLE]);
        }
    }
}

-(NSURLSessionDataTask *)sendRequestWithCaching:(NSURLRequest *)request withSessionType:(SessionType)sessionType andTask:(SessionTaskType)taskType withCompletionHandler:(CompletionHandler)completionBlock{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    if([reachability isReachable]){
        
        urlRequest = [request copy];
        NSArray *availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[urlRequest URL]];
        NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
        if([availableCookies count] >0)
            [urlRequest setAllHTTPHeaderFields:[headers copy]];
        
        [self setupDefaultSessionWithCachingEnabled:TRUE];
        
        self.dataTask = [self.sessionWithCaching dataTaskWithRequest:[urlRequest copy] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (completionBlock) {
                if (error) {
                    completionBlock(nil,error);
                }else{
//                    if ([data isGzippedData]) {
//                        self.defaultSessionResponseData = [[data gunzippedData] copy];
//                    }else{
                        self.defaultSessionResponseData = [data copy];
//                    }
                    NSHTTPURLResponse *theURLResponse = (NSHTTPURLResponse *)response;
                    NSUInteger statusCode = [theURLResponse statusCode];
                    
                    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[theURLResponse allHeaderFields] forURL:[urlRequest URL]];
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:[urlRequest URL] mainDocumentURL:[urlRequest URL]];
                    
                    if(statusCode >= 200 && statusCode <400){
                        if(data.length>0)
                            completionBlock(data,nil);
                        else
                            completionBlock(nil,error);
                    } else {
                        completionBlock(nil,[self getCustomErrorObjectForCode:statusCode]);
                    }
                }
            }
        }];
//        [self.dataTask resume];
        
    }else{
        //Network or Application is not reachable
        if (completionBlock) {
            completionBlock(nil,[self getCustomErrorObjectForCode:APPLICATION_NOT_REACHABLE]);
        }
    }
    return self.dataTask;
}


#pragma mark - NSURLSESSION DATA TASK DELEGATES.

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
//        if ([challenge.protectionSpace.host hasSuffix:@""]){
            NSURLCredential *credential =[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
//    }
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];

//        completionHandler(NSURLSessionAuthChallengeUseCredential,nil);

}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}



-(NSError *)getCustomErrorObjectForCode:(NSInteger )code{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    if(code == 500){
        [userInfo setObject:SERVER_ERROR_TITLE forKey:ERROR_TITLE_KEY];
        [userInfo setObject:SERVER_ERROR forKey:ERROR_MESSAGE_KEY];
    }else if(code == 401){
        [userInfo setObject:@"Session Expired" forKey:ERROR_TITLE_KEY];
        [userInfo setObject:SESSION_EXPIRED forKey:ERROR_MESSAGE_KEY];
    }else if(code == HOST_NOT_REACHABLE){
        [userInfo setObject:HOST_NAME_NOT_REACHABLE_TITLE forKey:ERROR_TITLE_KEY];
        [userInfo setObject:HOST_NAME_NOT_REACHABLE forKey:ERROR_MESSAGE_KEY];
    } else if(code >= 200 && code <400) {
        [userInfo setObject:INAPPROPRIATE_RESPONSE_MESSAGE forKey:ERROR_MESSAGE_KEY];
        [userInfo setObject:INAPPROPRIATE_RESPONSE_MESSAGE forKey:ERROR_TITLE_KEY];
    } else{
        [userInfo setObject:NETWORK_ERROR_MESSAGE forKey:ERROR_MESSAGE_KEY];
        [userInfo setObject:NETWORK_ERROR_TITLE forKey:ERROR_TITLE_KEY];
    }
    return [NSError errorWithDomain:@"Explore" code:code userInfo:[userInfo copy]];
}

-(void)cleanUpData{
    [self finishTasksAndInvalidate];
}


@end
