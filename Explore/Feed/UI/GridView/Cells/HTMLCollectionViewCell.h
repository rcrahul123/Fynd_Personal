//
//  HTMLCollectionViewCell.h
//  Explore
//
//  Created by Rahul Chaudhari on 09/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTMLTileModel.h"
@protocol HTMLGridDelegate;
@interface HTMLCollectionViewCell : UICollectionViewCell<UIWebViewDelegate>{
    UIActivityIndicatorView *indicator;
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) HTMLTileModel *model;
@property (nonatomic,unsafe_unretained) id<HTMLGridDelegate> htmlDelegate;



@end
@protocol HTMLGridDelegate <NSObject>
- (void)showScreen:(NSString *)screenName;
- (void)webViewLoaded:(UIWebView*)webView;

@end