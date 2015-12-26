//
//  FilterHeaderCellTableViewCell.m
//  Explore
//
//  Created by Rahul Chaudhari on 26/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "FilterHeaderTableViewCell.h"

@implementation FilterHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        categoryImage = [[UIImageView alloc] init];
        [self addSubview:categoryImage];
        
        categoryNameLabel = [[UILabel alloc] init];
        [self addSubview:categoryNameLabel];
        
        selectionMark = [[UIView alloc] init];
        [self addSubview:selectionMark];
    }
    return self;
}

-(void)prepareForReuse{
    [categoryNameLabel setFrame:CGRectZero];
    [categoryNameLabel setFrame:CGRectZero];
    [selectionMark setFrame:CGRectZero];
    self.filterModel = nil;
    labelFont = nil;
}


-(void)layoutSubviews{
    
    labelFont = [UIFont fontWithName:kMontserrat_Light size:14.0];
    labelFontBold = [UIFont fontWithName:kMontserrat_Regular size:14.0];
    
//    [categoryImage setFrame:CGRectMake(0, 0, 65, 65)];
    
    
    [categoryNameLabel setTextAlignment:NSTextAlignmentCenter];
    [categoryNameLabel setText:self.filterModel.displayName];
//    [categoryNameLabel sizeToFit];
    
    
    UIImage *image;;
    if(self.isCurrentCell){
        [categoryNameLabel setTextColor:UIColorFromRGB(kPinkColor)];
        [categoryNameLabel setFont:labelFontBold];
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_filter_selected", self.filterModel.filterType]];
    }else{
        [categoryNameLabel setTextColor:UIColorFromRGB(KTextColor)];
        [categoryNameLabel setFont:labelFont];
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_filter", self.filterModel.filterType]];
    }
    [categoryImage setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [categoryImage setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - image.size.height/2 + 20)];

    [categoryNameLabel setFrame:CGRectMake(0, categoryImage.frame.origin.y + categoryImage.frame.size.height, self.frame.size.width - 30, 17)];
    [categoryNameLabel setCenter:CGPointMake(self.frame.size.width/2, categoryNameLabel.center.y)];

    [categoryImage setImage:image];
    
    if(self.filterModel.isAnyValueSelected){
//        [selectionMark setFrame:CGRectMake(self.frame.size.width - 20, categoryNameLabel.center.y - 5, 10, 10)];
        [selectionMark setFrame:CGRectMake(categoryImage.frame.origin.x - 13, categoryImage.center.y - 5, 7, 7)];
        [selectionMark setBackgroundColor:UIColorFromRGB(kPinkColor)];
        [selectionMark.layer setCornerRadius:5];
    }else{
        [selectionMark setFrame:CGRectZero];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
