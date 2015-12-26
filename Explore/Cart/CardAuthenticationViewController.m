//
//  CardAuthenticationViewController.m
//  Explore
//
//  Created by Amboj Goyal on 12/5/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "CardAuthenticationViewController.h"
#import "PaymentCartRequestHandler.h"


@interface CardAuthenticationViewController ()<UITextFieldDelegate>{
    int cvvCount;
    PaymentWebViewController *paymentWebViewController;
    CartScreenNavigationType screenType;
    CGFloat currentKeyboardHeight ;
    FyndActivityIndicator *bankCardLoader;
    PaymentCartRequestHandler *paymentRequestHandler;
     UIButton *cancelButton;
}

@property (nonatomic,strong)UIImageView *cardImageView;
@property (nonatomic,strong)UILabel *cardDetail;
@property (nonatomic,strong)UIScrollView *theScrollView;
@property (nonatomic,strong)UILabel *enterCVVLabel;

@property (nonatomic,strong) UITextField *cvvTextField;
@property (nonatomic,strong) UIView *cvvCircleContainer;
@property (nonatomic,strong) UIView *cvvCircle;
@property (nonatomic,strong) CardModel *theCardModel;
@property (nonatomic,strong) UILabel *cvvErrorLabel;
@property (nonatomic,strong) NSMutableArray *theCircleArray;
@property (nonatomic,strong) UIButton *doneButton;


@end

#define kCircleHorizontalPadding    8
#define kCircleSize    20
@implementation CardAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Enter CVV";
//    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
//    self.navigationController.navigationBar.translucent = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    [_cvvTextField becomeFirstResponder];
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width - 40, self.navigationController.navigationBar.frame.size.height/2 - 16, 32, 32)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"CrossGrey"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismissFilter:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTag:1444];
    [self.navigationController.navigationBar addSubview:cancelButton];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:TRUE];
    [_cvvTextField resignFirstResponder];
    
    [[self.navigationController.navigationBar viewWithTag:1444] removeFromSuperview];
    
}

//-(void)setBackButton{
//    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
//}
//-(void)backAction:(id)sender{
//    [self.navigationController popViewControllerAnimated:TRUE];
//}

-(void)dismissFilter:(id)sender{
    [_cvvTextField resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissCVVScreen)]) {
        [self.delegate dismissCVVScreen];
    }
}



-(void)configureCardAuthenticationViewWithCardModel:(CardModel *)theCardModel{
     currentKeyboardHeight = 0.0f;
    self.theCardModel = nil;

    if (self.theCircleArray) {
        [self.theCircleArray removeAllObjects];
        self.theCircleArray = nil;
    }
    self.theCardModel = theCardModel;
    if (_cardImageView) {
        [_cardImageView removeFromSuperview];
        _cardImageView = nil;
    }

    if (_cardDetail) {
        [_cardDetail removeFromSuperview];
        _cardDetail = nil;
    }

    if (_enterCVVLabel) {
        [_enterCVVLabel removeFromSuperview];
        _enterCVVLabel = nil;
    }
    if (_cvvTextField) {
        [_cvvTextField removeFromSuperview];
        _cvvTextField = nil;
    }
    
    
    if (_cvvCircleContainer) {
        [_cvvCircleContainer removeFromSuperview];
        _cvvCircleContainer = nil;
    }
    if (_cvvErrorLabel) {
        [_cvvErrorLabel removeFromSuperview];
        _cvvErrorLabel = nil;
    }
    
    if (_theScrollView) {
        [_theScrollView removeFromSuperview];
        _theScrollView = nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    self.theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, self.view.frame.size.height)];
    [self.theScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.theScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.theScrollView setShowsVerticalScrollIndicator:FALSE];
    [self.view addSubview:self.theScrollView];

    //configuring the card image
    UIImage *image = [UIImage imageNamed:theCardModel.cardImage];
    self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - RelativeSize(30, 320), 0, RelativeSize(60, 320), RelativeSize(60, 320))];
//        self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - image.size.width/2, 0, image.size.width, image.size.height)];
    [self.cardImageView setImage:image];
    [self.theScrollView addSubview:self.cardImageView];
    
    
    //Configuring the card name
    
    
    
    NSMutableAttributedString * cardName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@    ",theCardModel.cardName] attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:14]}];

    
    NSMutableAttributedString * paymentDetailString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"•••• %@",theCardModel.cardFormattedNumber] attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:14]}];
    
    [paymentDetailString setAttributes:@{NSFontAttributeName :[UIFont fontWithName:kMontserrat_Regular size:20], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)} range:NSMakeRange(0, 4)];
    
    [cardName appendAttributedString:paymentDetailString];
    
    NSString *finalStrSize = [NSString stringWithFormat:@"%@    •••• %@",theCardModel.cardName,theCardModel.cardFormattedNumber];
    
    CGSize cardDetailSize = [SSUtility getLabelDynamicSize:finalStrSize withFont:[UIFont variableFontWithName:kMontserrat_Light size:16.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.cardDetail = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - cardDetailSize.width/2, self.cardImageView.frame.origin.y + self.cardImageView.frame.size.height, cardDetailSize.width+35, cardDetailSize.height)];
    [self.cardDetail setAttributedText:cardName];

    
    [self.cardDetail setTextColor:UIColorFromRGB(kSignUpColor)];
    [self.cardDetail setBackgroundColor:[UIColor clearColor]];
    [self.theScrollView addSubview:self.cardDetail];

//    CGSize cvvSize = [SSUtility getLabelDynamicSize:@" ENTER CVV " withFont:[UIFont variableFontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(MAXFLOAT, 40)];
//
//    self.enterCVVLabel = [SSUtility generateLabel:@" ENTER CVV " withRect:CGRectMake(self.view.frame.size.width/2 - cvvSize.width/2, self.cardDetail.frame.origin.y + self.cardDetail.frame.size.height+5, cvvSize.width, 40) withFont:[UIFont variableFontWithName:kMontserrat_Light size:14.0f]];
//    
//    [self.enterCVVLabel setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
//    [self.enterCVVLabel setBackgroundColor:[UIColor clearColor]];
//    [self.theScrollView addSubview:self.enterCVVLabel];
    
    
    [self configureCVVInputField];
    
}

-(void)configureCVVInputField{
    
     cvvCount = 0;
    self.theCircleArray = [[NSMutableArray alloc] init];
    
    if (self.cvvCircleContainer) {
        [self.cvvCircleContainer removeFromSuperview];
        self.cvvCircleContainer = nil;
    }
    
    
    self.cvvCircleContainer = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 80, self.cardDetail.frame.size.height + self.cardDetail.frame.origin.y+20, 160, 40)];
    [self.cvvCircleContainer setBackgroundColor:[UIColor clearColor]];
    
    
    if ([[self.theCardModel.cardBrand uppercaseString] isEqualToString:@"AMEX"]) {
        cvvCount = 4;
    }else{
        cvvCount = 3;
    }
    float originofCircle = 0.0f;
    for (int cvvIndex = 0; cvvIndex<cvvCount; cvvIndex ++) {
        
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(originofCircle, 0, kCircleSize, kCircleSize)];
        circleView.layer.cornerRadius = kCircleSize/2;
        circleView.layer.borderWidth = 0.5f;
        circleView.layer.borderColor = UIColorFromRGB(kLightGreyColor).CGColor;
        circleView.tag = cvvIndex;
        
        originofCircle = originofCircle + kCircleSize + kCircleHorizontalPadding;
        [self.theCircleArray addObject:circleView];
        [self.cvvCircleContainer addSubview:circleView];
    }
    
    [self.cvvCircleContainer setFrame:CGRectMake(self.view.frame.size.width/2 - (originofCircle )/2, self.cvvCircleContainer.frame.origin.y, originofCircle-kCircleHorizontalPadding, kCircleSize)];
    
//    self.cvvCircleContainer.center = CGPointMake(self.enterCVVLabel.center.x, self.cvvCircleContainer.center.y);
    [self.theScrollView addSubview:self.cvvCircleContainer];
    
    
    //Creating the text Field
    
    self.cvvTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, 50, 0)];
    
//    [self.cvvTextField setBackgroundColor:UIColorFromRGB(kGreenColor)];
    [self.cvvTextField setTintColor:[UIColor clearColor]];
    self.cvvTextField.delegate = self;
    [self.cvvTextField becomeFirstResponder];
    [self.cvvTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.cvvTextField setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.cvvCircleContainer addSubview:self.cvvTextField];
    
    NSAttributedString *theDoneText = [[NSAttributedString alloc] initWithString:@"DONE" attributes:@{NSFontAttributeName:[UIFont fontWithName:kMontserrat_Regular size:16.0f],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - RelativeSize(130, 375), self.cvvCircleContainer.frame.origin.y + self.cvvCircleContainer.frame.size.height + 15, RelativeSize(240, 375), 44)];
    [self.doneButton.layer setCornerRadius:3.0f];
    [self.doneButton setClipsToBounds:TRUE];

    [self.doneButton setAttributedTitle:theDoneText forState:UIControlStateNormal];

    [self.doneButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [self.doneButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    [self.doneButton setHidden:TRUE];
    self.doneButton.center = CGPointMake(self.cvvCircleContainer.center.x, self.doneButton.center.y);
    [self.doneButton addTarget:self action:@selector(doPayment:) forControlEvents:UIControlEventTouchUpInside];
    [self.theScrollView addSubview:self.doneButton];
    
    [self.theScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.doneButton.frame.origin.y +self.doneButton.frame.size.height + 40)];
    
}

#pragma mark - UITextField Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL isValid = FALSE;
    NSString *finalStr = [self.cvvTextField.text stringByReplacingCharactersInRange:range withString:string];
    if (finalStr.length>cvvCount) {
        isValid = FALSE;
    }else{
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:textField.text];
        
        BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
        isValid = stringIsValid;
        [self fillCVVCircleWithLength:finalStr.length];
    }
    return isValid;
}

-(void)fillCVVCircleWithLength:(NSUInteger)length{
    
    if(cvvCount == length){
        [self.doneButton setHidden:FALSE];
    }else{
        [self.doneButton setHidden:TRUE];
    }
    if (cvvCount !=length) {
      UIView * dimView =(UIView *)[self.theCircleArray objectAtIndex:length];
        dimView.layer.borderColor = UIColorFromRGB(kLightGreyColor).CGColor;
        [dimView setBackgroundColor:[UIColor clearColor]];
    }
    if (length !=0) {
        UIView *highlightView = [self.theCircleArray objectAtIndex:(length-1)];
        highlightView.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;
        [highlightView setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
    }
    
}


-(void)doPayment:(id)sender{
    [self.cvvTextField resignFirstResponder];
    [self showLoader];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    
    [paramDictionary setObject:self.responseDictionary[@"order_id"] forKey:@"order_id"];
    
    [paramDictionary setObject:self.responseDictionary[@"merchant_id"] forKey:@"merchant_id"];
    
    [paramDictionary setObject:@"CARD" forKey:@"payment_method_type"];
    [paramDictionary setObject:self.responseDictionary[@"card_token"] forKey:@"card_token"];
    
    [paramDictionary setObject:self.cvvTextField.text forKey:@"card_security_code"];
    
    [paramDictionary setObject:@"true" forKey:@"redirect_after_payment"];
 
    [paramDictionary setObject:@"json" forKey:@"format"];
 
 
 
    paymentRequestHandler = [[PaymentCartRequestHandler alloc] init];
 
    [paymentRequestHandler fetchTransactionParamsFromJustPay:paramDictionary withCompletionHandler:^(id responseData, NSError *error) {
        [self hideLoader];
         if(responseData){
             NSDictionary *paymentDictionary = responseData[@"payment"];
             if(paymentDictionary){
                 NSDictionary *authenticationDictioanry = paymentDictionary[@"authentication"];
                 
                 if(authenticationDictioanry){
                     NSString *urlString = authenticationDictioanry[@"url"];
                     NSString *method = authenticationDictioanry[@"method"];
                     NSDictionary *params = authenticationDictioanry[@"params"];
                     [self hideLoader];
                         if (self.delegate && [self.delegate respondsToSelector:@selector(showPaymentWebViewWithURLString:andMethod:andParams:)]) {
                             [self.delegate showPaymentWebViewWithURLString:urlString andMethod:method andParams:params];
                         }
                 }
             }
         }
     
     }];
 

}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat deltaHeight = kbSize.height - currentKeyboardHeight;


    
    CGRect scrollViewHeight = self.theScrollView.frame;
    scrollViewHeight.size.height = scrollViewHeight.size.height - deltaHeight;
    self.theScrollView.frame = scrollViewHeight;
    
    currentKeyboardHeight = kbSize.height;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)paymentDoneNavigateToFeedWithSuccess:(BOOL)isSuccessful{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(paymentDoneNavigateToFeedWithSuccess:)]) {
//        [self.delegate paymentDoneNavigateToFeedWithSuccess:isSuccessful];
//    }
//}

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
