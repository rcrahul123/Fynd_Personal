//
//  PDPFeedBackTableViewCell.h
//  Explore
//
//  Created by Pranav on 18/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLine.h"

@protocol FeedBackCellDelegate;

@interface PDPFeedBackTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UILabel *feedBackTitle;
@property (nonatomic,strong) NSDictionary   *feedBackCellDict;
@property (nonatomic,strong) SSLine         *feedBackline;

@property (nonatomic,unsafe_unretained) id<FeedBackCellDelegate>feedBackCellDelegate;
- (id)initWithFrame:(CGRect)frame andData:(NSDictionary *)dict;
@end

@protocol FeedBackCellDelegate<NSObject>
- (void)feedBackSettingChange:(NSInteger)cellTag;
@end
