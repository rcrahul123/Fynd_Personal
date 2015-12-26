//
//  SSBaseRequestHandler.m
//  Explore
//
//  Created by Amboj Goyal on 7/26/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SSBaseRequestHandler.h"


@implementation SSBaseRequestHandler
-(id)init
{
    self=[super init];
    if(self){
        _urlSession = [[SSURLSession alloc] init];
    }
    return self;
}



//added to apped multiple params with same key in case of filters e.g color=blue & color=green
-(void)sendHttpRequestWithURL:(NSString *)URL withParameterArray:(NSArray *)paramArray withCompletionHandler:(BaseCompletionHandler)baseCompletion
{
    NSMutableString *urlRequestString= [[NSMutableString alloc] init];
    [urlRequestString appendString:URL];
    
//    NSArray *paramKeys = [params allKeys];
//    NSInteger keyCount = [paramKeys count];
    
    
    urlRequestString = (NSMutableString *)[urlRequestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *post = [[NSMutableString alloc]init];
    for (NSInteger i=0; i< [paramArray count]; i++) {
        NSString *key  = [[[paramArray objectAtIndex:i] allKeys] objectAtIndex:0];
    
        
//        NSString *key = [paramKeys objectAtIndex:i];
        [post appendString:key];
        [post appendString:@"="];
//        [post appendString:[params objectForKey:key]];
        [post appendString:[self handleEncoding:[[paramArray objectAtIndex:i] objectForKey:key]]];
        if(i != ([paramArray count]-1))
            [post appendString:@"&"];
    }
    
    urlRequestString = (NSMutableString*)[urlRequestString stringByAppendingString:post];
    
//    NSMutableURLRequest *mutableUrlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[urlRequestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSMutableURLRequest *mutableUrlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlRequestString]];
    [mutableUrlRequest setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"] stringValue] forHTTPHeaderField:@"latitude"];
    [mutableUrlRequest setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"] stringValue] forHTTPHeaderField:@"longitude"];
    [mutableUrlRequest setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"city"] forHTTPHeaderField:@"city"];
    [mutableUrlRequest setValue:[SSUtility getUserAgentString] forHTTPHeaderField:@"user-agent"];
    [mutableUrlRequest setValue:[NSString stringWithFormat:@"%@",[[NSNumber numberWithFloat:[[UIScreen mainScreen] scale] * DeviceWidth] stringValue]]  forHTTPHeaderField:@"display-width"];

    //Added By Amboj for cookies for OMS server

//    NSHTTPCookie *cookieForSessionId = [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] lastObject];
//    if (cookieForSessionId) {
//        [mutableUrlRequest setValue:cookieForSessionId.value forHTTPHeaderField:@"sessionid"];
//    }

        [mutableUrlRequest setValue:[self getCookieForSessionID] forHTTPHeaderField:@"sessionid"];
    urlRequest = [mutableUrlRequest copy];
    
    [self.urlSession send:urlRequest withSessionType:SessionTypeDefaultSession andTask:SessionDataTask withCompletionHandler:^(id responseData, NSError *error) {
        if (baseCompletion) {
            if (error) {
                baseCompletion(nil,error);
            }else
                baseCompletion(responseData,nil);
        }
    }];
}



-(void)sendHttpRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion
{
    NSMutableString *urlRequestString= [[NSMutableString alloc] init];
    [urlRequestString appendString:URL];

    NSArray *paramKeys = [params allKeys];
    NSInteger keyCount = [paramKeys count];
    
    urlRequestString = (NSMutableString *)[urlRequestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableString *post = [[NSMutableString alloc]init];
    for (NSInteger i=0; i< keyCount; i++) {
        NSString *key = [paramKeys objectAtIndex:i];
        [post appendString:key];
        [post appendString:@"="];
        [post appendString:[self handleEncoding:[params objectForKey:key]]];
        if(i != (keyCount-1))
            [post appendString:@"&"];
    }
    
    urlRequestString = (NSMutableString*)[urlRequestString stringByAppendingString:post];
//    NSMutableURLRequest *mutableUrlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[urlRequestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSMutableURLRequest *mutableUrlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlRequestString]];

    [mutableUrlRequest setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"] stringValue] forHTTPHeaderField:@"latitude"];
    [mutableUrlRequest setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"] stringValue] forHTTPHeaderField:@"longitude"];
    [mutableUrlRequest setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"city"] forHTTPHeaderField:@"city"];
    [mutableUrlRequest setValue:[NSString stringWithFormat:@"%@",[[NSNumber numberWithFloat:[[UIScreen mainScreen] scale] * DeviceWidth] stringValue]]  forHTTPHeaderField:@"display-width"];
    [mutableUrlRequest setValue:[SSUtility getUserAgentString] forHTTPHeaderField:@"user-agent"];
    
    
    //Added By Amboj for cookies for OMS server
//    NSHTTPCookie *cookieForSessionId = [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] lastObject];
//    if (cookieForSessionId) {
//        [mutableUrlRequest setValue:cookieForSessionId.value forHTTPHeaderField:@"sessionid"];
//    }
    [mutableUrlRequest setValue:[self getCookieForSessionID] forHTTPHeaderField:@"sessionid"];
    urlRequest = [mutableUrlRequest copy];
    
    [self.urlSession send:urlRequest withSessionType:SessionTypeDefaultSession andTask:SessionDataTask withCompletionHandler:^(id responseData, NSError *error) {
        if (baseCompletion) {
            if (error) {
                baseCompletion(nil,error);
            }else
                baseCompletion(responseData,nil);
        }
    }];
}


-(void)sendJustPayAddRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion{
    NSMutableString *urlRequestString = [NSMutableString stringWithString:URL];
    NSArray *paramKeys = [params allKeys];
    NSInteger keyCount = [paramKeys count];
    
    NSMutableString *post = [[NSMutableString alloc]init];
    for (NSInteger i=0; i< keyCount; i++) {
        NSString *key = [paramKeys objectAtIndex:i];
        [post appendString:key];
        [post appendString:@"="];
        [post appendString:[params objectForKey:key]];
        
        if(i != (keyCount-1))
            [post appendString:@"&"];
    }
    
    NSString *postParams = [post copy];
    NSData *postData = [postParams dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%ld",(unsigned long)[postParams length]];
    
    NSMutableURLRequest *mutableUrlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[urlRequestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [mutableUrlRequest setHTTPMethod:@"POST"];
    [mutableUrlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [mutableUrlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [mutableUrlRequest setHTTPBody:postData];
    
    
    urlRequest = [mutableUrlRequest copy];
    
    [self.urlSession send:urlRequest withSessionType:SessionTypeDefaultSession andTask:SessionDataTask withCompletionHandler:^(id responseData, NSError *error) {
        if (baseCompletion) {
            if (error) {
                baseCompletion(nil,error);
            }else
                baseCompletion(responseData,nil);
        }
    }];
}


-(void)sendJusPayPostHttpRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion
{
    
    NSMutableString *urlRequestString = [NSMutableString stringWithString:URL];
    NSArray *paramKeys = [params allKeys];
    NSInteger keyCount = [paramKeys count];
    
    NSMutableString *post = [[NSMutableString alloc]init];
    for (NSInteger i=0; i< keyCount; i++) {
        NSString *key = [paramKeys objectAtIndex:i];
        [post appendString:key];
        [post appendString:@"="];
        [post appendString:[self handleEncoding:[params objectForKey:key]]];
        
        if(i != (keyCount-1))
            [post appendString:@"&"];
    }
    
    NSString *postParams = [post copy];
    NSData *postData = [postParams dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%ld",(unsigned long)[postParams length]];
    
    NSMutableURLRequest *mutableUrlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[urlRequestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [mutableUrlRequest setHTTPMethod:@"POST"];
    [mutableUrlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [mutableUrlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [mutableUrlRequest setValue:[NSString stringWithFormat:@"%@",[[NSNumber numberWithFloat:[[UIScreen mainScreen] scale] * DeviceWidth] stringValue]]  forHTTPHeaderField:@"display-width"];
    [mutableUrlRequest setValue:[SSUtility getUserAgentString] forHTTPHeaderField:@"user-agent"];
    
    [mutableUrlRequest setValue:[self getCookieForSessionID] forHTTPHeaderField:@"sessionid"];
    [mutableUrlRequest setHTTPBody:postData];
    urlRequest = [mutableUrlRequest copy];
    
    [self.urlSession send:urlRequest withSessionType:SessionTypeDefaultSession andTask:SessionDataTask withCompletionHandler:^(id responseData, NSError *error) {
        if (baseCompletion) {
            if (error) {
                baseCompletion(nil,error);
            }else
                baseCompletion(responseData,nil);
        }
    }];
}




-(NSURLSessionDataTask *)sendCachedHttpRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion{
    NSMutableString *urlRequestString= [[NSMutableString alloc] init];
    [urlRequestString appendString:URL];
    
    NSArray *paramKeys = [params allKeys];
    NSInteger keyCount = [paramKeys count];
    
    urlRequestString = (NSMutableString *)[urlRequestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableString *post = [[NSMutableString alloc]init];
    for (NSInteger i=0; i< keyCount; i++) {
        NSString *key = [paramKeys objectAtIndex:i];
        [post appendString:key];
        [post appendString:@"="];
        [post appendString:[self handleEncoding:[params objectForKey:key]]];
        if(i != (keyCount-1))
            [post appendString:@"&"];
    }
    
    urlRequestString = (NSMutableString*)[urlRequestString stringByAppendingString:post];
//    NSMutableURLRequest *mutableUrlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[urlRequestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSMutableURLRequest *mutableUrlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlRequestString]];
//    [mutableUrlRequest setValue:@"am9zaHVhOmNhcHR1cmVyZXRhaWw=" forHTTPHeaderField:@"Authorization"];
    [mutableUrlRequest setValue:[SSUtility getUserAgentString] forHTTPHeaderField:@"user-agent"];
    [mutableUrlRequest setValue:[NSString stringWithFormat:@"%@",[[NSNumber numberWithFloat:[[UIScreen mainScreen] scale] * DeviceWidth] stringValue]]  forHTTPHeaderField:@"display-width"];

    //Added By Amboj for cookies for OMS server
//    NSHTTPCookie *cookieForSessionId = [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] lastObject];
//    if (cookieForSessionId) {
//        [mutableUrlRequest setValue:cookieForSessionId.value forHTTPHeaderField:@"sessionid"];
//    }
    [mutableUrlRequest setValue:[self getCookieForSessionID] forHTTPHeaderField:@"sessionid"];
    urlRequest = [mutableUrlRequest copy];
    //TODO - Need to check if we require this i or not.
//    [self.urlSession invalidateAndCancel];
   NSURLSessionDataTask *sessionDataTask = [self.urlSession sendRequestWithCaching:urlRequest withSessionType:SessionTypeDefaultSession andTask:SessionDataTask withCompletionHandler:^(id responseData, NSError *error) {
    
        if (baseCompletion) {
            if (error) {
                baseCompletion(nil,error);
            }else
                baseCompletion(responseData,nil);
        }
    }];
    return sessionDataTask;
}


-(NSString *)handleEncoding:(NSString *)urlString{
    NSString *encodedStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]" , kCFStringEncodingUTF8);
    return encodedStr;
}


-(NSString *)handleEncoding1:(NSString *)urlString{
    NSString *encodedStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[] " , kCFStringEncodingUTF8);
    return encodedStr;
}


-(void)sendPostHttpRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion
{
    
    NSMutableString *urlRequestString = [NSMutableString stringWithString:URL];
    
    NSArray *paramKeys = [params allKeys];
    NSInteger keyCount = [paramKeys count];

    NSMutableString *post = [[NSMutableString alloc]init];
    for (NSInteger i=0; i< keyCount; i++) {
        NSString *key = [paramKeys objectAtIndex:i];
        [post appendString:key];
        [post appendString:@"="];
        [post appendString:[self handleEncoding:[params objectForKey:key]]];

        if(i != (keyCount-1))
            [post appendString:@"&"];
        
    }
    
    NSString *postParams = [post copy];
    NSData *postData = [postParams dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%ld",(unsigned long)[postParams length]];

    NSMutableURLRequest *mutableUrlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[urlRequestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [mutableUrlRequest setHTTPMethod:@"POST"];
    [mutableUrlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [mutableUrlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [mutableUrlRequest setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"] stringValue] forHTTPHeaderField:@"latitude"];
    [mutableUrlRequest setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"] stringValue] forHTTPHeaderField:@"longitude"];
    [mutableUrlRequest setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"city"] forHTTPHeaderField:@"city"];
    [mutableUrlRequest setValue:[NSString stringWithFormat:@"%@",[[NSNumber numberWithFloat:[[UIScreen mainScreen] scale] * DeviceWidth] stringValue]]  forHTTPHeaderField:@"display-width"];
    [mutableUrlRequest setValue:[SSUtility getUserAgentString] forHTTPHeaderField:@"user-agent"];
    
    //Added By Amboj for cookies for OMS server
//    NSHTTPCookie *cookieForSessionId = [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] lastObject];
//    if (cookieForSessionId) {
//        [mutableUrlRequest setValue:cookieForSessionId.value forHTTPHeaderField:@"sessionid"];
//    }
        [mutableUrlRequest setValue:[self getCookieForSessionID] forHTTPHeaderField:@"sessionid"];
    [mutableUrlRequest setHTTPBody:postData];
    
//    [mutableUrlRequest setValue:@"am9zaHVhOmNhcHR1cmVyZXRhaWw=" forHTTPHeaderField:@"Authorization"];
    
    urlRequest = [mutableUrlRequest copy];
    
    [self.urlSession send:urlRequest withSessionType:SessionTypeDefaultSession andTask:SessionDataTask withCompletionHandler:^(id responseData, NSError *error) {
        if (baseCompletion) {
            if (error) {
                baseCompletion(nil,error);
            }else
                baseCompletion(responseData,nil);
        }
    }];
}



- (void)sendPostDataInMultipart:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableString *urlRequestString = [NSMutableString stringWithString:URL];
    [request setURL:[NSURL URLWithString:[urlRequestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
//    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
     NSString *boundary = @"--------123456789009876543211234567890";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in params) {
        
        if(![param isEqualToString:@"profile_pic"]){
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // add image data
    UIImage *imageToPost = [params objectForKey:@"profile_pic"];
    NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
    NSString *picKey = @"profile_pic";
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", picKey] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set URL
//    [request setURL:URL];
    
     urlRequest = [request copy];
    [self.urlSession send:urlRequest withSessionType:SessionTypeDefaultSession andTask:SessionDataTask withCompletionHandler:^(id responseData, NSError *error) {
        if (baseCompletion) {
            if (error) {
                baseCompletion(nil,error);
            }else
                baseCompletion(responseData,nil);
        }
    }];
    
}


-(void)sendJSONPostHttpRequestWithURL:(NSString *)URL withParameters:(NSDictionary *)params withCompletionHandler:(BaseCompletionHandler)baseCompletion
{
    
    NSMutableString *urlRequestString = [NSMutableString stringWithString:URL];
    NSString *jsonString = nil;
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:0
                                                         error:&error];
    
    if (! postData) {
    } else {
        jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    }
    
    NSString *postLength = [NSString stringWithFormat:@"%ld",(unsigned long)[postData length]];
    
    NSMutableURLRequest *mutableUrlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[urlRequestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

    [mutableUrlRequest setHTTPMethod:@"POST"];
    [mutableUrlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [mutableUrlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mutableUrlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [mutableUrlRequest setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"] stringValue] forHTTPHeaderField:@"latitude"];
    [mutableUrlRequest setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"] stringValue] forHTTPHeaderField:@"longitude"];
    [mutableUrlRequest setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"city"] forHTTPHeaderField:@"city"];
    [mutableUrlRequest setValue:[NSString stringWithFormat:@"%@",[[NSNumber numberWithFloat:[[UIScreen mainScreen] scale] * DeviceWidth] stringValue]]  forHTTPHeaderField:@"display-width"];
    [mutableUrlRequest setValue:[SSUtility getUserAgentString] forHTTPHeaderField:@"user-agent"];
    
    //Added By Amboj for cookies for OMS server
//    NSHTTPCookie *cookieForSessionId = [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] lastObject];
//    if (cookieForSessionId) {
//        [mutableUrlRequest setValue:cookieForSessionId.value forHTTPHeaderField:@"sessionid"];
//    }
    [mutableUrlRequest setValue:[self getCookieForSessionID] forHTTPHeaderField:@"sessionid"];
    [mutableUrlRequest setHTTPBody:postData];
    
    urlRequest = [mutableUrlRequest copy];
    
    [self.urlSession send:urlRequest withSessionType:SessionTypeDefaultSession andTask:SessionDataTask withCompletionHandler:^(id responseData, NSError *error) {
        if (baseCompletion) {
            if (error) {
                baseCompletion(nil,error);
            }else
                baseCompletion(responseData,nil);
        }
    }];
}

-(NSString *)getCookieForSessionID{
    NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    __block NSString *cookieValue = @" ";
    [allCookies enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSHTTPCookie *currentCookie = (NSHTTPCookie *)obj;
        if ([[currentCookie.name uppercaseString] isEqualToString:@"SESSIONID"]) {
            cookieValue = currentCookie.value;
        }
    }];
    return cookieValue;
}


@end
