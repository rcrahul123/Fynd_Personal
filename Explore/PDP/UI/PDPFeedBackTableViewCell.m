//
//  PDPFeedBackTableViewCell.m
//  Explore
//
//  Created by Pranav on 18/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PDPFeedBackTableViewCell.h"
#import "SSUtility.h"

@implementation PDPFeedBackTableViewCell

- (id)initWithFrame:(CGRect)frame andData:(NSDictionary *)dict{
    
    if(self ==[super initWithFrame:frame]){
        
        self.feedBackCellDict = dict;
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button addTarget:self action:@selector(settingsChange:) forControlEvents:UIControlEventTouchUpInside];
        
        self.feedBackTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.feedBackTitle setBackgroundColor:[UIColor clearColor]];
        [self.feedBackTitle setFont:[UIFont fontWithName:kMontserrat_Bold size:15.0f]];
        [self.contentView addSubview:self.feedBackTitle];

        self.feedBackline = [[SSLine alloc] initWithFrame:CGRectMake(10,79, self.frame.size.width, 1)];
        [self.contentView addSubview:self.feedBackline];
    }
    
    return self;
}


-(void)settingsChange:(id)sender{
    UIButton *btn = (UIButton *)sender;
//    if([self.feedBackCellDelegate respondsToSelector:@selector(feedBackSettingChange:)]){
//        [self.feedBackCellDelegate feedBackSettingChange:btn.tag];
//    }
    
    if([self.feedBackCellDelegate respondsToSelector:@selector(feedBackSettingChange:)]){
        [self.feedBackCellDelegate feedBackSettingChange:btn.tag];
    }
}


- (void)layoutSubviews{
    
    [self.button setFrame:CGRectMake(5, 5, 30, 30)];
    self.button.tag = self.tag;
    [self.button setBackgroundColor:[UIColor clearColor]];
   
    [self.contentView addSubview:self.button];
    
    NSString *optionHeading =  [self.feedBackCellDict objectForKey:@"FeedBackTitle"];
    [self.feedBackTitle setFrame:CGRectMake(self.button.frame.origin.x + self.button.frame.size.width + 5, self.button.frame.origin.y, self.frame.size.width - self.button.frame.size.width - 10, 30)];
    [self.feedBackTitle setText:optionHeading];
    [self.feedBackTitle setFont:[UIFont fontWithName:kMontserrat_Bold size:14.0f]];
    
    if(![[self.feedBackCellDict objectForKey:@"isSelected"] boolValue]){
        [self.button setBackgroundImage:[UIImage imageNamed:@"filter_unselected"] forState:UIControlStateNormal];
        [self.feedBackTitle setTextColor:UIColorFromRGB(kBackgroundGreyColor)];
    }
    else{
        [self.feedBackTitle setTextColor:UIColorFromRGB(kRedColor)];
        [self.button setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
        
    }
    
}


- (void)prepareForReuse{
    [self.button setFrame:CGRectZero];
    [self.feedBackTitle setFrame:CGRectZero];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
