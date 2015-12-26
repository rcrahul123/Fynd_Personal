//
//  MyAccountView.m
//  Explore
//
//  Created by Pranav on 10/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "MyAccountView.h"
#import "SSUtility.h"
#import "SSLine.h"

@implementation MyAccountOptionsData
@synthesize optionTitle, optionImageName, optionDetailType;

- (id)init{
    if(self == [super init]){
        
    }
    return self;
}

@end

@interface MyAccountView() <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *optionsTableView;
@property (nonatomic,strong) NSArray *itemsArray;
@property (nonatomic,assign) BOOL moreOptionsClicked;
@end

CGFloat learnMoreCellHeight = 44.0f;
@implementation MyAccountView


-(id)initWithFrame:(CGRect)frame{
    
    if(self == [super initWithFrame:frame]){
    }
    return self;
}

- (NSArray *)generateAccountTabData{
    NSMutableArray *optionsDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSInteger counter=0; counter < 3; counter++){
        NSMutableDictionary *optionDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        if(counter==0){
            NSMutableArray *optionsArray = [[NSMutableArray alloc] initWithCapacity:0];
            for(NSInteger innerCounter=0; innerCounter < 3; innerCounter++){
                MyAccountOptionsData *data = [[MyAccountOptionsData alloc] init];
                if(innerCounter == 5){
                    data.optionTitle = @"Edit Profile";
                    data.optionImageName = @"EditProfile";
                    data.optionDetailType = AccountDetailEditProfile;
                }else if(innerCounter ==0){
                    data.optionTitle = @"My Brands";
                    data.optionImageName = @"MyBrands";
                    data.optionDetailType = AccountDetailMyBrands;
                }else if(innerCounter ==1){
                    data.optionTitle = @"My Collections";
                    data.optionImageName = @"MyCollections";
                    data.optionDetailType = AccountDetailMyCollections;
                }else if(innerCounter ==2){
                    data.optionTitle = @"Delivery Address";
                    data.optionImageName = @"ShippingAddress";
                    data.optionDetailType = AccountDetailShippingAddress;
                }
               
                else if(innerCounter ==3){
                    data.optionTitle = @"Change Password";
                    data.optionImageName = @"ChangePassword";
                    data.optionDetailType = AccountDetailChangePassword;
                }
                [optionsArray addObject:data];
            }
            [optionDictionary setObject:optionsArray forKey:@"ACCOUNTS"];
        }
        else if(counter ==1){
            
            NSMutableArray *optionsArray = [[NSMutableArray alloc] initWithCapacity:0];
            for(NSInteger innerCounter=0; innerCounter < 1; innerCounter++){
                MyAccountOptionsData *data = [[MyAccountOptionsData alloc] init];
                if(innerCounter == 0){
//                    data.optionTitle = @"Delivery Address";
//                    data.optionImageName = @"ShippingAddress";
//                    data.optionDetailType = AccountDetailShippingAddress;
//                }

                    data.optionTitle = @"ProfileFlashPayText";
                    data.optionImageName = @"ProfileFlashPayLogo";
                    data.optionDetailType = AccountDetailPayments;
                }
//                else if(innerCounter ==2){
//                    data.optionTitle = @"Fynd Credits";
//                    data.optionImageName = @"FAQ";
//                    data.optionDetailType = AccountDetailFAQ;
//                }
                [optionsArray addObject:data];
            }
            [optionDictionary setObject:optionsArray forKey:@"DETAILS"];
        }
        else if(counter ==2){
            
            NSMutableArray *optionsArray = [[NSMutableArray alloc] initWithCapacity:0];
            for(NSInteger innerCounter=0; innerCounter < 4; innerCounter++){
                MyAccountOptionsData *data = [[MyAccountOptionsData alloc] init];
               
                if(innerCounter == 0){
                    data.optionTitle = @"Return Policy";
                    data.optionImageName = @"Return";
                    data.optionDetailType = AccountDetailReturnPolicy;
                    
                }else if(innerCounter ==1){
                    data.optionTitle = @"Privacy Policy";
                    data.optionImageName = @"PrivacyPolicy";
                    data.optionDetailType = AccountDetailPrivacyPolicy;
                }
                else if(innerCounter ==2){
                    data.optionTitle = @"Terms Of Service";
                    data.optionImageName = @"TermsOfService";
                    data.optionDetailType = AccountDetailTermsOfService;
                }
                else if(innerCounter ==3){
                    data.optionTitle = @"FAQ";
                    data.optionImageName = @"FAQ";
                    data.optionDetailType = AccountDetailFAQ;
                }
                
                [optionsArray addObject:data];
            }
            [optionDictionary setObject:optionsArray forKey:@"Learn More"];
        }
//        else if(counter==3){
//            
//            NSMutableArray *optionsArray = [[NSMutableArray alloc] initWithCapacity:0];
//            for(NSInteger innerCounter=0; innerCounter < 3; innerCounter++){
//                MyAccountOptionsData *data = [[MyAccountOptionsData alloc] init];
//                if(innerCounter == 0){
//                    data.optionTitle = @"Terms Of Service";
//                    data.optionImageName = @"TermsOfService";
//                    data.optionDetailType = AccountDetailTermsOfService;
//                }else if(innerCounter ==1){
//                    data.optionTitle = @"Privacy Policy";
//                    data.optionImageName = @"PrivacyPolicy";
//                    data.optionDetailType = AccountDetailPrivacyPolicy;
//                }
//                else if(innerCounter ==2){
//                    data.optionTitle = @"Return Policy";
//                    data.optionImageName = @"Return";
//                    data.optionDetailType = AccountDetailReturnPolicy;
//                }
//                
//                
//                [optionsArray addObject:data];
//            }
//            [optionDictionary setObject:optionsArray forKey:@"ABOUT"];
//        }
        
        
        [optionsDataArray addObject:optionDictionary];
    }
    
    
    return [optionsDataArray copy];
    
}




- (void)setUpMyAccountOptions{
    
    self.itemsArray = [self generateAccountTabData];
    [self setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
//    [self setBackgroundColor:[UIColor yellowColor]];
    
    self.optionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(RelativeSize(6, 320), 0, self.frame.size.width-RelativeSize(12, 320), self.frame.size.height) style:UITableViewStyleGrouped];
    [self.optionsTableView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
//    [self.optionsTableView setBackgroundColor:[UIColor redColor]];
    self.optionsTableView.alwaysBounceVertical = NO;
    self.optionsTableView.dataSource = self;
    self.optionsTableView.delegate = self;
    [self.optionsTableView setTag:300];
    [self.optionsTableView setShowsVerticalScrollIndicator:FALSE];
    [self.optionsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:self.optionsTableView];
}



#pragma mark UITableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.itemsArray count]+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40.0f;
    CGFloat headerHeight = 0.0f;
    if(section==2 || section==3){
//        headerHeight = 40.0f;
        headerHeight = 44.0f;

    }else{
        headerHeight = 5.0f;
    }
    return headerHeight;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat footerHeight = 5.0f;
    
    if (section == 1 || section == 2) {
        footerHeight = 10.0f;
    }
    return footerHeight;
}





- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = nil;
    
    if(section ==2){
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.optionsTableView.frame.size.width, 44)];
        [headerView setBackgroundColor:[UIColor whiteColor]];
//        [headerView.layer setCornerRadius:3.0f];
//        [headerView setClipsToBounds:TRUE];

        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setImage:[UIImage imageNamed:@"LearnMore"]];
        [headerView addSubview:imageView];
        
        
        
        NSDictionary *headerDict = [self.itemsArray objectAtIndex:section];
        NSString *headerTitle = [[headerDict allKeys] objectAtIndex:0];
        
        
        UIButton *moreStoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreStoreBtn setBackgroundColor:[UIColor clearColor]];

        [moreStoreBtn setFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 5, imageView.frame.origin.y, self.optionsTableView.frame.size.width-50, 30)];
        moreStoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [moreStoreBtn setTitle:headerTitle forState:UIControlStateNormal];

        [moreStoreBtn addTarget:self action:@selector(showMoreOptions:) forControlEvents:UIControlEventTouchUpInside];
        [moreStoreBtn.titleLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [moreStoreBtn setTitleColor:UIColorFromRGB(kSignUpColor) forState:UIControlStateNormal];

        UIImageView *plusIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.optionsTableView.frame.size.width-40, 3, 35, 35)];
        [plusIcon setBackgroundColor:[UIColor clearColor]];
        [plusIcon setImage:[UIImage imageNamed:@"PlusGrey"]];
        [plusIcon setTag:980];
        [headerView addSubview:plusIcon];
        
        
        [headerView addSubview:moreStoreBtn];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds
                                                       byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight
                                                             cornerRadii:CGSizeMake(3.0, 3.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = headerView.bounds;
        maskLayer.path = maskPath.CGPath;
        headerView.layer.mask = maskLayer;

        
    }
    else if(section ==3){
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.optionsTableView.frame.size.width, 44)];
        [headerView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
        
        UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.optionsTableView.frame.size.width, 44)];
        [cView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
        
        NSInteger addToCartStartPoint =0;
       
        
        UIButton  *rateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rateBtn.layer.cornerRadius = 3.0f;
        [rateBtn setFrame:CGRectMake(addToCartStartPoint, 0, (self.frame.size.width -(3*5))/2, 44)];
        [rateBtn setBackgroundImage:[SSUtility imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [rateBtn setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
        [rateBtn setClipsToBounds:YES];
    
        [rateBtn addTarget:self action:@selector(handleCallRateAcrion:) forControlEvents:UIControlEventTouchUpInside];
        [rateBtn setTag:0];
        
        UIImageView *rateUsImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
        [rateUsImage setBackgroundColor:[UIColor clearColor]];
        [rateUsImage setImage:[UIImage imageNamed:@"RateUs"]];
        [rateBtn addSubview:rateUsImage];
        
        
        UILabel *rateusLbl = [[UILabel alloc] initWithFrame:CGRectMake(rateUsImage.frame.origin.x + rateUsImage.frame.size.width + 5, 0, 70, 44)];
        [rateusLbl setTextAlignment:NSTextAlignmentLeft];
        [rateusLbl setText:@"Rate Us"];
        [rateusLbl setTextColor:UIColorFromRGB(kSignUpColor)];
        [rateusLbl setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [rateBtn addSubview:rateusLbl];
        
        [cView addSubview:rateBtn];
        
        addToCartStartPoint+=  rateBtn.frame.origin.x + rateBtn.frame.size.width + 5;

        
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        callBtn.layer.cornerRadius = 3.0f;
        [callBtn setFrame:CGRectMake(addToCartStartPoint, rateBtn.frame.origin.y, self.frame.size.width - (addToCartStartPoint+13), 44)];
        [callBtn setBackgroundImage:[SSUtility imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [callBtn setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
        

        [callBtn setClipsToBounds:YES];
        [callBtn setTag:1];


        [callBtn addTarget:self action:@selector(handleCallRateAcrion:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *callUsImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
        [callUsImage setBackgroundColor:[UIColor clearColor]];
        [callUsImage setImage:[UIImage imageNamed:@"CallUs"]];
        [callBtn addSubview:callUsImage];
        
        
        UILabel *callUsLabel = [[UILabel alloc] initWithFrame:CGRectMake(callUsImage.frame.origin.x + callUsImage.frame.size.width + 5, 0, 70, 44)];
        [callUsLabel setTextAlignment:NSTextAlignmentLeft];
        [callUsLabel setText:@"Call Us"];
        [callUsLabel setTextColor:UIColorFromRGB(kSignUpColor)];
        [callUsLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [callBtn addSubview:callUsLabel];
        
        
        [cView addSubview:callBtn];

        [headerView addSubview:cView];
        
    }
    return headerView;
}


- (void)handleCallRateAcrion:(id)sender{
    
    UIButton *btnTag = (UIButton *)sender;
//    NSDictionary *selectedDict = [self.itemsArray objectAtIndex:[self.itemsArray count]];
//    NSArray *sectionOptions = [selectedDict objectForKey:[[selectedDict allKeys] objectAtIndex:0]];
//    MyAccountOptionsData *selectedData = [sectionOptions objectAtIndex:btnTag.tag];
    
    MyAccountOptionsData *data = [[MyAccountOptionsData alloc] init];

     if(btnTag.tag == 0){
         data.optionTitle = @"Rate Us";
         data.optionImageName = @"RateUs";
         data.optionDetailType = AccountDetailRateUS;
     }else if(btnTag.tag ==1){
         data.optionTitle = @"Call Us";
         data.optionImageName = @"CallUs";
         data.optionDetailType = AccountDetailCallUS;

     }
    
    if([self.detailDelegate respondsToSelector:@selector(selectedDetailOption:)]){
        [self.detailDelegate selectedDetailOption:data];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount =0;
    
    if(section !=3){
        NSDictionary *dict = [self.itemsArray objectAtIndex:section];
        rowCount  = [[dict objectForKey:[[dict allKeys] objectAtIndex:0]] count];
        
        if(section ==2){
            if(self.moreOptionsClicked){
                rowCount = 4;
            }else
            {
                rowCount = 0;
            }
        }
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"My Account";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary *dict = [self.itemsArray objectAtIndex:indexPath.section];
    NSArray *valueArray = [dict objectForKey:[[dict allKeys] objectAtIndex:0]];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setFrame:CGRectMake(cell.frame.origin.x,cell.frame.origin.y , tableView.frame.size.width, cell.frame.size.height)];

    
    UIImageView *imgView =(UIImageView *)[cell.contentView viewWithTag:4132];
    if(imgView){
        [imgView removeFromSuperview];
        imgView = nil;
        
    }
    
    
    UILabel *textLbl =(UILabel *)[cell.contentView viewWithTag:132];
    if(textLbl){
        [textLbl removeFromSuperview];
        textLbl = nil;
        
    }

    SSLine *bottomLine =(SSLine *)[cell.contentView viewWithTag:888];
    if(bottomLine){
        [bottomLine removeFromSuperview];
        bottomLine = nil;
        
    }

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
    [imageView setTag:4132];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setImage:[UIImage imageNamed:[[valueArray objectAtIndex:indexPath.row] optionImageName]]];
    [cell.contentView addSubview:imageView];

    if([[[valueArray objectAtIndex:indexPath.row] optionTitle] rangeOfString:@"ProfileFlashPayText"].length > 0){
        UIImage *textImage = [UIImage imageNamed:[[valueArray objectAtIndex:indexPath.row] optionTitle]];
        UIImageView *textImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 5, cell.frame.size.height/2 - textImage.size.height/2, textImage.size.width, textImage.size.height)];
        [textImageView setImage:textImage];
        [cell.contentView addSubview:textImageView];
        cell.layer.cornerRadius = 3.0;
        cell.clipsToBounds = YES;

        
    }else{
        UILabel *optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 5, 0, cell.frame.size.width - 50, 40)];
        [optionLabel setTag:132];
        [optionLabel setBackgroundColor:[UIColor clearColor]];
        [optionLabel setTextColor:UIColorFromRGB(kSignUpColor)];
        [optionLabel setText:[[valueArray objectAtIndex:indexPath.row] optionTitle]];
        [optionLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [cell.contentView addSubview:optionLabel];
    }

    if (indexPath.row == 0 && indexPath.section != 2) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                                       byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                             cornerRadii:CGSizeMake(3.0, 3.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
        
    }
    if (indexPath.row == 0 && indexPath.section == 2) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                                       byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight |UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                             cornerRadii:CGSizeMake(0.0, 0.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }
    if (indexPath.row != [valueArray count]-1) {
        
        SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(10, cell.frame.size.height-1, self.optionsTableView.frame.size.width - 20, 1)];
        line.tag = 888;
        [cell.contentView addSubview:line];
    }
    if(indexPath.row == [valueArray count]-1){

        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                                       byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                             cornerRadii:CGSizeMake(3.0, 3.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }
        
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    NSDictionary *selectedDict = [self.itemsArray objectAtIndex:indexPath.section];
    NSArray *sectionOptions = [selectedDict objectForKey:[[selectedDict allKeys] objectAtIndex:0]];
    MyAccountOptionsData *selectedData = [sectionOptions objectAtIndex:indexPath.row];
    
    if([self.detailDelegate respondsToSelector:@selector(selectedDetailOption:)]){
        [self.detailDelegate selectedDetailOption:selectedData];
    }
}




- (void)showMoreOptions:(id)sender{
    UIButton * sectionView = (UIButton *)sender;
    self.moreOptionsClicked = !self.moreOptionsClicked;
    
    if(self.moreOptionsClicked){
        
        UIImageView *headerImg = (UIImageView *)[self.optionsTableView viewWithTag:980];
        [headerImg setImage:[UIImage imageNamed:@"MinusGrey"]];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sectionView.superview.bounds
                                                       byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                             cornerRadii:CGSizeMake(0.0, 0.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = sectionView.superview.bounds;
        maskLayer.path = maskPath.CGPath;
        sectionView.superview.layer.mask = maskLayer;
        
        
        UIBezierPath *topMaskPath = [UIBezierPath bezierPathWithRoundedRect:sectionView.superview.bounds
                                                       byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                             cornerRadii:CGSizeMake(3.0, 3.0)];
        CAShapeLayer *topMaskLayer = [CAShapeLayer layer];
        topMaskLayer.frame = sectionView.superview.bounds;
        topMaskLayer.path = topMaskPath.CGPath;
        sectionView.superview.layer.mask = topMaskLayer;


        
         [self.optionsTableView setFrame:CGRectMake(self.optionsTableView.frame.origin.x, self.optionsTableView.frame.origin.y, self.optionsTableView.frame.size.width, self.optionsTableView.frame.size.height + learnMoreCellHeight*4)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.optionsTableView.frame.size.height)];
        SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(10, headerImg.superview.frame.size.height-1, self.optionsTableView.frame.size.width - 20, 1)];
        line.tag = 999;
        [headerImg.superview addSubview:line];

        
        [self.optionsTableView insertRowsAtIndexPaths:[self indexPathForMoreOptions:4] withRowAnimation:UITableViewRowAnimationNone];
       
    }else{
        UIImageView *headerImg = (UIImageView *)[self.optionsTableView viewWithTag:980];
        
        SSLine *headerLine = (SSLine *)[headerImg.superview viewWithTag:999];
        
        [headerLine removeFromSuperview];
         headerLine= nil;
        [headerImg setImage:[UIImage imageNamed:@"PlusGrey"]];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sectionView.superview.bounds
                                                       byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight | UIRectCornerTopLeft|UIRectCornerTopRight
                                                             cornerRadii:CGSizeMake(3.0, 3.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = sectionView.superview.bounds;
        maskLayer.path = maskPath.CGPath;
        sectionView.superview.layer.mask = maskLayer;

        [self.optionsTableView deleteRowsAtIndexPaths:[self indexPathForMoreOptions:4] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.optionsTableView setFrame:CGRectMake(self.optionsTableView.frame.origin.x, self.optionsTableView.frame.origin.y, self.optionsTableView.frame.size.width, self.optionsTableView.frame.size.height - learnMoreCellHeight*4)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.optionsTableView.frame.size.height )];

    }
    
    if([self.detailDelegate respondsToSelector:@selector(moreOptionsDisplaying:)]){
        [self.detailDelegate moreOptionsDisplaying:self.moreOptionsClicked];
    }
}


- (NSArray *)indexPathForMoreOptions:(NSInteger)rows{
    
    NSMutableArray *indexPathArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSInteger counter=0; counter< rows; counter++){
        [indexPathArray addObject:[NSIndexPath indexPathForRow:counter inSection:2]];
    }
    return [indexPathArray copy];
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
