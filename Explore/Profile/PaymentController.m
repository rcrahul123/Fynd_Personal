//
//  PaymentController.m
//  Explore
//
//  Created by Pranav on 23/11/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "PaymentController.h"
#import "SSUtility.h"
#import "SSLine.h"
#import "PopOverlayHandler.h"
#import "AddCartPopUp.h"
#import "BankCardData.h"
#import "PaymentCartRequestHandler.h"
#import "Luhn.h"
#import "NetBankingViewController.h"

@interface PaymentController ()<UITableViewDataSource,UITableViewDelegate,PopOverlayHandlerDelegate,AddCartPopUpDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView        *paymentOptionsTable;
@property (nonatomic,strong) NSMutableArray     *paymentData;
@property (nonatomic,assign) BOOL               isCardOpen;
@property (nonatomic,assign) BOOL               isWalletOpen;
@property (nonatomic,strong) PopOverlayHandler  *addCardPopOverHandler;
@property (nonatomic,strong) UIView             *overlayView;
@property (nonatomic,strong) AddCartPopUp        *addCartPopUp;
@property (nonatomic,strong) PaymentCartRequestHandler  *paymnetCartReqHandler;
@property (nonatomic,assign) BOOL cardAdded;
@property (nonatomic,assign) BOOL dummyBool;
@property (nonatomic,assign) NSInteger  selectedIndex;
//@property (nonatomic,strong) BankCardData   *selectedCardData;
@property (nonatomic,strong) CardModel   *selectedCardData;
- (void)intializePaymentView;
- (void)fetchPaymentCards;
- (void)showLoader;
- (void)hideLoader;
@end

@implementation PaymentController
#define kPadding 10.0f
@synthesize cardList;


NSMutableArray  *cardData = nil;
- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [self setBackButton];

    self.isCardOpen = TRUE;
        self.title = @"FLASHPAY";
//    if (self.paymentMode == PaymentScreenTypeCart) {
//        self.title = @"Payment Option";
//    }else{
//        self.title = @"FLASHPAY";
//    }
    
    
    if(self.paymentMode == PaymentScreenTypeProfile){
        [self fetchPaymentCards];
    }else{
        [self intializePaymentView];
    }
    cardData = [[NSMutableArray alloc] initWithCapacity:0];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor whiteColor]];
}

-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}


- (void)showLoader{
    if(bankCardLoader){
        [bankCardLoader removeFromSuperview];
        bankCardLoader = nil;
    }
    bankCardLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bankCardLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 30)];
    [self.view addSubview:bankCardLoader];

}

- (void)hideLoader{
    [bankCardLoader stopAnimating];
    [bankCardLoader removeFromSuperview];
    bankCardLoader= nil;
}


-(void)showLoaderOnCard{
    if(cardLoader){
        [cardLoader removeFromSuperview];
        cardLoader = nil;
    }
    cardLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [cardLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 30)];
    [self.addCartPopUp addSubview:cardLoader];
}

- (void)hideLoaderFromCard{
    [cardLoader stopAnimating];
    [cardLoader removeFromSuperview];
    cardLoader= nil;
}


- (void)fetchPaymentCards{
    
    if(self.paymnetCartReqHandler== nil){
        self.paymnetCartReqHandler = [[PaymentCartRequestHandler alloc] init];
    }
    
    [self showLoader];
    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    NSDictionary *dict = nil;
    
    if(self.cardAdded){
        dict =[NSDictionary dictionaryWithObjectsAndKeys:user.userId,@"user_id",@"True",@"force_refresh", nil];
    }else{
        dict =[NSDictionary dictionaryWithObjectsAndKeys:user.userId,@"user_id", nil];
    }
    __block PaymentController *ctrl = self;
    [self.paymnetCartReqHandler fetchBankCards:dict withCompletionHandler:^(id responseData, NSError *error) {
        
        
        NSArray *data = [responseData objectForKey:@"data"];
        
        if(cardData){
            [cardData removeAllObjects];
        }
        
        if(cardList){
            [cardList removeAllObjects];
        }else{
            cardList = [[NSMutableArray alloc] init];
        }
        
        
        for(NSDictionary *dict in data){

            CardModel *theCardModel = [[CardModel alloc] initWithDictionary:dict];
            if (self.paymentMode == PaymentScreenTypeProfile) {
                [cardData addObject:theCardModel];
            }else{
                [cardList addObject:theCardModel];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self intializePaymentView];
            [ctrl hideLoader];
        });
    }];
    
}

- (void)addCard:(CardModel *)cardModel{
    
    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    NSMutableDictionary *dict = nil;
    self.dummyBool = !self.dummyBool;
    [self showLoaderOnCard];
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"devops_fynd" forKey:@"merchant_id"];
   
    if (user.userId) {
        [dict setObject:user.userId forKey:@"customer_id"];
    }

    [dict setObject:cardModel.cardNumber forKey:@"card_number"];
    [dict setObject:[NSString stringWithFormat:@"%@",cardModel.expiryYear] forKey:@"card_exp_year"];
    [dict setObject:[NSString stringWithFormat:@"%@",cardModel.expiryMonth] forKey:@"card_exp_month"];
    [dict setObject:cardModel.cardName forKey:@"nickname"];
    
    if(self.paymnetCartReqHandler== nil){
        self.paymnetCartReqHandler = [[PaymentCartRequestHandler alloc] init];
    }
    
    __block PaymentController *ctrl = self;
    [self.paymnetCartReqHandler addBankCard:dict withCompletionHandler:^(id responseData, NSError *error) {
        
        if(responseData && [responseData isKindOfClass:[NSDictionary class]]){
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                NSString *theReferenceNumber = responseData[@"card_reference"];
                NSMutableArray *storedCards =nil;
                if (self.paymentMode == PaymentScreenTypeProfile) {
                   storedCards = [[NSMutableArray alloc] initWithArray:cardData];
                }else{
                   storedCards = [[NSMutableArray alloc] initWithArray:cardList];
                    
                }
                 BOOL doesCardExist = FALSE;
                for (int cardIndex = 0; cardIndex< [storedCards count]; cardIndex++) {
                    CardModel *theCardModelInstance = [storedCards objectAtIndex:cardIndex];
                    if ([theCardModelInstance.cardReference isEqualToString:theReferenceNumber]) {
                        doesCardExist = TRUE;
                    }
                }
                
                if (doesCardExist) {
                    [SSUtility showOverlayViewWithMessage:@"Card already exists" andColor:UIColorFromRGB(kRedColor)];
                }else{
                    ctrl.cardAdded = TRUE;
                    [ctrl fetchPaymentCards];
                    [SSUtility showOverlayViewWithMessage:@"Card successfully added" andColor:UIColorFromRGB(kGreenColor)];
                    if(ctrl.overlayView){
                        [ctrl.overlayView removeFromSuperview];
                        ctrl.overlayView = nil;
                    }
                    
                    if(ctrl.addCartPopUp){
                        [ctrl.addCartPopUp removeFromSuperview];
                        ctrl.addCartPopUp = nil;
                    }

                }
                
                [ctrl hideLoaderFromCard];
               
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [ctrl hideLoaderFromCard];
            });
            [SSUtility showOverlayViewWithMessage:SOMETHING_WENT_WRONG andColor:UIColorFromRGB(kRedColor)];
        }
    }];
    
}

//Card Removing Function
- (void)removeCard:(NSInteger)index{
    [self showLoaderOnCard];
    CardModel *card = [cardData objectAtIndex:index];
    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:user.userId,@"user_id",[NSString stringWithFormat:@"%@",card.cardId],@"card_id",nil];

    if(self.paymnetCartReqHandler== nil){
        self.paymnetCartReqHandler = [[PaymentCartRequestHandler alloc] init];
    }
    __block PaymentController *ctrl = self;
    [self.paymnetCartReqHandler removeBankCard:dict withCompletionHandler:^(id responseData, NSError *error) {
        
        if([[responseData objectForKey:@"success"] boolValue]){
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [cardData removeObjectAtIndex:index];
                [ctrl.paymentOptionsTable reloadData];
                [ctrl hideLoaderFromCard];
                [SSUtility showOverlayViewWithMessage:@"Card successfully removed" andColor:UIColorFromRGB(kGreenColor)];
                
            if(self.overlayView){
                [self.overlayView removeFromSuperview];
                self.overlayView = nil;
            }
            
            if(self.addCartPopUp){
                [self.addCartPopUp removeFromSuperview];
                self.addCartPopUp = nil;
            }
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [ctrl hideLoaderFromCard];
            });
            [SSUtility showOverlayViewWithMessage:SOMETHING_WENT_WRONG andColor:UIColorFromRGB(kRedColor)];
        }
        
    }];
}

//Card Editing Function
- (void)editCard:(CardModel *)card andIndex:(NSInteger)index{
    
    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:user.userId,@"user_id",[NSString stringWithFormat:@"%@",card.cardId],@"card_id",card.cardName,@"card_name",nil];
    
    [self showLoaderOnCard];
    
    if(self.paymnetCartReqHandler== nil){
        self.paymnetCartReqHandler = [[PaymentCartRequestHandler alloc] init];
    }
    
    __block PaymentController *ctrl = self;
    [self.paymnetCartReqHandler editBankCard:dict withCompletionHandler:^(id responseData, NSError *error) {
        
        if([[responseData objectForKey:@"success"] boolValue]){
            [cardData replaceObjectAtIndex:index withObject:card];

            dispatch_async(dispatch_get_main_queue(), ^(void){
                NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]];
                [ctrl.paymentOptionsTable reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                [ctrl hideLoaderFromCard];
            [SSUtility showOverlayViewWithMessage:@"Card successfully edited" andColor:UIColorFromRGB(kGreenColor)];
                
            if(self.overlayView){
                [self.overlayView removeFromSuperview];
                self.overlayView = nil;
            }
            
            if(self.addCartPopUp){
                [self.addCartPopUp removeFromSuperview];
                self.addCartPopUp = nil;
            }
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [ctrl hideLoaderFromCard];
            });
            [SSUtility showOverlayViewWithMessage:SOMETHING_WENT_WRONG andColor:UIColorFromRGB(kRedColor)];
        }
        
    }];
}


- (void)intializePaymentView{
    if(self.paymentOptionsTable == nil){
        if (self.paymentMode == PaymentScreenTypeProfile) {
            self.paymentOptionsTable = [[UITableView alloc] initWithFrame:CGRectMake(RelativeSize(6, 320), 0, self.view.frame.size.width-RelativeSize(12, 320), self.view.frame.size.height-5) style:UITableViewStyleGrouped];
        }else{
            self.paymentOptionsTable = [[UITableView alloc] initWithFrame:CGRectMake(RelativeSize(6, 320), 0, self.view.frame.size.width-RelativeSize(12, 320), self.view.frame.size.height-64) style:UITableViewStyleGrouped];
        }
        [self.paymentOptionsTable setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
        
        self.paymentOptionsTable.alwaysBounceVertical = YES;
        self.paymentOptionsTable.dataSource = self;
        self.paymentOptionsTable.delegate = self;
        [self.paymentOptionsTable setTag:300];
        [self.paymentOptionsTable setShowsVerticalScrollIndicator:FALSE];
        [self.paymentOptionsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:self.paymentOptionsTable];
    }else{
        [self.paymentOptionsTable reloadData];
    }
}




#pragma mark TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.paymentMode == PaymentScreenTypeProfile) {
        return 1;
    }else{
        return 2;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat headerHeight = 0.0f;
    if (section == 0) {
        headerHeight = 40.0f;
    }else if(section ==1){
        headerHeight = 60.0f;
    }
    return headerHeight;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat footerHeight = 10.0f;
    if(section == 0){
        footerHeight = 44.0f;
    }
    return footerHeight;
}





- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.paymentOptionsTable.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];


    NSString *heading = nil;
    if(section == 0){
        heading = @"CARDS";
    }else{
        heading = @"OTHERS";
    }
    
    UILabel *chooseBankHeading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    
    [chooseBankHeading setText:heading];
    [chooseBankHeading setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [chooseBankHeading setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    chooseBankHeading.center = headerView.center;
    chooseBankHeading.textAlignment = NSTextAlignmentCenter;

    if (section == 1) {
        [chooseBankHeading setFrame:CGRectMake(0, 18, 200, 40)];
        chooseBankHeading.center = CGPointMake(headerView.center.x, chooseBankHeading.center.y);
    }
    
    [headerView addSubview:chooseBankHeading];
    
    return headerView;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *addCartView = nil;
    if (section == 0) {
        addCartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.paymentOptionsTable.frame.size.width, 44)];
        [addCartView setBackgroundColor:[UIColor whiteColor]];
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:addCartView.bounds];
        [button setBackgroundImage:[SSUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xD9D9D9)] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(showCard:) forControlEvents:UIControlEventTouchUpInside];
        [addCartView addSubview:button];
        

        if ([cardData count]>0 || [cardList count]>0) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:addCartView.bounds
                                                           byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(3.0, 3.0)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = addCartView.bounds;
            maskLayer.path = maskPath.CGPath;
            addCartView.layer.mask = maskLayer;
        }else{
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:addCartView.bounds
                                                           byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight
                                                                 cornerRadii:CGSizeMake(3.0, 3.0)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = addCartView.bounds;
            maskLayer.path = maskPath.CGPath;
            addCartView.layer.mask = maskLayer;
        }
        
        UIImage *image = [UIImage imageNamed:@"AddPaymentOptionFromCart"];
        UIImageView  *addCartImage = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding, 7, image.size.width, image.size.height)];
        [addCartImage setBackgroundColor:[UIColor clearColor]];
        [addCartImage setImage:[UIImage imageNamed:@"AddPaymentOptionFromCart"]];
        [addCartView addSubview:addCartImage];
        
        
        UILabel *addCard = [SSUtility generateLabel:@"Add a Card" withRect:CGRectMake(addCartImage.frame.origin.x + addCartImage.frame.size.width , 5, 100, 3*kPadding) withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [addCard setTextColor:UIColorFromRGB(kTurquoiseColor)];

        [addCartView addSubview:addCard];
        
        
        UIButton *addCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addCartButton setFrame:CGRectMake(addCartView.frame.size.width - 4*kPadding, 3, 35, 35)];
        self.selectedCardData = nil;
        [addCartButton addTarget:self action:@selector(showCard:) forControlEvents:UIControlEventTouchUpInside];
        [addCartButton setBackgroundImage:[UIImage imageNamed:@"PlusIcon"] forState:UIControlStateNormal];
        [addCartView addSubview:addCartButton];
        
    }else{
       addCartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.paymentOptionsTable.frame.size.width, 0)];
    }
    return addCartView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount =0;
    
    if(self.paymentMode == PaymentScreenTypeProfile){
        if(section ==0){
            if(self.isCardOpen){
                //           rowCount = [data count]+1;
                rowCount = [cardData count];
            }
        }
        if(section ==1){
            if(self.isWalletOpen){
                rowCount = [cardData count];
            }
        }
    }else{
        if(section ==0){
            if(self.isCardOpen){
                //           rowCount = [data count]+1;
                rowCount = [cardList count];
            }
        }
        
        if (section == 1) {
            rowCount = [_parsedPaymentOptions count];
        }
    }
    
    
    return rowCount;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Payment Option Cell";
    static NSString *paymentCellIdentifier = @"PaymentReusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(self.paymentMode == PaymentScreenTypeProfile){
        NSDictionary *dict = [self.paymentData objectAtIndex:indexPath.section];
        NSArray *data = [dict objectForKey:[[dict allKeys] objectAtIndex:0]];
        
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if ([cell.contentView viewWithTag:1221]) {
            UIView *theView = [cell.contentView viewWithTag:1221];
            [theView removeFromSuperview];
            theView = nil;
        }
        
        CardModel *card = [cardData objectAtIndex:indexPath.row];

        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.paymentOptionsTable.frame.size.width,44)];
        [aView setBackgroundColor:[UIColor whiteColor]];
        aView.tag = 1221;
        aView.layer.cornerRadius = 5.0f;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 30,30)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setImage:[UIImage imageNamed:card.cardImage]];
        [aView addSubview:imageView];
        
        
        CGSize size = CGSizeZero;

        NSString *optionString = card.cardName;
        size = [SSUtility getLabelDynamicSize:optionString withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(self.paymentOptionsTable.frame.size.width-2*kPadding, MAXFLOAT)];
        
        UILabel *optionLabel = [SSUtility generateLabel:optionString withRect:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + kPadding, 12, size.width, size.height) withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [optionLabel setBackgroundColor:[UIColor clearColor]];
        [optionLabel setTextColor:UIColorFromRGB(kSignUpColor)];
        [aView addSubview:optionLabel];
  
        
        size = [SSUtility getLabelDynamicSize:card.cardFormattedNumber withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(self.paymentOptionsTable.frame.size.width, MAXFLOAT)];

        NSMutableAttributedString * paymentDetailString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"•••• %@",card.cardFormattedNumber] attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:12]}];
        
        [paymentDetailString setAttributes:@{NSFontAttributeName :[UIFont fontWithName:kMontserrat_Regular size:20], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)} range:NSMakeRange(0, 4)];

       UILabel *optionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.paymentOptionsTable.frame.size.width-size.width-RelativeSize(32, 375)-kPadding, imageView.frame.origin.y, size.width+RelativeSize(35, 375), size.height+5)];
        
        [optionLabel1 setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
        [optionLabel1 setAttributedText:paymentDetailString];
        [optionLabel1 setBackgroundColor:[UIColor clearColor]];
        [optionLabel1 setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
        [aView addSubview:optionLabel1];
        [cell.contentView addSubview:aView];
        
        
        
        if (indexPath.row == 0) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds
                                                           byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                                 cornerRadii:CGSizeMake(3.0, 3.0)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = aView.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
            
        }
        if (indexPath.row != [data count]-1) {
            
            SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(10, cell.frame.size.height-1, self.paymentOptionsTable.frame.size.width - 10, 1)];
            [aView addSubview:line];
        }
        if(indexPath.row == [data count]-1){
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds
                                                           byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(3.0, 3.0)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = aView.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
        }
        
        
    }else{
        
        if (indexPath.section == 0) {
            if(cell == nil){
                CardModel *cardModel =(CardModel *)[cardList objectAtIndex:indexPath.row];
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.paymentOptionsTable.frame.size.width,44)];
                [aView setBackgroundColor:[UIColor whiteColor]];
                aView.layer.cornerRadius = 5.0f;
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,7,30,30)];
                
                [imageView setBackgroundColor:[UIColor clearColor]];
            
                [imageView setImage:[UIImage imageNamed:cardModel.cardImage]];
                [aView addSubview:imageView];
                
                
                CGSize size = CGSizeZero;
                NSString *optionString = cardModel.cardName;
                size = [SSUtility getLabelDynamicSize:optionString withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(self.paymentOptionsTable.frame.size.width-2*kPadding, MAXFLOAT)];
                
                UILabel *optionLabel = [SSUtility generateLabel:optionString withRect:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + kPadding, 12, size.width, size.height) withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
                
                [optionLabel setBackgroundColor:[UIColor clearColor]];
                [optionLabel setTextColor:UIColorFromRGB(kSignUpColor)];
                [aView addSubview:optionLabel];
                
                
                NSString *cardNumber = cardModel.cardFormattedNumber;
                
                NSMutableAttributedString * paymentDetailString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"•••• %@",cardModel.cardFormattedNumber] attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:12]}];
                
                [paymentDetailString setAttributes:@{NSFontAttributeName :[UIFont fontWithName:kMontserrat_Regular size:20], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)} range:NSMakeRange(0, 4)];
                
                

                

                
                size = [SSUtility getLabelDynamicSize:cardNumber withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(self.paymentOptionsTable.frame.size.width-2*kPadding, MAXFLOAT)];
                
                UILabel *cardNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(aView.frame.size.width-(size.width)-kPadding-RelativeSize(32, 375), 10, size.width+RelativeSize(35, 375), size.height+5)];
                [cardNumberLabel setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
                [cardNumberLabel setAttributedText:paymentDetailString];
                
                [cardNumberLabel setBackgroundColor:[UIColor clearColor]];
                [cardNumberLabel setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
                [aView addSubview:cardNumberLabel];

                if (indexPath.row == 0) {
                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds
                                                                   byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                                         cornerRadii:CGSizeMake(3.0, 3.0)];
                    CAShapeLayer *maskLayer = [CAShapeLayer layer];
                    maskLayer.frame = aView.bounds;
                    maskLayer.path = maskPath.CGPath;
                    cell.layer.mask = maskLayer;
                    
                }
                
                    SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(10, cell.frame.size.height-1, self.paymentOptionsTable.frame.size.width - 10, 1)];
                    [aView addSubview:line];
                
                [cell.contentView addSubview:aView];
            }
        }else if (indexPath.section == 1){
            PaymentModeCell *cell = (PaymentModeCell *)[tableView dequeueReusableCellWithIdentifier:paymentCellIdentifier];
            if(cell == nil){
                cell = [[PaymentModeCell alloc] init];
            }
            if(indexPath.row == 0 || indexPath.row == [_parsedPaymentOptions count] - 1){
                cell.showBendCorners = YES;
                if(indexPath.row == 0){
                    cell.bendType = CornerBendTypeTop;
                }else{
                    cell.bendType = CornerBendTypeBottom;
                }
                
            }else{
                cell.showBendCorners = FALSE;
                cell.bendType = CornerBendTypeNone;
            }
            PaymentModes *thePayMode = (PaymentModes *)[_parsedPaymentOptions objectAtIndex:indexPath.row];
            
            if ([thePayMode.paymentName isEqualToString:@"COD"]) {
                thePayMode.paymentImageName = @"CashOnDelivery";
            }else if ([thePayMode.paymentName isEqualToString:@"OP"]){
                thePayMode.paymentImageName = @"OnlineShopping";
            }else if ([thePayMode.paymentName isEqualToString:@"PT"]){
                thePayMode.paymentImageName = @"Wallet";
            }else if ([thePayMode.paymentName isEqualToString:@"CDOD"]){
                thePayMode.paymentImageName = @"CardDelivery";
            }else if ([thePayMode.paymentName isEqualToString:@"NB"]){
                thePayMode.paymentImageName = @"NetBanking";
            }else if ([[thePayMode.paymentName uppercaseString] isEqualToString:@"CARD"]){
//                thePayMode.paymentImageName = @"PaymentBlack";
            }

            
            cell.currentPaymentData = thePayMode;
            
            return cell;
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    if(self.paymentMode == PaymentScreenTypeProfile){
        self.selectedIndex = indexPath.row;
        
        self.selectedCardData = [cardData objectAtIndex:indexPath.row];
        [self showCard:self.selectedCardData];
    }
    if (self.paymentMode == PaymentScreenTypeCart) {
        NSMutableDictionary *callBackToBag = [[NSMutableDictionary alloc] init];
        
        
        
        if (indexPath.section == 0) {
            [callBackToBag setObject:@"card" forKey:@"mode"];
            [callBackToBag setObject:[cardList objectAtIndex:indexPath.row] forKey:@"data"];
            
            if(self.thePaymentDelegate && [self.thePaymentDelegate respondsToSelector:@selector(selectedOptionWithDataDictionary:)]){
                [self.thePaymentDelegate selectedOptionWithDataDictionary:callBackToBag];
                [self.navigationController popViewControllerAnimated:TRUE];
            }
        }else if(indexPath.section == 1){
            PaymentModes *thePayMode = [_parsedPaymentOptions objectAtIndex:indexPath.row];
            if ([[thePayMode.paymentName uppercaseString] isEqualToString:@"NB"]) {
                
                NetBankingViewController *theNetBankingView = [[NetBankingViewController alloc] init];
                theNetBankingView.theNetBankingData = thePayMode.optionsArray;
                [self.navigationController pushViewController:theNetBankingView animated:TRUE];
            }else{
                [callBackToBag setObject:thePayMode.paymentName forKey:@"mode"];
                [callBackToBag setObject:thePayMode forKey:@"data"];
                
                if(self.thePaymentDelegate && [self.thePaymentDelegate respondsToSelector:@selector(selectedOptionWithDataDictionary:)]){
                    [self.thePaymentDelegate selectedOptionWithDataDictionary:callBackToBag];
                    [self.navigationController popViewControllerAnimated:TRUE];
                }
            }
            
            
        }
        
        
    }
}


- (void)handleTapGesture:(id)sender{
    UITapGestureRecognizer *regonizer = (UITapGestureRecognizer *)sender;
    if([regonizer.view isKindOfClass:[UIView class]]){
        if(regonizer.view.tag ==0){
            [self showPaymentOptions:0];
        }
        else if(regonizer.view.tag ==1){
            [self showPaymentOptions:1];
        }
    }
    
}



- (NSArray *)indexPathForPaymentOptions:(NSInteger)rows andSection:(NSInteger)section{
    
    NSMutableArray *indexPathArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSInteger counter=0; counter< rows; counter++){
        [indexPathArray addObject:[NSIndexPath indexPathForRow:counter inSection:section]];
    }
    return [indexPathArray copy];
}



- (void)showPaymentOptions:(NSInteger)sectionTag{
    //    self.moreOptionsClicked = !self.moreOptionsClicked;
    
    NSDictionary *dict = [self.paymentData objectAtIndex:sectionTag];
    NSArray *data = [dict objectForKey:[[dict allKeys] objectAtIndex:0]];
    if(sectionTag == 0){
        self.isCardOpen = !self.isCardOpen;
        
        if(self.isCardOpen){
            [UIView animateWithDuration:0.33f animations:^()
             {
             }];
            
            [self.paymentOptionsTable insertRowsAtIndexPaths:[self indexPathForPaymentOptions:[data count] andSection:sectionTag] withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            [UIView animateWithDuration:0.33f animations:^()
             {
             }];
            [self.paymentOptionsTable deleteRowsAtIndexPaths:[self indexPathForPaymentOptions:[data count] andSection:sectionTag] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    }
    else if(sectionTag == 1){
        self.isWalletOpen = !self.isWalletOpen;
        
        if(self.isWalletOpen){
            [UIView animateWithDuration:0.33f animations:^()
             {
             }];
            
            [self.paymentOptionsTable insertRowsAtIndexPaths:[self indexPathForPaymentOptions:[data count] andSection:sectionTag] withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            [UIView animateWithDuration:0.33f animations:^()
             {
             }];
            [self.paymentOptionsTable deleteRowsAtIndexPaths:[self indexPathForPaymentOptions:[data count] andSection:sectionTag] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    }
}


//- (void)actionPerormOnAddCard:(NSInteger)tag andAddedCard:(BankCardData *)cardData{
- (void)actionPerormOnAddCard:(NSInteger)tag andAddedCard:(CardModel *)cardData{
    
    
    if(tag==0){
        [self removeCard:self.selectedIndex];
    }else if (tag == 1){
        [self addCard:cardData];
    }else if(tag ==2){
        [self editCard:cardData andIndex:self.selectedIndex];
    }else{
        if(self.overlayView){
            [self.overlayView removeFromSuperview];
            self.overlayView = nil;
        }
        
        if(self.addCartPopUp){
            [self.addCartPopUp removeFromSuperview];
            self.addCartPopUp = nil;
        }
    }
    
}

//-(void)handleTapGesture1:(id)sender{
//
//    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer *)sender;
//    CGPoint aTapLocation = [recognizer locationInView:recognizer.view];
////    self.navigationController.navigationBarHidden = FALSE;
//    
//    if(CGRectContainsPoint(self.addCartPopUp.cardBackgroundImage.frame, aTapLocation)) {
//    
//    
//    }
//    else{
//        NSLog(@" Outside Card Image ------ ");
//        if(self.overlayView){
//            [self.overlayView removeFromSuperview];
//            self.overlayView = nil;
//        }
//        if(self.addCartPopUp){
//            [self.addCartPopUp removeFromSuperview];
//            self.addCartPopUp = nil;
//        }
//        self.selectedCardData = nil;
//    }
//     
//
//
//}

-(void)showCard:(id)sender{

    if(self.overlayView){
        [self.overlayView removeFromSuperview];
        self.overlayView = nil;
    }
    self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.overlayView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    UIWindow *theKeyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [theKeyWindow addSubview:self.overlayView];
    
    
    if(self.addCartPopUp){
        [self.addCartPopUp removeFromSuperview];
        self.addCartPopUp = nil;
    }
    
    self.addCartPopUp= [[AddCartPopUp alloc] initWithFrame:CGRectMake(0, 0, self.overlayView.frame.size.width, self.view.frame.size.height)];

    if([sender isKindOfClass:[UIButton class]]){
        self.addCartPopUp.selectedCard = nil;
    }else{
        self.addCartPopUp.selectedCard = self.selectedCardData;
    }

    if(self.addCartPopUp.selectedCard){
        self.addCartPopUp.isAddingCard = FALSE;
    }
    else{
        self.addCartPopUp.isAddingCard = TRUE;
    }
    
    self.addCartPopUp.addCartDelegate = self;
    [self.addCartPopUp configureAddCart];
    [self.addCartPopUp setBackgroundColor:[UIColor clearColor]];
    self.addCartPopUp.layer.cornerRadius = 5.0;
    [self.overlayView addSubview:self.addCartPopUp];
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture1:)];
//    tapGesture.delegate = self;
//    [self.addCartPopUp addGestureRecognizer:tapGesture];
    
    [self.addCartPopUp setCenter:CGPointMake(self.overlayView.frame.size.width/2, self.overlayView.frame.size.height/2)];
    self.addCartPopUp.clipsToBounds = YES;
    [self.addCartPopUp.layer setCornerRadius:3.0];
    
    
//    [self.addCartPopUp setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.addCartPopUp setTransform:CGAffineTransformMakeScale(1, 1)];
//    } completion:^(BOOL finished) {
//        
//    }];
}

@end



/* // This function is not used...... Need to remove it.
 - (void)displayAddCardOverlay{
 
 if(self.overlayView){
 [self.overlayView removeFromSuperview];
 self.overlayView = nil;
 }
 self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
 //    [overlayView setUserInteractionEnabled:FALSE];
 [self.overlayView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
 [self.view.window addSubview:self.overlayView];
 
 
 
 self.addCartPopUp= [[AddCartPopUp alloc] initWithFrame:CGRectMake(0, 0, self.overlayView.frame.size.width-20, self.view.frame.size.height)];
 self.addCartPopUp.isAddingCard = TRUE;
 self.addCartPopUp.addCartDelegate = self;
 [self.addCartPopUp configureAddCart];
 [self.addCartPopUp setBackgroundColor:[UIColor clearColor]];
 self.addCartPopUp.layer.cornerRadius = 5.0;
 [self.overlayView addSubview:self.addCartPopUp];
 
 UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture1:)];
 tapGesture.delegate = self;
 //    [self.addCartPopUp addGestureRecognizer:tapGesture];
 
 [self.addCartPopUp setCenter:CGPointMake(self.overlayView.frame.size.width/2, self.overlayView.frame.size.height/2-100)];
 
 self.addCartPopUp.clipsToBounds = YES;
 [self.addCartPopUp.layer setCornerRadius:3.0];
 
 
 [self.addCartPopUp setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
 
 [UIView animateWithDuration:0.3 animations:^{
 [self.addCartPopUp setTransform:CGAffineTransformMakeScale(1, 1)];
 } completion:^(BOOL finished) {
 
 }];
 
 
 }

 */
