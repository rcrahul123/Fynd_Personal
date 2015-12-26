//
//  FyndErrorInfoView.m
//  Explore
//
//  Created by Pranav on 09/10/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "FyndErrorInfoView.h"

@implementation FyndErrorInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



CGPoint animatePoint;
-(void)showErrorView:(NSString *)erroMessage withRect:(CGRect)rect{
//    errorView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y-50, rect.size.width, 50)];
    [self setBackgroundColor:UIColorFromRGB(kRedColor)];
    NSString *infoString = erroMessage;
    CGSize size = [SSUtility getLabelDynamicSize:infoString withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    UILabel *info = [SSUtility generateLabel:infoString withRect:CGRectMake(self.frame.size.width/2 - size.width/2, self.frame.size.height/2 - size.height/2, size.width, size.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [info setTextColor:[UIColor whiteColor]];
    [self addSubview:info];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self];
    
    animatePoint = CGPointMake(rect.origin.y,0);
    [self animteErrorView:animatePoint];
}



-(void)animteErrorView:(CGPoint)destinationPoint{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    [self setFrame:CGRectMake(self.frame.origin.x, destinationPoint.y, self.frame.size.width,self.frame.size.height)];
    [UIView commitAnimations];
}



- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [UIView animateWithDuration:5.0f animations:^{
        self.alpha = 0.0f;
    }
                     completion:^(BOOL finished) {
                         if(self.errorAnimationBlock){
                             self.errorAnimationBlock();
                        }
                     }];
    
}


@end
