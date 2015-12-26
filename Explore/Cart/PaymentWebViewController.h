//
//  PaymentWebViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 03/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaymentTransactionDelegate <NSObject>

-(void)paymentDoneNavigateToFeedWithSuccess:(BOOL)isSuccessful hasUserCancelled:(BOOL)isManualCancellation;

@end

@interface PaymentWebViewController : UIViewController<UIWebViewDelegate, NSURLSessionDelegate, UIAlertViewDelegate>{
    UIWebView *webView;
    
    BOOL shouldRedirect;
    NSURLRequest *redirectRequest;
    
}

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) FyndActivityIndicator *webViewLoader;
@property (nonatomic,unsafe_unretained) id<PaymentTransactionDelegate> paymentWebDelegate;
@end
