//
//  ReturnReasonsTableViewCell.h
//  Explore
//
//  Created by Amboj Goyal on 9/21/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLine.h"
#import "ReturnReasons.h"

@protocol ReturnReasonsCellDelegate;

@interface ReturnReasonsTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIButton *reasonsTitle;
@property (nonatomic,strong) NSDictionary   *reasonsArray;
@property (nonatomic,strong) SSLine         *seperatorLine;

@property (nonatomic,strong)ReturnReasons *theReturnModel;
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic,strong)NSMutableArray *selectedArray;
@property (nonatomic,unsafe_unretained) id<ReturnReasonsCellDelegate>returnReasonsCellDelegate;
@end

@protocol ReturnReasonsCellDelegate<NSObject>
- (void)returnReasonSettingChange:(NSInteger)cellTag;
@end
