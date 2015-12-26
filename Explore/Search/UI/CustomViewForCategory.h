//
//  CustomViewForCategory.h
//  Explore
//
//  Created by Amboj Goyal on 8/1/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewForCategory : UIButton

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *headerTitle;
@property (nonatomic, assign) CGSize headerTitleSize;
@property (nonatomic,strong)NSString *selectedImageName;
@property (nonatomic,strong)NSString *imageName;
-(id)initWithFrame:(CGRect)frame;
-(void)configureView;

@end
