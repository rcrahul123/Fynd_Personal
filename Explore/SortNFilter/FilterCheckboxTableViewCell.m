//
//  FilterCheckboxTableViewCell.m
//  
//
//  Created by Rahul on 7/16/15.
//
//

#import "FilterCheckboxTableViewCell.h"

@implementation FilterCheckboxTableViewCell


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        checkButton = [[UIImageView alloc] init];
        [self addSubview:checkButton];
        
        valueLabel = [[UILabel alloc] init];
        [self addSubview:valueLabel];
        
        colorView = [[UIImageView alloc] init];
        [self addSubview:colorView];
        separatorView = [[UIView alloc] init];
        [self addSubview:separatorView];
    }
    return self;
}


-(void)prepareForReuse{
    [checkButton setFrame:CGRectZero];
    [valueLabel setFrame:CGRectZero];
    [colorView setFrame:CGRectZero];
    [separatorView setFrame:CGRectZero];
    labelFont = nil;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    labelFont = [UIFont fontWithName:kMontserrat_Regular size:14.0];
    labelFontLight = [UIFont fontWithName:kMontserrat_Light size:14.0];
    [checkButton setFrame:CGRectMake(5, 0, 28, 28)];
    [checkButton setCenter:CGPointMake(checkButton.frame.size.width/2 + 5, self.frame.size.height/2)];
    if(self.model.isFilterSelected){
        [checkButton setImage:[UIImage imageNamed:@"filter_selected"]];
//        [valueLabel setTextColor:UIColorFromRGB(kPinkColor)];
        [valueLabel setTextColor:UIColorFromRGB(KTextColor)];
        [valueLabel setFont:labelFontLight];
    }else{
        [checkButton setImage:[UIImage imageNamed:@"filter_unselected"]];
        [valueLabel setTextColor:UIColorFromRGB(KTextColor)];
        [valueLabel setFont:labelFontLight];
    }
    NSString *text = [NSString stringWithFormat:@"%@ (%ld)", self.model.filterName, (long)self.model.count];
    if(self.model.shouldShowColorCode){
        [colorView setFrame:CGRectMake(self.frame.size.width - 40, self.frame.size.height/2 - 12, 24, 24)];
        [colorView.layer setCornerRadius:3.0];
        colorView.clipsToBounds = YES;

        if([[self.model.filterColorCode lowercaseString] isEqualToString:@"none"]){
            [colorView setBackgroundColor:[UIColor clearColor]];
            [colorView setImage:[UIImage imageNamed:@"multi"]];
        }else{
//            if([[self.model.filterColorCode lowercaseString] containsString:@"ffffff"]){
            if([[self.model.filterColorCode lowercaseString] rangeOfString:@"ffffff"].length>0){
                colorView.layer.borderColor = UIColorFromRGB(0xD0D0D0).CGColor;
                colorView.layer.borderWidth = 1.0;
            }
            [colorView setBackgroundColor:[SSUtility colorFromHexString:[NSString stringWithFormat:@"#%@",self.model.filterColorCode]]];
        }
        
        
//    if(self.model.filterColorCode != (id)[NSNull null]){
//        if([[self.model.filterColorCode lowercaseString] containsString:@"ffffff"]){
//            colorView.layer.borderColor = UIColorFromRGB(0xD0D0D0).CGColor;
//            colorView.layer.borderWidth = 1.0;
//        }
//        [colorView setBackgroundColor:[SSUtility colorFromHexString:[NSString stringWithFormat:@"#%@",self.model.filterColorCode]]];
//    }else{
//        [colorView setBackgroundColor:[UIColor clearColor]];
//        [colorView setImage:[UIImage imageNamed:@"multi"]];
//    }
        valueLabelSize = [SSUtility getLabelDynamicSize:text withFont:labelFont withSize:CGSizeMake(colorView.frame.origin.x - checkButton.frame.origin.x - checkButton.frame.size.width - 15, self.frame.size.height)];

    }else{
        
        [colorView setFrame:CGRectMake(self.frame.size.width, 0, 0, 0)];
        valueLabelSize = [SSUtility getLabelDynamicSize:text withFont:labelFont withSize:CGSizeMake(colorView.frame.origin.x - checkButton.frame.origin.x - checkButton.frame.size.width - 15, self.frame.size.height)];
    }
    [valueLabel setFrame:CGRectMake(checkButton.frame.origin.x + checkButton.frame.size.width + 5, 0, valueLabelSize.width, valueLabelSize.height)];
    [valueLabel setText:text];
    valueLabel.numberOfLines = 0;
    valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [valueLabel setCenter:CGPointMake(valueLabel.center.x, checkButton.center.y)];
    [checkButton setCenter:CGPointMake(checkButton.center.x, checkButton.center.y + 2)];
    
//    if(self.model.index != 0){
//        [separatorView setFrame:CGRectMake(13, 2, self.frame.size.width - 15, 1)];
//        [separatorView setBackgroundColor:UIColorFromRGB(0xD0D0D0)];
//    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
