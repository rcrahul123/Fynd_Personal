//
//  PopHeaderView.h
//  Explore
//
//  Created by Amboj Goyal on 7/27/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSUtility.h"

typedef void (^PopUpBlock)();
@interface PopHeaderView : UIView{
    UIView *headerView;
     UIImageView    *popupTypeIcon;
     UIButton    *dismissButton;
    UILabel    *headerLabel;

}
@property (nonatomic,copy)PopUpBlock popHeaderBlock;
-(UIView *)popHeaderViewWithTitle:(NSString *)headerTitle andImageName:(NSString *)imageName withOrigin:(CGPoint)theOrigin;
@end
