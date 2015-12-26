//
//  PopHeaderView.m
//  Explore
//
//  Created by Amboj Goyal on 7/27/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PopHeaderView.h"

@implementation PopHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIView *)popHeaderViewWithTitle:(NSString *)headerTitle andImageName:(NSString *)imageName withOrigin:(CGPoint)theOrigin{
//     headerView = [[UIView alloc] initWithFrame:CGRectMake(-10,  frame.origin.y-110, DeviceWidth,64)];
     headerView = [[UIView alloc] initWithFrame:CGRectMake(theOrigin.x,  theOrigin.y, DeviceWidth,64)];
    [headerView setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
    
    CGSize textSize = [SSUtility getLabelDynamicSize:headerTitle withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f ] withSize:CGSizeMake(MAXFLOAT, 40)];
    
     dismissButton = [[UIButton alloc] initWithFrame:CGRectMake( headerView.frame.size.width - 45,26,32,32)];
    [dismissButton setBackgroundImage:[UIImage imageNamed:@"Cross"] forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismissPopUp:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview: dismissButton];
    
     headerLabel = [[UILabel alloc] initWithFrame:CGRectMake( DeviceWidth/2 - textSize.width/2, 24, textSize.width, 40)];
    [headerLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];

    [headerLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f ]];
    [headerLabel setText:headerTitle];
    [headerView addSubview: headerLabel];
    

    popupTypeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(headerLabel.frame.origin.x -35, 28, 32, 32)];
    [popupTypeIcon setBackgroundColor:[UIColor clearColor]];
    [popupTypeIcon setImage:[UIImage imageNamed:imageName]];
    [headerView addSubview: popupTypeIcon];
    
    return  headerView;
}

-(void)dismissPopUp:(id)sender{
    if (self.popHeaderBlock) {
        self.popHeaderBlock();
    }
}

@end
