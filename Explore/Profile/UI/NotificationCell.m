//
//  NotificationCell.m
//  Explore
//
//  Created by Pranav on 17/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "NotificationCell.h"
#import "SSUtility.h"


@implementation NotificationCell


- (id)initWithFrame:(CGRect)frame andData:(NSDictionary *)dict{
    if(self == [super initWithFrame:frame]){
        
//        [self setBackgroundColor:[UIColor yellowColor]];
        self.notificationCellDict = dict;
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button addTarget:self action:@selector(settingsChange:) forControlEvents:UIControlEventTouchUpInside];
        
        self.notificationTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.notificationTitle setBackgroundColor:[UIColor clearColor]];
        [self.notificationTitle setFont:[UIFont fontWithName:kMontserrat_Bold size:15.0f]];
        [self.contentView addSubview:self.notificationTitle];
        
        self.notificationDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.notificationDescription setBackgroundColor:[UIColor clearColor]];
        [self.notificationDescription setFont:[UIFont fontWithName:kMontserrat_Light size:15.0f]];
        [self.contentView addSubview:self.notificationDescription];
        
        self.line = [[SSLine alloc] initWithFrame:CGRectMake(10,119, self.frame.size.width, 1)];
        [self.contentView addSubview:self.line];
        
    }
    return self;
}


- (void)layoutSubviews{
    
    [self.button setFrame:CGRectMake(5, 5, 30, 30)];
    self.button.tag = self.tag;
    [self.button setBackgroundColor:[UIColor clearColor]];
    if(![[self.notificationCellDict objectForKey:@"isSelected"] boolValue]){
        [self.button setBackgroundImage:[UIImage imageNamed:@"filter_unselected"] forState:UIControlStateNormal];

    }
    else{
        [self.button setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];

    }
    
    [self.contentView addSubview:self.button];
    
    NSString *optionHeading = [[self.notificationCellDict allKeys] objectAtIndex:0];
    [self.notificationTitle setFrame:CGRectMake(self.button.frame.origin.x + self.button.frame.size.width + 5, self.button.frame.origin.y, self.frame.size.width - self.button.frame.size.width - 10, 30)];
    [self.notificationTitle setText:optionHeading];
    
    NSString *notificationDescriptionString = [self.notificationCellDict objectForKey:[[self.notificationCellDict allKeys] objectAtIndex:0]];
    CGSize aSize = [SSUtility getLabelDynamicSize:notificationDescriptionString withFont:[UIFont fontWithName:kMontserrat_Light size:15.0f] withSize:CGSizeMake(self.notificationTitle.frame.size.width-10, MAXFLOAT)];
    [self.notificationDescription setFrame:CGRectMake(self.notificationTitle.frame.origin.x, self.notificationTitle.frame.origin.y + self.notificationTitle.frame.size.height + 5, aSize.width, aSize.height)];
    [self.notificationDescription setNumberOfLines:0];
    [self.notificationDescription setText:notificationDescriptionString];
}


-(void)settingsChange:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if([self.cellDelegate respondsToSelector:@selector(cellSettingChange:)]){
        [self.cellDelegate cellSettingChange:btn.tag];
    }
}


- (void)prepareForReuse{
    [self.button setFrame:CGRectZero];
    [self.notificationTitle setFrame:CGRectZero];
    [self.notificationTitle setFrame:CGRectZero];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
