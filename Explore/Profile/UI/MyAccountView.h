//
//  MyAccountView.h
//  Explore
//
//  Created by Pranav on 10/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyAccountOptionsData;

typedef void (^AccountDetail)(MyAccountOptionsData *data);

@protocol MyAccountViewDelegate;
@interface MyAccountView : UIView

@property (nonatomic,copy)  AccountDetail accountBlock;

@property (nonatomic,unsafe_unretained) id<MyAccountViewDelegate>detailDelegate;
- (void)setUpMyAccountOptions;
- (NSArray *)generateAccountTabData;


@end

@protocol MyAccountViewDelegate<NSObject>
- (void)selectedDetailOption:(MyAccountOptionsData *)optionData;
- (void)moreOptionsDisplaying:(BOOL)isMore;
@end

@interface MyAccountOptionsData:NSObject
{
    NSString            *optionTitle;
    NSString            *optionImageName;
    AccountDetailType   optionDetailType;
}
@property (nonatomic,strong) NSString     *optionTitle;
@property (nonatomic,strong) NSString     *optionImageName;
@property (nonatomic,assign) AccountDetailType   optionDetailType;

@end
