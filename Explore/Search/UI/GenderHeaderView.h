//
//  GenderHeaderView.h
//  Explore
//
//  Created by Amboj Goyal on 8/5/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+FontWithNameAndSize.h"
typedef void (^TapAction)(id sender);
@interface GenderHeaderView : UIView<UIScrollViewDelegate>{
    
}
@property (nonatomic,strong) UIScrollView *theScrollView;
@property (nonatomic,strong) UIView * scrollLineBar;
@property (nonatomic,strong) TapAction onTapAction;
@property (nonatomic,assign) NSInteger  defaultGenderIndex;
@property (nonatomic, strong) UIColor *backgroundColor;

-(void)configureScrollView;
-(NSArray *)configureViewWithData:(NSArray *)dataArray withSelectedObjectAtIndex:(NSInteger)selectedIndex;
-(void)updateScroller:(id)sender withAnimation:(BOOL)aBool;
- (void)setGenderScrollerToDefaultIndex:(NSInteger)index;
@end
