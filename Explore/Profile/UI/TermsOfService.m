//
//  TermsOfService.m
//  Explore
//
//  Created by Pranav on 14/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "TermsOfService.h"
#import "SSUtility.h"

@interface TermsOfService()
{
    NSMutableArray *termsOfServiceData;
    UIScrollView *termsServiceScrollView;
}
//- (NSMutableArray *)generateDummyTermsData;
- (void)setUpTermsOfServiceView;
@end

@implementation TermsOfService

- (id)initWithFrame:(CGRect)frame{
    
    if(self == [super initWithFrame:frame]){
//        [self setUpTermsOfServiceView];
    }
    return self;
}


- (void)setUpTermsOfServiceView{
    termsLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [termsLoader setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    
    [self addSubview:termsLoader];
    [termsLoader startAnimating];
//    [SSUtility showActivityOverlay:self];
    CGRect theRect = self.bounds;
    theRect.origin.y = 0;
    theWebView = [[UIWebView alloc] initWithFrame:theRect];
    theWebView.delegate = self;
    [theWebView setBackgroundColor:[UIColor whiteColor]];
    theWebView.scrollView.showsHorizontalScrollIndicator = NO;
    theWebView.scrollView.showsVerticalScrollIndicator = NO;
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *theReq = [[NSURLRequest alloc] initWithURL:url];
    [theWebView loadRequest:theReq];
    [self addSubview:theWebView];    
    /*
    termsOfServiceData = [self generateDummyTermsData];
    
    termsServiceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-20)];
    [termsServiceScrollView setBackgroundColor:[UIColor whiteColor]];
    
    CGSize dynamicSize = CGSizeZero;
    NSInteger dynamicY = 0;
    for(NSInteger counter=0; counter < [termsOfServiceData count]; counter++){
        NSMutableDictionary *dict = [termsOfServiceData objectAtIndex:counter];
        
        NSString *headingTitle = [dict objectForKey:@"Heading"];
        dynamicSize = [SSUtility getLabelDynamicSize:headingTitle withFont:[UIFont fontWithName:kMontserrat_Bold size:16.0f] withSize:CGSizeMake(self.frame.size.width-20, MAXFLOAT)];
        UILabel *heading = [SSUtility generateLabel:headingTitle withRect:CGRectMake(10, dynamicY + 10, dynamicSize.width, dynamicSize.height) withFont:[UIFont fontWithName:kMontserrat_Bold size:16.0f]];
        [termsServiceScrollView addSubview:heading];
        
        
        NSString *headingDescription = [dict objectForKey:@"HeadingDescription"];
        dynamicSize = [SSUtility getLabelDynamicSize:headingDescription withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(self.frame.size.width-20, MAXFLOAT)];
        UILabel *headingDetail = [SSUtility generateLabel:headingDescription withRect:CGRectMake(heading.frame.origin.x, heading.frame.origin.y + heading.frame.size.height + 5, dynamicSize.width, dynamicSize.height) withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [headingDetail setNumberOfLines:0];
        [headingDetail setTextAlignment:NSTextAlignmentLeft];
        [termsServiceScrollView addSubview:headingDetail];
        
        dynamicY+= headingDetail.frame.origin.y + headingDetail.frame.size.height + 30;
        
        if(headingDetail.frame.origin.y + headingDetail.frame.size.height > termsServiceScrollView.frame.size.height){
            [termsServiceScrollView setContentSize:CGSizeMake(termsServiceScrollView.frame.size.width, headingDetail.frame.origin.y + headingDetail.frame.size.height+20)];
        }
    }
    [self addSubview:termsServiceScrollView];
     */
    
    
    [theWebView addSubview:termsLoader];
    [termsLoader startAnimating];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return TRUE;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [SSUtility dismissActivityOverlay];
    [termsLoader stopAnimating];
    [termsLoader removeFromSuperview];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
//    [SSUtility dismissActivityOverlay];
    [termsLoader stopAnimating];
    [termsLoader removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



/*

- (NSMutableArray *)generateDummyTermsData{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSInteger counter=0; counter < 3; counter++){
     
        if(counter == 0){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dict setObject:@"Twill Terms of Service" forKey:@"Heading"];
            [dict setObject:@"Last Modified April 14,2014" forKey:@"HeadingDescription"];
            [tempArray addObject:dict];
        }
        else if(counter == 1){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dict setObject:@"Welcome to Twill!" forKey:@"Heading"];
            [dict setObject:@"This is Heading description3.This is Heading description3. This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3. This is Heading description3.This is Heading description3. This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3 This is Heading description3.This is Heading description3. This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3 This is Heading description3.This is Heading description3. This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3 This is Heading description3.This is Heading description3. This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3 This is Heading description3.This is Heading description3. This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3" forKey:@"HeadingDescription"];
            [tempArray addObject:dict];
        }
        else  if(counter==2){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dict setObject:@"Using our Service" forKey:@"Heading"];
            [dict setObject:@"This is Heading description3.This is Heading description3. This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3.This is Heading description3." forKey:@"HeadingDescription"];
            [tempArray addObject:dict];

        }
        
    }
    return tempArray;
}
*/
@end
