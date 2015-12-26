//
//  CustomViewForCategory.m
//  Explore
//
//  Created by Amboj Goyal on 8/1/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CustomViewForCategory.h"


@implementation CustomViewForCategory

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

-(void)configureView{
//    CGPoint centerY = CGPointMake(0, self.frame.size.height/2 - _headerTitleSize.height/2) ;
////    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2 - 15, 25, 30)];
//    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, self.frame.size.height/2 - 10, 25, 25)];
//    [_headerImageView setBackgroundColor:[UIColor clearColor]];
//    [self addSubview:_headerImageView];
//    
//    _headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(_headerImageView.frame.size.width + _headerImageView.frame.origin.x ,centerY.y , _headerTitleSize.width, _headerTitleSize.height)];
//    [_headerTitle setTextColor:UIColorFromRGB(kSignUpColor)];
//    [_headerTitle setFont:[UIFont variableFontWithName:kMontserrat_Light size:16.0f]];
//    [self addSubview:_headerTitle];
    
    
    //icon on top and text below icon
//    CGPoint centerX = CGPointMake(self.frame.size.width/2 - _headerTitleSize.width/2,0) ;
//    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 13, 0, 25, 25)];
//
//    [_headerImageView setBackgroundColor:[UIColor clearColor]];
//    [self addSubview:_headerImageView];
//    
////    _headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(centerX.x-2,_headerImageView.frame.size.height + _headerImageView.frame.origin.y , _headerTitleSize.width, _headerTitleSize.height)];
//    _headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(centerX.x,_headerImageView.frame.size.height + _headerImageView.frame.origin.y , _headerTitleSize.width, _headerTitleSize.height)];
//    [_headerTitle setTextColor:UIColorFromRGB(kSignUpColor)];
//    [_headerTitle setBackgroundColor:[UIColor clearColor]];
//    [_headerTitle setFont:[UIFont fontWithName:kMontserrat_Light size:13.65f]];
//    [self addSubview:_headerTitle];
    
    
    //icon and text side by side
    CGPoint centerX = CGPointMake(self.frame.size.width/2 - _headerTitleSize.width/2,0) ;
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX.x - 25, 0, 25, 25)];
    
    [_headerImageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_headerImageView];
    
    //    _headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(centerX.x-2,_headerImageView.frame.size.height + _headerImageView.frame.origin.y , _headerTitleSize.width, _headerTitleSize.height)];
    _headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(centerX.x + _headerImageView.frame.size.width/2,_headerImageView.frame.size.height + _headerImageView.frame.origin.y , _headerTitleSize.width, _headerTitleSize.height)];
    [_headerTitle setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [_headerTitle setBackgroundColor:[UIColor clearColor]];
    [_headerTitle setFont:[UIFont fontWithName:kMontserrat_Light size:13.65f]];
    [self addSubview:_headerTitle];
    
    [_headerTitle setCenter:CGPointMake(_headerTitle.center.x, self.frame.size.height/2)];
    [_headerImageView setCenter:CGPointMake(_headerImageView.center.x, self.frame.size.height/2)];

    
}


@end
