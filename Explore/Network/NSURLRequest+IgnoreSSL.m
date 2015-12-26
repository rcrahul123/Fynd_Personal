//
//  NSURLRequest+IgnoreSSL.m
//  Explore
//
//  Created by Amboj Goyal on 7/26/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "NSURLRequest+IgnoreSSL.h"

@implementation NSURLRequest(IgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end
