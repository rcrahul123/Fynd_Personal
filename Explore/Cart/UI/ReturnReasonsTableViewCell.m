//
//  ReturnReasonsTableViewCell.m
//  Explore
//
//  Created by Amboj Goyal on 9/21/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ReturnReasonsTableViewCell.h"

@implementation ReturnReasonsTableViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.button];
        
        self.reasonsTitle = [UIButton buttonWithType:UIButtonTypeCustom];// [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.reasonsTitle];
        
        self.seperatorLine = [[SSLine alloc] init];
//        [self.contentView addSubview:self.seperatorLine];

        self.selectedArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)prepareForReuse{
    [self.button setFrame:CGRectZero];
    [self.reasonsTitle setFrame:CGRectZero];
    [self.seperatorLine setFrame:CGRectZero];
    self.button = nil;
    self.reasonsTitle = nil;
    self.seperatorLine = nil;
    self.selectedArray = nil;
    
}

-(void)layoutSubviews{
    [self.button setFrame:CGRectMake(7, self.frame.size.height/2 -14, 28, 28)];
    self.button.tag = self.tag;
    [self.button setBackgroundColor:[UIColor clearColor]];
    [self.button setBackgroundImage:[UIImage imageNamed:@"filter_unselected"] forState:UIControlStateNormal];
    
    if(!self.theReturnModel.isReason_Selected){
        [self.button setBackgroundImage:[UIImage imageNamed:@"filter_unselected"] forState:UIControlStateNormal];
    }
    else{
        [self.button setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
        
    }

    NSAttributedString *titleReturn = [[NSAttributedString alloc] initWithString :self.theReturnModel.reason
                                                                     attributes : @{
                                                                                    NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0],
                                                                                    NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)
                                                                                    }];
    
    [self.button addTarget:self action:@selector(selectionChange:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.reasonsTitle setFrame:CGRectMake(40, self.frame.size.height/2 - 23, 300, 45)];//RelativeSizeHeight(58, 667)
    [self.reasonsTitle setBackgroundColor:[UIColor clearColor]];
    self.reasonsTitle.tag = self.tag;
    [self.reasonsTitle setAttributedTitle:titleReturn forState:UIControlStateNormal];
    [self.reasonsTitle setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.reasonsTitle addTarget:self action:@selector(selectionChange:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.seperatorLine setFrame:CGRectMake(10,self.reasonsTitle.frame.size.height, self.frame.size.width-20, 1)];
    

}

-(void)selectionChange:(id)sender{
    UIButton *btn = (UIButton *)sender;
    //    if([self.feedBackCellDelegate respondsToSelector:@selector(feedBackSettingChange:)]){
    //        [self.feedBackCellDelegate feedBackSettingChange:btn.tag];
    //    }
    
    if([self.returnReasonsCellDelegate respondsToSelector:@selector(returnReasonSettingChange:)]){
        [self.returnReasonsCellDelegate returnReasonSettingChange:btn.tag];
    }

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
