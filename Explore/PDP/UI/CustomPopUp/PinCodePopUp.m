//
//  PinCodePopUp.m
//  Explore
//
//  Created by Pranav on 17/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PinCodePopUp.h"
#import "SSLine.h"
@interface PinCodePopUp ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    PopHeaderView *popUpHeaderView;
}

@property (nonatomic,strong) UITableView    *deliveryOptionsTable;
@property (nonatomic,strong) NSMutableArray *dummyDeliveryData;
@property (nonatomic,strong) UIImageView    *deliveryImage;
@property (nonatomic,strong) UILabel        *deliveryTitle;
//@property (nonatomic,strong) UIImageView    *crossImage;
@property (nonatomic,strong) UIButton       *crossImage;
@property (nonatomic,strong) UIButton       *cancelButton;
@property (nonatomic,strong) UILabel        *error;
@property (nonatomic,strong) UIView         *clearButtonView;
@property (nonatomic,strong) NSString       *pindCodeMessage;

- (void)configurePopUp;
- (void)dummyDeleiveryOptions:(NSDictionary *)deliveryResponse;

@end
NSURLSessionDataTask *dataTask;
NSInteger tableViewHeight = 90.0f;
CGFloat errorCodeY = 0.0f;
#define kPinCodePadding     10.0f
NSInteger errorMessageX = 0;
@implementation PinCodePopUp


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
    }
    return self;
}

- (void)configurePopUp{
//    [self showHeader];
    
    self.deliveryImage = [[UIImageView alloc] initWithFrame:CGRectMake(kPinCodePadding, kPinCodePadding, 32, 32)];
    [self.deliveryImage setBackgroundColor:[UIColor clearColor]];
    [self.deliveryImage setImage:[UIImage imageNamed:@"Delivery"]];
    [self addSubview:self.deliveryImage];
    
    self.deliveryTitle = [SSUtility generateLabel:@"Check Delivery Options" withRect:CGRectMake(self.deliveryImage.frame.origin.x + self.deliveryImage.frame.size.width , self.deliveryImage.frame.origin.y, 200, 30) withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f]];
    [self.deliveryTitle setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [self.deliveryTitle setText:@"Check Delivery Options"];
    [self addSubview:self.deliveryTitle];
    

    
    self.crossImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crossImage setBackgroundColor:[UIColor clearColor]];
    [self.crossImage setImage:[UIImage imageNamed:@"CrossGrey"] forState:UIControlStateNormal];
    [self.crossImage setFrame:CGRectMake(self.frame.size.width - 2*kPinCodePadding-25, self.deliveryTitle.frame.origin.y + self.deliveryTitle.frame.size.height/2 -16, 32, 32)];
    [self.crossImage addTarget:self action:@selector(clickOnCross:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.crossImage];
    
    
    
    self.pinCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.deliveryImage.frame.origin.x+kPinCodePadding ,self.deliveryImage.frame.origin.y + self.deliveryImage.frame.size.height + kPinCodePadding, self.frame.size.width - 4*kPinCodePadding, 30)];

    
//    self.pinCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.deliveryImage.frame.origin.x+kPinCodePadding ,self.deliveryImage.frame.origin.y + self.deliveryImage.frame.size.height + kPinCodePadding, 100, 30)];
    [self.pinCodeTextField setBackgroundColor:[UIColor clearColor]];
    self.pinCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.pinCodeTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.pinCodeTextField setPlaceholder:@"Enter Pincode"];
    [self.pinCodeTextField setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [self.pinCodeTextField setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [self.pinCodeTextField setDelegate:self];
    [self.pinCodeTextField becomeFirstResponder];
    [self addSubview:self.pinCodeTextField];
    
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setBackgroundColor:[UIColor clearColor]];
    [self.cancelButton setTitle:@"Clear" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:UIColorFromRGB(kTurquoiseColor) forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:UIColorFromRGB(kButtonTouchStateColor) forState:UIControlStateHighlighted];
    self.cancelButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Regular size:15.0f];
    [self.cancelButton setFrame:CGRectMake(self.frame.size.width - 6*kPinCodePadding, self.pinCodeTextField.frame.origin.y, 40, 40)];
    [self.cancelButton addTarget:self action:@selector(clearPinCode:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.cancelButton];
    
    
    
//    SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(self.pinCodeTextField.frame.origin.x, self.pinCodeTextField.frame.origin.y + self.pinCodeTextField.frame.size.height, self.frame.size.width - self.pinCodeTextField.frame.origin.x -10, 1)];
    SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(self.pinCodeTextField.frame.origin.x, self.pinCodeTextField.frame.origin.y + self.pinCodeTextField.frame.size.height, self.pinCodeTextField.frame.size.width, 1)];
    [self addSubview:line];
    
    
    self.loadingSymbol = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.loadingSymbol setCenter:CGPointMake( self.frame.size.width/2,self.frame.size.height/2)];
    [self addSubview:self.loadingSymbol];
    
    self.pinCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat buttonWidth = (self.frame.size.width - (2*(RelativeSize(8, 320)) - 10))/2-10;
    
    [self.pinCodeButton setFrame:CGRectMake(RelativeSize(8, 320), self.frame.size.height - RelativeSizeHeight(10, 568) - 50,buttonWidth, 50)];
    [self.pinCodeButton setClipsToBounds:YES];
    [self.pinCodeButton.layer setCornerRadius:3.0];
    [self.pinCodeButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xD3D3D3)] forState:UIControlStateNormal];
    [self.pinCodeButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kBackgroundGreyColor)] forState:UIControlStateHighlighted];
    [self.pinCodeButton setTitleColor:UIColorFromRGB(kDarkPurpleColor) forState:UIControlStateNormal];
    [self.pinCodeButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [self.pinCodeButton.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [self.pinCodeButton addTarget:self action:@selector(dismissPopUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.pinCodeButton];
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkButton.layer setCornerRadius:3.0];
    [self.checkButton setClipsToBounds:YES];
//    [self.checkButton setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
    [self.checkButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [self.checkButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    [self.checkButton setFrame:CGRectMake(self.pinCodeButton.frame.origin.x + self.pinCodeButton.frame.size.width +10, self.pinCodeButton.frame.origin.y, self.pinCodeButton.frame.size.width, self.pinCodeButton.frame.size.height)];
    [self.checkButton setTitle:@"CHECK" forState:UIControlStateNormal];
    [self.checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkButton.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [self.checkButton addTarget:self action:@selector(validatePincode:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.checkButton];
}

- (void)clearPinCode:(id)sender{
    [self.pinCodeTextField setText:@""];
    self.pindCodeMessage = nil;
    if(self.pinCodeTextField.text.length == 0){
        [self removeDeliveryOptions];
    }
}

- (void)clickOnCross:(id)sender{
    if (self.tappedOnCancel) {
        self.tappedOnCancel();
    }
}

- (void)dummyDeleiveryOptions:(NSDictionary *)deliveryResponse{
    
    if(self.dummyDeliveryData){
        [self.dummyDeliveryData removeAllObjects];
        self.dummyDeliveryData = nil;
    }
    
    self.dummyDeliveryData = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(NSInteger counter=0; counter < 3; counter++){
        if(counter == 0){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dict setObject:@"Same Day Delivery" forKey:@"Option"];
            [dict setObject:[NSNumber numberWithBool:FALSE] forKey:@"devliveryOptionsAvailable"];
            [dict setObject:[NSNumber numberWithBool:[[deliveryResponse objectForKey:@"same_day_slot_available"] boolValue]] forKey:@"devliveryOptionsAvailable"];
            [self.dummyDeliveryData addObject:dict];
        }else if(counter == 1){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dict setObject:@"Next Day Delivery" forKey:@"Option"];
//            [dict setObject:[deliveryResponse objectForKey:@"next_day_slot_available"] boolValue] forKey:@"devliveryOptionsAvailable"];
            [dict setObject:[NSNumber numberWithBool:[[deliveryResponse objectForKey:@"next_day_slot_available"] boolValue]] forKey:@"devliveryOptionsAvailable"];
            
            
            [self.dummyDeliveryData addObject:dict];
        }else if(counter ==2){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dict setObject:@"Fynd A Fit" forKey:@"Option"];
            [dict setObject:[NSNumber numberWithBool:[[deliveryResponse objectForKey:@"fynd_a_fit_available"] boolValue]] forKey:@"devliveryOptionsAvailable"];
            [self.dummyDeliveryData addObject:dict];
        }
    }
    
}

#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return TRUE;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-80, self.frame.size.width, self.frame.size.height)];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int length = (int)[currentString length];
    BOOL aBool = TRUE;
    if(length == 0){
        [self removeDeliveryOptions];
    }if(length == 7){
        aBool = FALSE;
    }
    return aBool;
}

-(void)validatePincode:(id)sender{
    
    if([self isPinCodeValid])
    {
        if(self.error){
            [self.error removeFromSuperview];
            self.error = nil;
        }
    
        NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
        [urlString appendString:@"check-item-availability-by-pincode/?"];
        
//        NSString *searchURL =[NSString stringWithFormat:@"%@product_id=%d&pincode=%@",urlString,1, self.pinCodeTextField.text];
        NSString *searchURL =[NSString stringWithFormat:@"%@product_id=%@&pincode=%@",urlString,self.productId, self.pinCodeTextField.text];
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:searchURL]];
//        [request setValue:@"am9zaHVhOmNhcHR1cmVyZXRhaWw=" forHTTPHeaderField:@"Authorization"];
        
        [self.loadingSymbol startAnimating];
        [self.messageLabel setText:@"Checking...."];
        dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
                BOOL result = [[json valueForKey:@"is_available"] boolValue];
                if(result){
                    [self dummyDeleiveryOptions:json];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pinCodeTextField resignFirstResponder];
                        [self configureDeliveryList];
                    });
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.pindCodeMessage = @"Pincode is not servicable";
                        self.availabilityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.pinCodeTextField.frame.origin.x, self.pinCodeTextField.frame.origin.y + self.pinCodeTextField.frame.size.height+kPinCodePadding, 12, 12)];
                        [self.availabilityIcon setBackgroundColor:[UIColor clearColor]];
                        [self.availabilityIcon setHidden:FALSE];
                        [self.availabilityIcon setImage:[UIImage imageNamed:@"cannot_deliver"]];
                        errorCodeY = self.availabilityIcon.frame.origin.y-3;
                        [self addSubview:self.availabilityIcon];
                        errorMessageX = self.availabilityIcon.frame.origin.x + self.availabilityIcon.frame.size.width + kPinCodePadding;
                        
                        [self showErroMessage:self.pindCodeMessage];
                        
                    });
                }
        }];
        
        [dataTask resume];
    }else{
        errorCodeY = self.pinCodeTextField.frame.origin.y + self.pinCodeTextField.frame.size.height;
        errorMessageX = self.pinCodeTextField.frame.origin.x;
        [self showErroMessage:self.pindCodeMessage];
    }

}


-(BOOL)isPinCodeValid{
    
    
    if(self.deliveryOptionsTable){
        [self removeDeliveryOptions];
    }
    if(self.availabilityIcon){
        [self.availabilityIcon removeFromSuperview];
        self.availabilityIcon = nil;
    }
    
    BOOL valid = false;
    NSString *textToValidate = self.pinCodeTextField.text;
    [textToValidate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *textToValidate1 = [[self.pinCodeTextField.text componentsSeparatedByString:@" "] lastObject];
    [textToValidate1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *phoneRegex = @"[1-9]{1}[0-9]{5}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL valid1 = [test evaluateWithObject:textToValidate1];
    
    if(textToValidate.length ==0){
        self.pindCodeMessage = @"Pincode cannot be empty";
        valid = false;
        
    }else if(textToValidate.length == 6){
        if(valid1)
            valid = TRUE;
        else{
            valid1 = false;
            self.pindCodeMessage = @"Pincode cannot start with 0";
        }
        
    }else{
//        if(!self.pindCodeMessage)
        {
            self.pindCodeMessage = @"Pincode should be 6 digits long";
        }
        valid = false;
    }
    return valid;
}



-(void)updatePinCodeAvailabilityWith:(BOOL)isAvailable{
    [self.loadingSymbol stopAnimating];
    if (isAvailable) {
        [self.messageLabel setText:[NSString stringWithFormat:@"Available @ %@",self.pinCodeTextField.text]];
        [self.messageLabel setHidden:TRUE];
        [self.availabilityIcon setHidden:FALSE];
        [self.availabilityIcon setImage:[UIImage imageNamed:@""]];
//        [self configureDeliveryList];
    }else{
        [self.messageLabel setText:[NSString stringWithFormat:@"Oops !! Not Available @ %@",self.pinCodeTextField.text]];
        [self.messageLabel setHidden:FALSE];
        [self.availabilityIcon setHidden:FALSE];
        
    }
}

- (void)showErroMessage:(NSString *)message{
    
    if(self.error){
        [self.error removeFromSuperview];
        self.error = nil;
    }
    
    [self.loadingSymbol stopAnimating];
    NSString *errorMessage = message;
    CGSize erroMessageSizse = [SSUtility getLabelDynamicSize:errorMessage withFont:[UIFont fontWithName:kMontserrat_Light size:13.0f] withSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
   
    /*
    self.error = [SSUtility generateLabel:errorMessage withRect:CGRectMake(self.availabilityIcon.frame.origin.x + self.availabilityIcon.frame.size.width + kPinCodePadding, errorCodeY, erroMessageSizse.width, erroMessageSizse.height) withFont:[UIFont fontWithName:kMontserrat_Light size:13.0f]];
     */
    self.error = [SSUtility generateLabel:errorMessage withRect:CGRectMake(errorMessageX, errorCodeY, erroMessageSizse.width, erroMessageSizse.height) withFont:[UIFont fontWithName:kMontserrat_Light size:13.0f]];
   
    [self.error setNumberOfLines:0];
    [self.error setBackgroundColor:[UIColor clearColor]];
    [self.error setText:errorMessage];
    [self.error setTextColor:UIColorFromRGB(kPinkColor)];
    [self addSubview:self.error];
}

-(void)dismissPopUp:(id)sender{
    if (self.tappedOnCancel) {
        self.tappedOnCancel();
    }
}

-(void)showHeader{
    popUpHeaderView = [[PopHeaderView alloc] init];
    [self addSubview:[popUpHeaderView popHeaderViewWithTitle:@"CHECK DELIVERY" andImageName:@"delivery.png" withOrigin:CGPointMake(RelativeSize(-11, 320), self.frame.origin.y-RelativeSizeHeight(140, 568))]];
    __weak PinCodePopUp *overlayWeak = self;
    popUpHeaderView.popHeaderBlock = ^(){
        [overlayWeak dismissPopUp:nil];
    };

}


- (void)configureDeliveryList{
    
    if(self.error){
        [self.error removeFromSuperview];
        self.error = nil;
    }
    if(self.availabilityIcon){
        [self.availabilityIcon removeFromSuperview];
        self.availabilityIcon = nil;
    }
    [self.loadingSymbol stopAnimating];
    
    if(self.deliveryOptionsTable == nil){
        self.deliveryOptionsTable = [[UITableView alloc] initWithFrame:CGRectMake(self.pinCodeTextField.frame.origin.x, self.pinCodeTextField.frame.origin.y + self.pinCodeTextField.frame.size.height + 1.5*kPinCodePadding, self.frame.size.width - self.pinCodeTextField.frame.origin.x, tableViewHeight)];
        [self.deliveryOptionsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.deliveryOptionsTable.dataSource = self;
        self.deliveryOptionsTable.delegate = self;
        [self.deliveryOptionsTable setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.deliveryOptionsTable];
        
        
        [self.pinCodeButton setFrame:CGRectMake(self.pinCodeButton.frame.origin.x, self.pinCodeButton.frame.origin.y + self.deliveryOptionsTable.frame.size.height, self.pinCodeButton.frame.size.width, self.pinCodeButton.frame.size.height)];
        [self.checkButton setFrame:CGRectMake(self.checkButton.frame.origin.x, self.pinCodeButton.frame.origin.y, self.checkButton.frame.size.width, self.checkButton.frame.size.height)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + self.deliveryOptionsTable.frame.size.height)];
        
        if(self.updatePinCodeLayPutBlock){
            self.updatePinCodeLayPutBlock(self.frame.size);
        }
    }else{
        [self.deliveryOptionsTable reloadData];
    }
}


- (void)removeDeliveryOptions{
    if(self.error){
        [self.error removeFromSuperview];
        self.error = nil;
    }
    if(self.availabilityIcon){
        [self.availabilityIcon removeFromSuperview];
        self.availabilityIcon = nil;
    }
    if(self.deliveryOptionsTable && [self.dummyDeliveryData count]>0){
        [self.dummyDeliveryData removeAllObjects];
        self.dummyDeliveryData = nil;
        [self.deliveryOptionsTable reloadData];
        
       
        
        [self.deliveryOptionsTable removeFromSuperview];
        self.deliveryOptionsTable = nil;
        
        
        [UIView commitAnimations];
        [UIView setAnimationDuration:0.5f];
        [self.pinCodeButton setFrame:CGRectMake(self.pinCodeButton.frame.origin.x, self.pinCodeButton.frame.origin.y - tableViewHeight, self.pinCodeButton.frame.size.width, self.pinCodeButton.frame.size.height)];
        [self.checkButton setFrame:CGRectMake(self.checkButton.frame.origin.x, self.pinCodeButton.frame.origin.y, self.checkButton.frame.size.width, self.checkButton.frame.size.height)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - tableViewHeight)];
        [UIView commitAnimations];
        
        if(self.updatePinCodeLayPutBlock){
            self.updatePinCodeLayPutBlock(self.frame.size);
        }
    }
    
}


- (NSArray *)indexPathForStores:(NSInteger)rows{
    
    NSMutableArray *indexPathArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSInteger counter=0; counter< rows; counter++){
        [indexPathArray addObject:[NSIndexPath indexPathForRow:counter inSection:1]];
    }
    return [indexPathArray copy];
}


#pragma mark UITableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dummyDeliveryData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"DeliveryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        UIView *deliveryView = [self deliveryOptionCellView:[self.dummyDeliveryData objectAtIndex:indexPath.row]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:deliveryView];
    }
    
    return cell;
}


- (UIView *)deliveryOptionCellView:(NSMutableDictionary *)deliveryDict{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-20, 40)];
    [aView setBackgroundColor:[UIColor whiteColor]];
    
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(RelativeSize(25, 320), 10, 20, 20)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    [image setBackgroundColor:[UIColor clearColor]];
    
    NSString *imageName =  nil;
    UIColor *deliveryTextColor;
    if([[deliveryDict objectForKey:@"devliveryOptionsAvailable"] boolValue]){
        imageName = @"PinCodeTick"; //@"filter_selected";
//        imageName = @"pinCodeCross";
        deliveryTextColor = UIColorFromRGB(kDarkPurpleColor);
    }
    else{
        imageName = @"PinCodeCross"; //@"cross";
        deliveryTextColor = UIColorFromRGB(kLightGreyColor);
    }
    
    [image setImage:[UIImage imageNamed:imageName]];
    [aView addSubview:image];
    
    NSString *deliveryString = [deliveryDict objectForKey:@"Option"];
    CGSize size = [SSUtility getLabelDynamicSize:deliveryString withFont:[UIFont fontWithName:kMontserrat_Light size:15.0f] withSize:CGSizeMake(self.frame.size.width, 40 )];
    UILabel *deliveryType = [SSUtility generateLabel:deliveryString withRect:CGRectMake(image.frame.origin.x + image.frame.size.width + kPinCodePadding, aView.frame.size.height/2 - size.height/2, 200, size.height) withFont:[UIFont fontWithName:kMontserrat_Light size:15.0f]];
    [deliveryType setTextAlignment:NSTextAlignmentLeft];
    [deliveryType setBackgroundColor:[UIColor clearColor]];
    [deliveryType setText:deliveryString];
    [deliveryType setTextColor:deliveryTextColor];
    [aView addSubview:deliveryType];
    
    return aView;
}


- (void)animateDeliveryOptions{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0f];
    [self.deliveryOptionsTable setFrame:CGRectMake(self.deliveryOptionsTable.frame.origin.x, self.deliveryOptionsTable.frame.origin.y, self.deliveryOptionsTable.frame.size.width, 90.0f)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
