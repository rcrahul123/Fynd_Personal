//
//  NotificationCell.h
//  Explore
//
//  Created by Pranav on 17/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLine.h"

@protocol NotificationCellDelegate;
@interface NotificationCell : UITableViewCell

@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UILabel *notificationTitle;
@property (nonatomic,strong) UILabel *notificationDescription;
@property (nonatomic,strong) NSDictionary   *notificationCellDict;
@property (nonatomic,strong) SSLine         *line;
@property (nonatomic,unsafe_unretained) id<NotificationCellDelegate>cellDelegate;

- (id)initWithFrame:(CGRect)frame andData:(NSDictionary *)dict;
@end

@protocol NotificationCellDelegate<NSObject>
- (void)cellSettingChange:(NSInteger)cellTag;
@end