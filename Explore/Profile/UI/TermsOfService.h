//
//  TermsOfService.h
//  Explore
//
//  Created by Pranav on 14/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsOfService : UIView<UIWebViewDelegate>{
    UIWebView *theWebView;
    FyndActivityIndicator *termsLoader;
}
- (void)setUpTermsOfServiceView;
@property (nonatomic,copy)NSString *urlString;
@property (nonatomic,copy)NSString *titleValue;
@end
