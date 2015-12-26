//
//  FyndErrorInfoView.h
//  Explore
//
//  Created by Pranav on 09/10/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ ErrorAnimationComplete)();
@interface FyndErrorInfoView : UIView


-(void)showErrorView:(NSString *)erroMessage withRect:(CGRect)rect;
-(void)animteErrorView:(CGPoint)destinationPoint;

@property (nonatomic,copy) ErrorAnimationComplete errorAnimationBlock;
@end
