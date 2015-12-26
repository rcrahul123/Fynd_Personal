//
//  PaymentWebViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 03/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "PaymentWebViewController.h"

@interface PaymentWebViewController ()

@end

@implementation PaymentWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Fynd";
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    [self setBackButton];

    [self setupWebView];
}

-(void)viewWillDisappear:(BOOL)animated {
    if (webView) {
        [webView setDelegate:nil];
        [webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:@""]]];
        [webView stopLoading];
    }
    [super viewWillDisappear:animated];
}

-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you really want to abort the payment process?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert show];

}

-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}


-(void)setupWebView{
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [webView setScalesPageToFit:TRUE];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:[self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    if([[self.method uppercaseString] isEqualToString:@"GET"]){
        
    }else if ([[self.method uppercaseString] isEqualToString:@"POST"]){
        
        NSArray *paramKeys = [self.params allKeys];
        NSInteger keyCount = [paramKeys count];
        
        NSMutableString *post = [[NSMutableString alloc]init];
        for (NSInteger i=0; i< keyCount; i++) {
            NSString *key = [paramKeys objectAtIndex:i];
            [post appendString:key];
            [post appendString:@"="];
            [post appendString:[SSUtility handleEncoding:[self.params objectForKey:key]]];
            
            if(i != (keyCount-1))
                [post appendString:@"&"];
        }
        
        NSString *postParams = [post copy];
        NSData *postData = [postParams dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%ld",(unsigned long)[postParams length]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

        [request setHTTPBody:postData];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    }
    [webView loadRequest:[request copy]];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)inType{
    
    [self showLoader];
    NSURL *url = [request mainDocumentURL];
    if([[url absoluteString] rangeOfString:@"juspay-callback"].length > 0){
        shouldRedirect = YES;
        redirectRequest = [request copy];
        return NO;

    }
    
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideLoader];
    if(error.code == 102 && shouldRedirect){
        [self hitRedirectURL];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)view{
    [self hideLoader];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

//    if (self.paymentWebDelegate && [self.paymentWebDelegate respondsToSelector:@selector(paymentDoneNavigateToFeedWithSuccess:)]) {
//        if ([webView isLoading]) {
//            webView.delegate = nil;
//            [webView stopLoading];
//        }
//
//        [self.paymentWebDelegate paymentDoneNavigateToFeedWithSuccess:TRUE];
//    }
    
    if (buttonIndex != 0) {
        if (self.paymentWebDelegate && [self.paymentWebDelegate respondsToSelector:@selector(paymentDoneNavigateToFeedWithSuccess:hasUserCancelled:)]) {
            [self.paymentWebDelegate paymentDoneNavigateToFeedWithSuccess:FALSE hasUserCancelled:TRUE];
        }
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView{

    
}

-(void)hitRedirectURL{
    
    
    NSURLRequest *urlRequest = redirectRequest;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        
        if ([webView isLoading]) {
            webView.delegate = nil;
            [webView stopLoading];
        }
        
        if (!error) {
            NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
            
            BOOL success = [[headers objectForKey:@"Success"] boolValue];
            if(success){
                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Payment Successfull" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                    [alert show];
                    
                    if (self.paymentWebDelegate && [self.paymentWebDelegate respondsToSelector:@selector(paymentDoneNavigateToFeedWithSuccess:hasUserCancelled:)]) {
                            [self.paymentWebDelegate paymentDoneNavigateToFeedWithSuccess:TRUE hasUserCancelled:FALSE];
                    }
                    
                });
            }else{
                
                if (self.paymentWebDelegate && [self.paymentWebDelegate respondsToSelector:@selector(paymentDoneNavigateToFeedWithSuccess:hasUserCancelled:)]) {
                    [self.paymentWebDelegate paymentDoneNavigateToFeedWithSuccess:FALSE hasUserCancelled:FALSE];
                }
            }
            
        }else{
            if (self.paymentWebDelegate && [self.paymentWebDelegate respondsToSelector:@selector(paymentDoneNavigateToFeedWithSuccess:hasUserCancelled:)]) {
                    [self.paymentWebDelegate paymentDoneNavigateToFeedWithSuccess:FALSE hasUserCancelled:FALSE];
            }
        }
        
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoader{
    if(_webViewLoader){
        [_webViewLoader removeFromSuperview];
        _webViewLoader = nil;
    }
    _webViewLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_webViewLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 30)];
    [self.view addSubview:_webViewLoader];
    
}

- (void)hideLoader{
    if (_webViewLoader) {
        [_webViewLoader stopAnimating];
        [_webViewLoader removeFromSuperview];
        _webViewLoader= nil;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
