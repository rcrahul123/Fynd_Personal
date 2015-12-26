//
//  MyAccountDetailViewController.h
//  Explore
//
//  Created by Pranav on 11/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ViewController.h"

typedef void (^RefreshUserImage)(NSString *imageString);
typedef void (^UpdateAddress)(id addModel);

@protocol MyAccountDetailViewDelegate;

@interface MyAccountDetailViewController : ViewController<UIImagePickerControllerDelegate>
@property (nonatomic,strong) NSString   *detailTitle;
@property (nonatomic,assign) AccountDetailType type;
@property (nonatomic,copy) RefreshUserImage  refreshUserImage;
@property (nonatomic,assign) ShippingAddressType theShipType; //TODO - No need of this Enum
@property (nonatomic,copy) UpdateAddress  theAddBlock;
@property (nonatomic,unsafe_unretained) id<MyAccountDetailViewDelegate>profileDetailDelegate;
@end


@protocol MyAccountDetailViewDelegate <NSObject>
- (void)fetchUpdatedData:(BOOL)aBool andProfileString:(NSString *)imageUrl;
@end