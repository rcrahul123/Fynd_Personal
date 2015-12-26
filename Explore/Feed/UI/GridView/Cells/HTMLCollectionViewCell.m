//
//  HTMLCollectionViewCell.m
//  Explore
//
//  Created by Rahul Chaudhari on 09/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "HTMLCollectionViewCell.h"

@implementation HTMLCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.webView = [[UIWebView alloc] init];
        [self addSubview:self.webView];
        
        indicator = [[UIActivityIndicatorView alloc] init];
        [self.webView addSubview:indicator];
        
    }
    return self;
}

-(void)prepareForReuse{
    [indicator setFrame:CGRectZero];
    [self.webView setFrame:CGRectZero];
}


-(void)layoutSubviews{
    
    [indicator setFrame:CGRectMake(0, 0, 40, 40)];
    [indicator setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [self.webView setFrame:CGRectMake(RelativeSize(3, 320), RelativeSize(4, 320), self.frame.size.width - RelativeSize(6, 320), self.frame.size.height - RelativeSize(8, 320))];
    self.webView.layer.cornerRadius = 3.0;
    self.webView.clipsToBounds = YES;
    [self.webView setBackgroundColor:[UIColor whiteColor]];
    self.webView.opaque = false;
    self.webView.delegate = self;
    if(!self.model.isPageLoaded){
        [self.webView loadHTMLString:self.model.htmlString baseURL:nil];
        if([indicator isAnimating]){
            [indicator startAnimating];
            [indicator setHidden:NO];
        }
    }else{
        [indicator setHidden:YES];
        [indicator stopAnimating];
    }
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlString = [[request URL] absoluteString];
    
    if ([urlString rangeOfString:@"gofynd"].length>0) {
        NSString *prefixString = [[urlString componentsSeparatedByString:@"?"] objectAtIndex:1];
        NSString *middleString = [[prefixString componentsSeparatedByString:@"&"] objectAtIndex:0];
        NSString *finalString = [[middleString componentsSeparatedByString:@"="] objectAtIndex:1];
        if ([finalString isEqualToString:@"trackorder"]) {
            [self.htmlDelegate showScreen:finalString];
        }else if([[finalString lowercaseString] rangeOfString:@"contactus"].length>0){
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:"]]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",@"+918767087087"]]];
            }
        }
     
        return FALSE;
    }else
        return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.model.isPageLoaded = TRUE;
    if(self.htmlDelegate && [self.htmlDelegate respondsToSelector:@selector(webViewLoaded:)]){
        [self.htmlDelegate webViewLoaded:self.webView];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}

@end
