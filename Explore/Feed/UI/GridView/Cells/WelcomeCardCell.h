//
//  WelcomeCardCell.h
//  Explore
//
//  Created by Amboj Goyal on 11/24/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WelcomeCardBlock)(NSString *cardType);

@interface WelcomeCardCell : UICollectionViewCell{
    UIImageView *cardImageView;
    UILabel *headerLabel;
    UILabel *descriptionLabel;
        UIButton *container;
    UIButton *trackOrderButton;
    
}
@property (nonatomic,assign) BOOL isOrderCard;
@property (nonatomic,strong) WelcomeCardBlock theCallBackBlock;
@end
