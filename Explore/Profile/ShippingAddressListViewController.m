//
//  ShippingAddressListViewController.m
//  Explore
//
//  Created by Amboj Goyal on 9/11/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ShippingAddressListViewController.h"
#import "SSUtility.h"
#import "ShippingAddressModel.h"
#import "ShippingListTableViewCell.h"

@interface ShippingAddressListViewController (){
    ShippingAddressModel *selectedAddressModel;
    UIView *bottomViewContainer;
    UIButton *proceedButton;
    
}
@end

@implementation ShippingAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    shippingAddressLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [shippingAddressLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 30)];

    
    [self configureShippingView];
    
    [self setBackButton];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    
    if(self.theShippingEnum == ShippingAddressProfile){
        self.title = @"Delivery Address";

    }else{
        self.title = @"Select Delivery Address";

    }
    [_theShippingTableView reloadData];
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor whiteColor]];
    
}
-(void)configureShippingView{
    
//    [SSUtility showActivityOverlay:self.view];
    [self.view addSubview:shippingAddressLoader];
    [shippingAddressLoader startAnimating];
    
    if (self.shippingDetailsArray == nil) {
        self.shippingDetailsArray = [[NSMutableArray alloc] initWithCapacity:0];        
    }

    if (theCartRequestHandler == nil) {
        theCartRequestHandler = [[CartRequestHandler alloc] init];
    }
    
    [theCartRequestHandler fetchShippingAdress:nil withCompletionHandler:^(id responseData, NSError *error) {
        if (!error) {
            [self.shippingDetailsArray addObjectsFromArray:responseData];
//            selectedAddressModel = [self.shippingDetailsArray objectAtIndex:0];// Setting 0th index object to default
            _theShippingTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height) style:UITableViewStylePlain];
            _theShippingTableView.delegate = self;
            _theShippingTableView.dataSource= self;
            [_theShippingTableView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
            [_theShippingTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [_theShippingTableView setShowsVerticalScrollIndicator:FALSE];
            [self.view addSubview:_theShippingTableView];
//            if (self.theShippingEnum == ShippingAddressCart) {
//                [self configureBottomView];
//            }

//            [SSUtility dismissActivityOverlay];
            [shippingAddressLoader removeFromSuperview];
            [shippingAddressLoader stopAnimating];
        }
    }];
}

-(void)configureBottomView{
    if (bottomViewContainer) {
        [bottomViewContainer removeFromSuperview];
        bottomViewContainer = nil;
    }
    bottomViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 64-60, self.view.frame.size.width, 60)];
    [bottomViewContainer setBackgroundColor:[UIColor whiteColor]];
    
    proceedButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, bottomViewContainer.frame.size.width - 10, 50)];
    [proceedButton setTitle:@"SELECT" forState:UIControlStateNormal];
    [proceedButton.layer setCornerRadius:3.0f];
    [proceedButton setClipsToBounds:TRUE];
    [proceedButton.titleLabel setFont:[UIFont fontWithName:kMontserrat_Bold size:16.0f]];
    [proceedButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [proceedButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    [proceedButton addTarget:self action:@selector(proceedTo:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomViewContainer addSubview:proceedButton];
    
    [self.view addSubview:bottomViewContainer];
}
- (void) buttonHighlight:(id)highlighted {
    proceedButton.backgroundColor = UIColorFromRGB(kFBButtonTouchColor);
    
    
}
-(void)proceedTo:(id)sender{
//    [SSUtility showActivityOverlay:self.view];
    [self.view addSubview:shippingAddressLoader];
    [shippingAddressLoader startAnimating];

    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setObject:selectedAddressModel.theFirstName forKey:@"name"];
    [paramsDic setObject:selectedAddressModel.theFlatNBuildingName forKey:@"address"];
    [paramsDic setObject:selectedAddressModel.theStreetName forKey:@"area"];
    [paramsDic setObject:selectedAddressModel.theMobileNo forKey:@"phone"];
    [paramsDic setObject:selectedAddressModel.thePincode forKey:@"pincode"];
    [paramsDic setObject:@"true" forKey:@"is_default_address"];
    [paramsDic setObject:selectedAddressModel.theAddressType forKey:@"address_type"];
    
    __weak ShippingAddressListViewController *weakSelf = self;

    if (theCartRequestHandler == nil) {
        theCartRequestHandler = [[CartRequestHandler alloc] init];
    }

        [paramsDic setObject:selectedAddressModel.theAddressID forKey:@"address_id"];
        [theCartRequestHandler updateShippingAdress:paramsDic withCompletionHandler:^(id responseData, NSError *error) {
            if (!error) {
                if ([responseData[@"is_updated"] boolValue]) {
                    
                    NSString *theAddressID = [NSString stringWithFormat:@"%@",responseData[@"address_id"]];
                    BOOL isDefaultAdd = [responseData[@"is_default_address"] boolValue];
                    selectedAddressModel.theAddressID = theAddressID;
                    selectedAddressModel.isDefaultAddress = isDefaultAdd;
                    [weakSelf changeAdderss:selectedAddressModel];
//                    [SSUtility dismissActivityOverlay];
                    [shippingAddressLoader removeFromSuperview];
                    [shippingAddressLoader stopAnimating];
                }
                
            }
        }];
    
}

#pragma mark UITableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;//50
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _theShippingTableView.frame.size.width, 1)];
    [headerView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
/*
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 40)];
//    [headerButton setBackgroundColor:[UIColor whiteColor]];
    [headerButton setBackgroundImage:[SSUtility imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [headerButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xF4F4F4)] forState:UIControlStateHighlighted];
    [headerButton setClipsToBounds:YES];
    
    [headerButton.layer setCornerRadius:3.0f];
    
    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 32, 32)];
    [addressImageView setImage:[UIImage imageNamed:@"ShippingAddress"]];
    [headerButton addSubview:addressImageView];
    
    UILabel *addressList = [[UILabel alloc] initWithFrame:CGRectMake(addressImageView.frame.origin.x + addressImageView.frame.size.width, 0, 200, 40)];
    [addressList setText:@"Add New Address"];
    [addressList setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [addressList setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [headerButton addSubview:addressList];
    [headerButton addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headerButton];
    
    UIImage* sourceImage = [UIImage imageNamed:kBackButtonImage];
    
    UIImage* flippedImage = [UIImage imageWithCGImage:sourceImage.CGImage
                                                scale:sourceImage.scale
                                          orientation:UIImageOrientationUpMirrored];
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(headerView.frame.size.width - 36, 7,26, 26)];
    [arrowImage setBackgroundColor:[UIColor clearColor]];
    [arrowImage setImage:flippedImage];
    [headerView addSubview:arrowImage];
*/
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, 0, 100, 40)];
    [addressLabel setText:@"ADDRESSES"];
    [addressLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [addressLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [addressLabel setTextAlignment:NSTextAlignmentCenter];
//    [addressLabel setCenter:self.view.center];
//    [headerView addSubview:addressLabel];

    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.shippingDetailsArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Shipping List";
    static NSString *addAddress = @"Add Address";
    UITableViewCell *addCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:addAddress];
    ShippingListTableViewCell *cell = (ShippingListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.row == 0) {
        if (addCell == nil) {
            addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addAddress];
            [addCell setFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
            [addCell.contentView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
            
            if ([addCell viewWithTag:151]) {
                UIView *containerView = [addCell viewWithTag:151];
                [containerView removeFromSuperview];
                 containerView = nil;
            }
            
            UIButton *headerContainerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, addCell.frame.size.width, 44)];
            [headerContainerView setBackgroundImage:[SSUtility imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [headerContainerView setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xF4F4F4)] forState:UIControlStateHighlighted];
            [headerContainerView.layer setCornerRadius:3.0f];
            [headerContainerView setClipsToBounds:YES];
            [headerContainerView addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
            
            
             UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 28, 28)];
             [addressImageView setImage:[UIImage imageNamed:@"AddAddressFromCart"]];
             [headerContainerView addSubview:addressImageView];
             
             UILabel *addressList = [[UILabel alloc] initWithFrame:CGRectMake(addressImageView.frame.origin.x + addressImageView.frame.size.width+5, 0, 200, 40)];
             [addressList setText:@"Add New Address"];
             [addressList setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
             [addressList setTextColor:UIColorFromRGB(kTurquoiseColor)];
             [headerContainerView addSubview:addressList];

             
             UIImage* sourceImage = [UIImage imageNamed:@"PlusIcon"];
            
             UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(addCell.frame.size.width - 40, 3,35, 35)];
             [arrowImage setBackgroundColor:[UIColor clearColor]];
             [arrowImage setImage:sourceImage];
             [headerContainerView addSubview:arrowImage];
             [addCell.contentView addSubview:headerContainerView];
        }
        return addCell;
    }else{
        
        
        
        if(cell == nil){
            cell = [[ShippingListTableViewCell alloc] init];
            cell.shippingDetailsArray = self.shippingDetailsArray;
        }
        
        if (self.theShippingEnum == ShippingAddressCart) {
            cell.theShippingTypeEnum = ShippingAddressCart;
        }else{
            cell.theShippingTypeEnum = ShippingAddressProfile;
        }
        cell.tag = indexPath.row;
        if (self.theShippingEnum == ShippingAddressCart) {
            cell.theShippingModel = [self.shippingDetailsArray objectAtIndex:indexPath.row-1];
            
        }else if(self.theShippingEnum == ShippingAddressProfile){
            
            cell.theShippingModel = [self.shippingDetailsArray objectAtIndex:indexPath.row-1];

//            cell.theShippingModel = [self.shippingDetailsArray objectAtIndex:[self.shippingDetailsArray count] - indexPath.row];
            //        cell.theShippingModel = [self.shippingDetailsArray objectAtIndex:indexPath.row];
        }
//        cell.theEditAddressBlock = ^(ShippingAddressModel *theEditModel){
//            [self editAddress:theEditModel];
//        };
//        cell.theDeleteAddressBlock = ^(ShippingAddressModel *theModel,UITouch *touch){
//            
//            CGPoint brandPoint = [touch locationInView:_theShippingTableView];
//            NSIndexPath *indexPath = [_theShippingTableView indexPathForRowAtPoint:brandPoint];
//            
//            [self deleteTheAddress:indexPath withAddressId:theModel.theAddressID];
//            
//        };
//        
//        cell.theSelectedAddressBlock = ^(ShippingAddressModel *theModel,UITouch *touch){
//            CGPoint brandPoint = [touch locationInView:_theShippingTableView];
//            NSIndexPath *indexPath = [_theShippingTableView indexPathForRowAtPoint:brandPoint];
//            [self toggleDefaultAddressForModel:[self.shippingDetailsArray objectAtIndex:indexPath.row]];
//        };
        [cell setExclusiveTouch:TRUE];
        
        return cell;
     }
    
    
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    if (self.theShippingEnum == ShippingAddressProfile) {
        if (indexPath.row>0) {
            [self editAddress:[self.shippingDetailsArray objectAtIndex:indexPath.row-1]];
        }

    }else{
        
        [self.view addSubview:shippingAddressLoader];
        [shippingAddressLoader startAnimating];
        
        __weak ShippingAddressListViewController *weakSelf = self;
        
        ShippingAddressModel *model = (ShippingAddressModel *)[self.shippingDetailsArray objectAtIndex:(indexPath.row - 1)];
        NSDictionary *paramDictionary = [[NSDictionary alloc] initWithObjects:@[model.theAddressID] forKeys:@[@"address_id"]];
        [theCartRequestHandler validateCartOnAddressSelect:paramDictionary withCompletionHandler:^(id responseData, NSError *error) {
            
            [shippingAddressLoader stopAnimating];
            [shippingAddressLoader removeFromSuperview];
            
            if(responseData){
                BOOL isValid = [responseData[@"is_valid"] boolValue];
                if(isValid){
                CartData *cartData = [[CartData alloc] initWithDictionary:responseData];
                    
                    if(self.delegate && [self.delegate respondsToSelector:@selector(newAddressSelected:)]){
                        [self.delegate newAddressSelected:cartData];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }else{
                    NSString *errorMessage = responseData[@"message"];
                    if(errorMessage && errorMessage.length > 0){
                        [SSUtility showOverlayViewWithMessage:errorMessage andColor:UIColorFromRGB(kRedColor)];
                    }else{
                        [weakSelf showErrorView:@"Some items not deliverable to this address"];
                    }
                }
            }else{
                [weakSelf showErrorView:@"Some items not deliverable to this address"];
            }
        }];
    }
}


-(void)showErrorView:(NSString *)errorMessage{
    if(self.errorView){
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
    __weak ShippingAddressListViewController *weakSelf = self;
    
    self.errorView = [[FyndErrorInfoView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-64, self.view.frame.size.width, 64)];
    [self.errorView showErrorView:errorMessage withRect:self.view.frame];
    
    self.errorView.errorAnimationBlock = ^(){
        if(weakSelf.errorView){
            [weakSelf.errorView removeFromSuperview];
            weakSelf.errorView = nil;
        }
    };
}



-(void)addAddress:(id)sender{
    [self editAddress:nil];
}
-(void)changeAdderss:(ShippingAddressModel *)theUpdatedModel{
    if (self.theAddressBlock) {
        self.theAddressBlock(theUpdatedModel);
    }
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 65;
    }else{

        ShippingAddressModel *theModel=(ShippingAddressModel *)[self.shippingDetailsArray objectAtIndex:indexPath.row-1];
        
        UIFont * labelFontLight = [UIFont fontWithName:kMontserrat_Light size:12.0];
        
        NSString *finalAddressString = [NSString stringWithFormat:@"%@, %@ - %@",theModel.theFlatNBuildingName,theModel.theStreetName,theModel.thePincode];
        
    CGSize addressSize = [SSUtility getLabelDynamicSize:finalAddressString withFont:labelFontLight withSize:CGSizeMake(tableView.frame.size.width-20, 20)];
//        CGSize addressSize = [SSUtility getDynamicSizeWithSpacing:finalAddressString withFont:labelFontLight withSize:CGSizeMake(tableView.frame.size.width-10, MAXFLOAT) spacing:3.0f];
        
        return ceilf(addressSize.height + 50);//125
    }
}
/*
-(void)deleteTheAddress:(NSIndexPath *)cellView withAddressId:(NSString *)addressID{
    
//    [SSUtility showActivityOverlay:self.view];
    [self.view addSubview:shippingAddressLoader];
    [shippingAddressLoader startAnimating];
    
    if(theCartRequestHandler == nil)
        theCartRequestHandler = [[CartRequestHandler alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:addressID forKey:@"address_id"];
    
    [theCartRequestHandler deleteShippingAdress:dict withCompletionHandler:^(id responseData, NSError *error) {
        if([[responseData valueForKey:@"is_deleted"] boolValue]){
            [self.shippingDetailsArray removeObjectAtIndex:cellView.row];
            
            if([self.shippingDetailsArray count]!=0){
               ShippingAddressModel *addressModel = [self.shippingDetailsArray objectAtIndex:0];
                addressModel.isDefaultAddress = TRUE;
                [self.shippingDetailsArray replaceObjectAtIndex:0 withObject:addressModel];
                
                if (self.theAddressBlock) {
                    self.theAddressBlock(addressModel);
                }
                [_theShippingTableView reloadData];
            }
            else{
                [self editAddress:nil];
            }
            
        }
        [shippingAddressLoader removeFromSuperview];
        [shippingAddressLoader stopAnimating];
    }];
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editAddress:(id)theEditModel{
    __weak ShippingAddressListViewController *weakShippingAddress = self;
    if(self.theAddressDetailPage){
        self.theAddressDetailPage = nil;
    }
    self.theAddressDetailPage = [[ShippingAddressDetailViewController alloc] init];
    if(self.theShippingEnum == ShippingAddressProfile){
        self.theAddressDetailPage.isComingFromCart = FALSE;
    }else{
        self.theAddressDetailPage.isComingFromCart = TRUE;
        self.theAddressDetailPage.delegate = self;
    }
    [self.navigationController pushViewController:self.theAddressDetailPage animated:TRUE];
    
    if (theEditModel == nil) {
        [self.theAddressDetailPage configureDetailScreenWithData:nil];
    }else{
        [self.theAddressDetailPage configureDetailScreenWithData:theEditModel];
    }
    
    self.theAddressDetailPage.theSaveBlock = ^(id model , BOOL isEditing){
        if (model != nil) {
            [weakShippingAddress updateList:model isEditing:isEditing];
        }else{
            [SSUtility showOverlayViewWithMessage:SOMETHING_WENT_WRONG andColor:UIColorFromRGB(kRedColor)];
        }

    };
    self.theAddressDetailPage.theDeleteBlock = ^(id model){
        if (model!= nil) {
            ShippingAddressModel *newModel = (ShippingAddressModel *)model;
            NSInteger updateIndex = 0;
            updateIndex = [self.shippingDetailsArray indexOfObject:newModel];
            [weakShippingAddress.shippingDetailsArray removeObjectAtIndex:updateIndex];
            [weakShippingAddress.theShippingTableView reloadData];
            [SSUtility showOverlayViewWithMessage:@"Address successfully removed" andColor:UIColorFromRGB(kGreenColor)];
        }else{
            [SSUtility showOverlayViewWithMessage:SOMETHING_WENT_WRONG andColor:UIColorFromRGB(kRedColor)];
        }
    };

}

-(void)newAddressAdded:(CartData *)data{
    if(self.delegate && [self.delegate respondsToSelector:@selector(newAddressSelected:)]){
        [self.delegate newAddressSelected:data];
    }
}

-(void)updateList:(id)modelObject isEditing:(BOOL)isEditing{
        ShippingAddressModel *newModel = (ShippingAddressModel *)modelObject;
        if (isEditing) {
            [SSUtility showOverlayViewWithMessage:@"Address updated successfully" andColor:UIColorFromRGB(kGreenColor)];
            NSInteger updateIndex = 0;
            updateIndex = [self.shippingDetailsArray indexOfObject:newModel];
            [self.shippingDetailsArray replaceObjectAtIndex:updateIndex withObject:newModel];
           
            NSIndexPath *updatedIndex = [NSIndexPath indexPathForRow:updateIndex inSection:0];
            [self.theShippingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:updatedIndex] withRowAnimation:UITableViewRowAnimationFade];
            if ([modelObject isDefaultAddress] && (self.theShippingEnum == ShippingAddressCart)) {
                selectedAddressModel = modelObject;
            }
            [self toggleDefaultAddressForModel:selectedAddressModel]; // Need to confirm , whether its require or not.
        }else{
            [SSUtility showOverlayViewWithMessage:@"Address added successfully" andColor:UIColorFromRGB(kGreenColor)];
            [self.shippingDetailsArray addObject:newModel];
            [self.theShippingTableView reloadData];
        }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:TRUE];
    if (self.theShippingEnum == ShippingAddressCart) {
        if (selectedAddressModel == nil) {
            //Stop the user and alert to selected one address.
        }else{
            /* // I think its of no use.
            if (self.theAddressBlock) {
                self.theAddressBlock(selectedAddressModel);
            }*/
        }
    }
}

-(void)toggleDefaultAddressForModel:(ShippingAddressModel *)theUpdatedModel{
    selectedAddressModel = theUpdatedModel;
    [self.shippingDetailsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ShippingAddressModel *theObj = (ShippingAddressModel *)obj;
        if (theObj.theAddressID == theUpdatedModel.theAddressID) {
            theObj.isDefaultAddress = TRUE;
        }else{
            theObj.isDefaultAddress = FALSE;
        }
        
    }];
    [_theShippingTableView reloadData];
}

@end
