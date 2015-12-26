//
//  AddCartPopUp.m
//  Explore
//
//  Created by Pranav on 24/11/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "AddCartPopUp.h"
#import "SSLine.h"
#import "Luhn.h"
//#import "BankCardData.h"
#import <QuartzCore/QuartzCore.h>
#import "BKCardNumberField.h"
#import "BKCardExpiryField.h"
#import "BKCurrencyTextField.h"


typedef enum BankCardInputFieldType{
    BankCardInputFieldCardNumber,
    BankCardInputFieldCardExpiry,
    BankCardInputFieldCardName
}BankCardInputType;

#define kAcceptedCardWidth 40
#define kAcceptedCardHeight 25
#define kTickMargin_X       40

#define kCardNumberFont [UIFont variableFontWithName:kMontserrat_Light size:18.0f]
#define kCardExpiryFont [UIFont variableFontWithName:kMontserrat_Light size:16.0f]
#define kCardNameFont   [UIFont variableFontWithName:kMontserrat_Light size:16.0f]

//#define kCardNumberFont [UIFont fontWithName:kMontserrat_Light size:16]
//#define kCardExpiryFont [UIFont fontWithName:kMontserrat_Light size:15]
//#define kCardNameFont   [UIFont fontWithName:kMontserrat_Light size:15]


@interface AddCartPopUp()
{
    BankCardInputType inputType;
//    NSTimer             *vaidateTimer;
    BankCard   cardBrand;
    OLCreditCardType   luhnCardType;
    NSMutableDictionary *cardLengthDict;
    BOOL                isCardContainerUp;
    BOOL                numberVaidatedIntially;
}
@end

@interface AddCartPopUp()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel     *focusFieldHeading;
@property (nonatomic,strong) UIButton    *crossButton;
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UIImageView *cardBrandLogo;
@property (nonatomic,strong) UILabel     *errorMessage;
@property (nonatomic,strong) SSLine      *line;
//@property (nonatomic,strong) BankCardData  *addCardData;
@property (nonatomic,strong) CardModel  *addCardData;

@property (strong, nonatomic)   BKCardNumberField *cardNumberTextField;
@property (strong, nonatomic)   BKCardExpiryField *expiryTextField;
@property (nonatomic,assign)    NSInteger  maxCardLength;
@property (nonatomic,strong)    NSArray  *maxCardLengthArray;
@property (strong, nonatomic)   UIImageView *cardNumberValidTick;
@property (strong, nonatomic)   UIImageView *cardExpiryValidTick;
@property (nonatomic,strong)    NSMutableString    *inputData;
@property (nonatomic,strong)    UIView             *cardAcceptedView;
@property (nonatomic,strong)    UIScrollView        *cardScrollView;
@property (nonatomic,strong)    NSDictionary        *cardLengthData;

@property (nonatomic,strong)    UIView *bottomAccessoryView;

- (void)showBottomBarButtons;
- (void)generateAcceptedCard;
@end

#define xPadding 10.0f
#define kCardNameMaxLimit 18
#define kInputFieldHeight 30

@implementation AddCartPopUp

- (id)initWithFrame:(CGRect)frame{
    
    if(self == [super initWithFrame:frame]){
        cardLengthDict = [[NSMutableDictionary alloc] initWithCapacity:0];

        [cardLengthDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:13],@"cardMinLength",[NSNumber numberWithInt:16],@"cardMaxLength", nil] forKey:@"visa"];
        [cardLengthDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:14],@"cardMinLength",[NSNumber numberWithInt:14],@"cardMaxLength", nil] forKey:@"dinnersclub"];
        [cardLengthDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:15],@"cardMinLength",[NSNumber numberWithInt:15],@"cardMaxLength", nil] forKey:@"amex"];
        [cardLengthDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:12],@"cardMinLength",[NSNumber numberWithInt:19],@"cardMaxLength", nil] forKey:@"maestro"];
        [cardLengthDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:16],@"cardMinLength",[NSNumber numberWithInt:16],@"cardMaxLength", nil] forKey:@"mastercard"];
        [cardLengthDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:16],@"cardMinLength",[NSNumber numberWithInt:16],@"cardMaxLength", nil] forKey:@"rupay"];
        
        
    }
    return self;
}


- (void)configureAddCart
{

    self.cardScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.cardScrollView setUserInteractionEnabled:TRUE];
    [self.cardScrollView setBackgroundColor:[UIColor clearColor]];
    [self.cardScrollView setShowsVerticalScrollIndicator:FALSE];

    [self addSubview:self.cardScrollView];
    
    self.crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crossButton setBackgroundColor:[UIColor clearColor]];
    [self.crossButton setBackgroundImage:[UIImage imageNamed:@"CrossGrey"] forState:UIControlStateNormal];
    [self.crossButton setFrame:CGRectMake(self.frame.size.width - RelativeSize(40, 375), RelativeSizeHeight(30, 675), 30, 30)];
    [self.crossButton addTarget:self action:@selector(closePopUp) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.crossButton];
    
    
//    self.cardBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake((RelativeSize(15, 320)), self.cardScrollView.frame.size.height/2- RelativeSizeHeight(120, 480),self.cardScrollView.frame.size.width -RelativeSize(30, 320),160)];//RelativeSizeHeight(160, 480)

    if (DeviceWidth<375) {
//        self.cardBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake((RelativeSize(15, 320)), self.cardScrollView.frame.size.height/2- 120,self.cardScrollView.frame.size.width -RelativeSize(30, 320),160)];
        self.cardBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake((RelativeSize(5, 320)), self.cardScrollView.frame.size.height/2- 130,self.cardScrollView.frame.size.width -RelativeSize(10, 320),180)];
        
        
    }else{
        self.cardBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.cardScrollView.frame.size.height/2- 130,self.cardScrollView.frame.size.width -20,200)];
    }
    
    if (kDeviceHeight == 480){
        self.cardBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake((RelativeSize(5, 320)), self.cardScrollView.frame.size.height/2- 130,self.cardScrollView.frame.size.width -RelativeSize(10, 320),160)];
    }
    
    self.cardBackgroundImage.clipsToBounds = TRUE;
    [self.cardBackgroundImage setBackgroundColor:[UIColor clearColor]];
    [self.cardBackgroundImage setImage:[UIImage imageNamed:@"AddCardBackground"]];
    [self.cardBackgroundImage setUserInteractionEnabled:TRUE];
    [self.cardScrollView addSubview:self.cardBackgroundImage];
    
    UITapGestureRecognizer *tapCard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.cardBackgroundImage addGestureRecognizer:tapCard];
    
    //Configure Card Number
//    self.cardNumberTextField = [[BKCardNumberField alloc] initWithFrame:CGRectMake(2*xPadding, RelativeSizeHeight(2*xPadding, 480), self.cardBackgroundImage.frame.size.width - 8*xPadding, kInputFieldHeight)];
    
    self.cardNumberTextField = [[BKCardNumberField alloc] initWithFrame:CGRectMake(RelativeSize(30, 320), 25, self.cardBackgroundImage.frame.size.width - 95, kInputFieldHeight)];

    self.cardNumberTextField.delegate = self;

    [self.cardNumberTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"5241 4386 9641 0646" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x9C9DA4)}]];
    self.cardNumberTextField.tag = BankCardInputFieldCardNumber;
    self.cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.cardNumberTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.cardNumberTextField setTextColor:[UIColor whiteColor]];
    [self.cardNumberTextField setFont:kCardNumberFont];
    if(!self.isAddingCard){
        if(self.selectedCard.cardNumber && self.selectedCard.cardNumber.length>0){
            [self populateFormattedNumberWithString:self.selectedCard.cardNumber];
        }
    }else{
        [self.cardNumberTextField becomeFirstResponder];
    }
    
    [self.cardNumberTextField addTarget:self action:@selector(cardNumberFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.cardBackgroundImage addSubview:self.cardNumberTextField];
    
    //Configure Card Expiry Date
    self.expiryTextField = [[BKCardExpiryField alloc] initWithFrame:CGRectMake(self.cardNumberTextField.frame.origin.x, self.cardNumberTextField.frame.origin.y + self.cardNumberTextField.frame.size.height + RelativeSizeHeight(15, 480), 60, kInputFieldHeight)];
    self.expiryTextField.delegate = self;
    self.expiryTextField.userInteractionEnabled = FALSE;
    self.expiryTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.expiryTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.expiryTextField.tag = BankCardInputFieldCardExpiry;
    [self.expiryTextField setFont:kCardExpiryFont];
    self.expiryTextField.textColor = [UIColor whiteColor];
    
    if(self.selectedCard!=nil){
        NSString *monthString = self.selectedCard.expiryMonth;
        if ([monthString integerValue]<10) {
            monthString = [NSString stringWithFormat:@"0%@",monthString];
        }

    [self.expiryTextField setText:[NSString stringWithFormat:@"%@ / %@",monthString,self.selectedCard.expiryYear]];
    }

    [self.expiryTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"MM/YY" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x9C9DA4)}]];
    [self.cardBackgroundImage addSubview:self.expiryTextField];
    
    //Configure Card Name
//    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.cardNumberTextField.frame.origin.x,self.expiryTextField.frame.origin.y +self.expiryTextField.frame.size.height + RelativeSizeHeight(15, 480), self.cardBackgroundImage.frame.size.width - 8*xPadding, kInputFieldHeight)];
    
    
//    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.cardNumberTextField.frame.origin.x, self.cardBackgroundImage.frame.size.height - RelativeSizeHeight(15, 480) - kInputFieldHeight, self.cardBackgroundImage.frame.size.width - RelativeSize(90, 320), kInputFieldHeight)];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.cardNumberTextField.frame.origin.x, self.cardBackgroundImage.frame.size.height - 25 - kInputFieldHeight, self.cardBackgroundImage.frame.size.width - RelativeSize(90, 320), kInputFieldHeight)];
    self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;

    self.nameTextField.userInteractionEnabled = FALSE;
    [self.nameTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x9C9DA4)}]];
    self.nameTextField.delegate = self;
    [self.nameTextField setFont:kCardNameFont];
    [self.nameTextField setTextColor:[UIColor whiteColor]];
    [self.nameTextField setBackgroundColor:[UIColor clearColor]];
//    if(self.selectedCard.cardName && self.selectedCard.cardName.length>0){
    if(!self.isAddingCard){
        [self performSelector:@selector(cardNameInEditingMode) withObject:nil afterDelay:0.2f];
    }
    self.nameTextField.tag = BankCardInputFieldCardName;
//    self.nameTextField.keyboardType = UIKeyboardTypeAlphabet;
    self.nameTextField.keyboardType = UIKeyboardTypeDefault;
    self.nameTextField.returnKeyType = UIReturnKeyDone;
    
    [self.cardBackgroundImage addSubview:self.nameTextField];
    
    //Configure Card Logo
//    self.cardBrandLogo = [[UIImageView alloc] initWithFrame:CGRectMake(self.cardBackgroundImage.frame.size.width - 7*xPadding, self.nameTextField.frame.origin.y - RelativeSizeHeight(2*xPadding, 480), 4*xPadding, 4*xPadding)];
    
    self.cardBrandLogo = [[UIImageView alloc] initWithFrame:CGRectMake(self.cardBackgroundImage.frame.size.width - RelativeSize(80, 320), self.cardBackgroundImage.frame.size.height - RelativeSizeHeight(20, 480)-40, RelativeSize(51, 320), RelativeSize(34, 320))];
    self.cardBrandLogo.layer.cornerRadius = 5.0f;
    self.cardBrandLogo.clipsToBounds = TRUE;
    [self.cardBrandLogo setBackgroundColor:[UIColor clearColor]];
    [self.cardBrandLogo setImage:[UIImage imageNamed:@""]];
    if (self.selectedCard.cardImage && self.selectedCard.cardImage!= nil) {
        [self.cardBrandLogo setBackgroundColor:[UIColor whiteColor]];
        if ([[self.selectedCard.cardBrand lowercaseString] isEqualToString:@"visa"]) {
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"VisaRect"]];
            
        }else if ([[self.selectedCard.cardBrand lowercaseString] isEqualToString:@"maestro"]){
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"MaestroRect"]];
        }else if ([[self.selectedCard.cardBrand lowercaseString] isEqualToString:@"visaelectron"]){
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"VisaRect"]];
            
        }else if ([[self.selectedCard.cardBrand lowercaseString] isEqualToString:@"dinnersclub"]){
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"DinersRect"]];
            
        }else if ([[self.selectedCard.cardBrand lowercaseString] isEqualToString:@"mastercard"]){
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"MasterRect"]];
            
        }else if ([[self.selectedCard.cardBrand lowercaseString] isEqualToString:@"amex"]){
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"AmexRect"]];
        }else if ([[self.selectedCard.cardBrand lowercaseString] isEqualToString:@"rupay"]){
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"RupayRect"]];
        }else{
            [self.cardBrandLogo setImage:[UIImage imageNamed:@""]];
        }
    }
    [self.cardBackgroundImage addSubview:self.cardBrandLogo];
    
    
    //Configure Card Focus Field Heading
    CGSize size = [SSUtility getLabelDynamicSize:@"Enter Card Number" withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    self.focusFieldHeading = [SSUtility generateLabel:@"Enter Card Number" withRect:CGRectMake(self.frame.size.width/2 - size.width/2, self.cardBackgroundImage.frame.origin.y - (size.height + RelativeSizeHeight(10, 667)), size.width, size.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [self.focusFieldHeading setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [self.focusFieldHeading setBackgroundColor:[UIColor clearColor]];
    [self.cardScrollView addSubview:self.focusFieldHeading];
    
    //Calculating the height gap and center Aligning the Expiry Date.
    
    CGFloat expiryDateOrigin = (self.nameTextField.frame.origin.y - (self.cardNumberTextField.frame.origin.y + self.cardNumberTextField.frame.size.height));
    
    [self.expiryTextField setFrame:CGRectMake(self.cardNumberTextField.frame.origin.x,  self.cardNumberTextField.frame.origin.y + self.cardNumberTextField.frame.size.height +
                                              expiryDateOrigin/2 - kInputFieldHeight/2, 60, kInputFieldHeight)];

    
}

- (void)closePopUp{
    
    if([self.addCartDelegate respondsToSelector:@selector(actionPerormOnAddCard:andAddedCard:)]){
        [self.addCartDelegate actionPerormOnAddCard:-100 andAddedCard:nil];
    }
}


- (void)cardNameInEditingMode{
    self.nameTextField.userInteractionEnabled = TRUE;
    [self.nameTextField becomeFirstResponder];
    [self.nameTextField setText:self.selectedCard.cardName];
    [self showBottomBarButtons];
}

#pragma mark UITextField Delegate Methods


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.line.hidden = FALSE;
    if(textField.tag == BankCardInputFieldCardName){
        if (self.isAddingCard) {
            self.focusFieldHeading.text = @"Enter Card Name";
        }else{
            self.focusFieldHeading.text = @"Edit Card Name";
        }
        [self checkCardNameFieldAndShowButtons];
    }else if(textField.tag == BankCardInputFieldCardExpiry){
        self.focusFieldHeading.text = @"Enter Expiry Date";
        if(!numberVaidatedIntially)
        {
            NSString *cardNumberString = [self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            [self validateCardNumberField:cardNumberString];
        }
    }else if(textField.tag == BankCardInputFieldCardNumber){
        self.focusFieldHeading.text = @"Enter Card Number";
        [self.cardNumberTextField setTextColor:[UIColor whiteColor]];
        if (self.expiryTextField.text.length>0) {
            if (![self validateCardExpiry:self.expiryTextField.text]) {
                [self addInputFieldValidTick:BankCardInputFieldCardExpiry cardType:cardBrand isValid:FALSE];
            }
        }
    }
    return TRUE;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"cleared");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        return FALSE;
    }else{
        [self addButtonActionWithTag:1];
        return TRUE;
    }

    return TRUE;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL aBool = TRUE;
    
    if(textField.tag == BankCardInputFieldCardNumber){
        NSString *inputData1 = [self.cardNumberTextField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *cardNumberString = [inputData1 stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (cardNumberString.length<20) {
            aBool = TRUE;
        }else{
            aBool = FALSE;
        }
        if(cardNumberString.length == 0){
            if(self.errorMessage){
                [self.errorMessage removeFromSuperview];
                self.errorMessage = nil;
            }
            [self.cardNumberTextField setTextColor:[UIColor whiteColor]];
            if(self.cardAcceptedView){
                [self.cardAcceptedView removeFromSuperview];
                self.cardAcceptedView = nil;
            }
            [self animateCardScrollView:FALSE];
        }
        

        if([self checkCardLengthValidity:cardNumberString]){
            [self addInputFieldValidTick:BankCardInputFieldCardNumber cardType:cardBrand isValid:TRUE];
        }
        
        

        
    }else if(textField.tag == BankCardInputFieldCardExpiry){
        NSString *str = [self.expiryTextField.text stringByReplacingCharactersInRange:range withString:string];
        if(str.length == 7){
            if ([self validateCardExpiry:str]) {
                [self.nameTextField setUserInteractionEnabled:TRUE];
               [self addInputFieldValidTick:BankCardInputFieldCardExpiry cardType:cardBrand isValid:TRUE];
            }else{
               [self addInputFieldValidTick:BankCardInputFieldCardExpiry cardType:cardBrand isValid:FALSE];
            }
            
        }else{
            [self.nameTextField setUserInteractionEnabled:FALSE];
            [self clear];
        }
    }
    else if(textField.tag == BankCardInputFieldCardName){
        NSString *str = [self.nameTextField.text stringByReplacingCharactersInRange:range withString:string];

        if (![self validateCardName:str]){
            aBool = FALSE;
        }else if ([str isEqualToString:@" "]){
            aBool = FALSE;
        }
        else {
            // valid
            if(str.length > kCardNameMaxLimit){
                aBool = FALSE;
            }
            else if(str.length >=1){
                self.addCardData.cardName = self.nameTextField.text;
                [self showBottomBarButtons];
                [self checkCardNameFieldAndShowButtons];
            }
            else if(str.length == 0){

                [self animateCardScrollView:FALSE];
            }
            else{
                textField.inputAccessoryView = nil;
            }
        }
    }
    
    return aBool;
}

- (BOOL)checkCardLengthValidity:(NSString *)cardText{
    BOOL cardLengthValid = FALSE;
    
    BOOL isCardNumberValid = FALSE;
    NSNumber *maxLength = [self.cardLengthData objectForKey:@"cardMaxLength"];

    if (cardBrand != UnknownBankCard) {
        numberVaidatedIntially = false;
        [self.cardNumberTextField setTextColor:[UIColor whiteColor]];
    }

    if (cardText.length == [maxLength integerValue]) {
        if (cardBrand != UnknownBankCard) {
            isCardNumberValid = [Luhn validateString:cardText];
            if (isCardNumberValid) {
                cardLengthValid = TRUE;
                [self.cardNumberTextField setTextColor:[UIColor whiteColor]];
            }else{
                cardLengthValid = FALSE;
                [self addInputFieldValidTick:BankCardInputFieldCardNumber cardType:cardBrand isValid:FALSE];
            }
        }
    }else{
        if(self.cardNumberValidTick){
            [self.cardNumberValidTick removeFromSuperview];
            self.cardNumberValidTick = nil;
        }

    }
    
    if (cardText.length>18 && cardBrand == UnknownBankCard) {
        [self addInputFieldValidTick:BankCardInputFieldCardNumber cardType:cardBrand isValid:FALSE];
    }
    
    return cardLengthValid;
}


- (BOOL)validateCardNumberField:(NSString *)cardNumberString{
    BOOL cardNumberValidated = FALSE;
    NSNumber *minLength = [self.cardLengthData objectForKey:@"cardMinLength"];

   
    if(cardNumberString.length>=[minLength integerValue]){
        if([Luhn validateString:cardNumberString]){
            cardNumberValidated = TRUE;
            [self.cardNumberTextField setTextColor:[UIColor whiteColor]];
            
            UIView *tickImage = [self.cardScrollView viewWithTag:6862];
            if (tickImage == nil) {
                if(self.cardNumberValidTick){
                    [self.cardNumberValidTick removeFromSuperview];
                    self.cardNumberValidTick = nil;
                }
                
                self.cardNumberValidTick = [[UIImageView alloc] initWithFrame:CGRectMake(self.cardBackgroundImage.frame.size.width - 90, self.cardNumberTextField.frame.origin.y + (self.cardNumberTextField.frame.size.height/2-20) , 40, 40)];
                [self.cardNumberValidTick setBackgroundColor:[UIColor clearColor]];
                [self.cardNumberValidTick setImage:[UIImage imageNamed:@"CardTick"]];
                [self.cardBackgroundImage addSubview:self.cardNumberValidTick];
            }
            
        }else{
            cardNumberValidated = FALSE;
//            [self.cardNumberTextField setTextColor:[UIColor redColor]];
//            if(self.cardNumberValidTick){
//                [self.cardNumberValidTick removeFromSuperview];
//                self.cardNumberValidTick = nil;
//            }
            [self addInputFieldValidTick:BankCardInputFieldCardNumber cardType:cardBrand isValid:FALSE];
            
        }
    }else{
        cardNumberValidated = FALSE;
//         [self.cardNumberTextField setTextColor:[UIColor redColor]];
//        if(self.cardNumberValidTick){
//            [self.cardNumberValidTick removeFromSuperview];
//            self.cardNumberValidTick = nil;
//        }
        [self addInputFieldValidTick:BankCardInputFieldCardNumber cardType:cardBrand isValid:FALSE];
    }
    return cardNumberValidated;
}

- (BOOL)validateCardExpiry:(NSString *)dateData{
    BOOL isDateValid = FALSE;

        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/YY"];
        
        NSString *currentDateString = [dateFormatter stringFromDate:date];
        NSArray *currentDateArray = [currentDateString componentsSeparatedByString:@"/"];
        NSArray *enteredDateArray = [dateData componentsSeparatedByString:@"/"];
        if ([enteredDateArray count]>=2) {
            
            BOOL isMonthValid = FALSE;
            BOOL isYearValid = FALSE;
            
           NSString *yearString = [[enteredDateArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSString *monthString = [[enteredDateArray objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if([yearString integerValue] >= [[currentDateArray objectAtIndex:1] integerValue]){
                isYearValid = TRUE;
               
                if([monthString integerValue] < [[currentDateArray objectAtIndex:0] integerValue] && [yearString integerValue] == [[currentDateArray objectAtIndex:1] integerValue]){
                    isMonthValid = FALSE;
                }else{
                    isMonthValid = TRUE;
                }
            }else{
                isYearValid = FALSE;
            }
            
            if (isMonthValid && isYearValid) {
                isDateValid = TRUE;
            }else{
                isDateValid = FALSE;
                [self addInputFieldValidTick:BankCardInputFieldCardExpiry cardType:cardBrand isValid:FALSE];

            }
    }
    
    return isDateValid;
}

-(BOOL)validateCardName:(NSString *)theNameString{
        NSString *stricterFilterString = @"^[a-zA-Z0-9\\\\ ]*$";
        NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
        BOOL isValidChar = [stringTest evaluateWithObject:theNameString];
    
        return isValidChar;
}

- (void)addInputFieldValidTick:(BankCardInputType)type cardType:(BankCard)bankCardType isValid:(BOOL)isValid{
    
    if(type == BankCardInputFieldCardNumber){
        if(self.cardNumberValidTick){
            [self.cardNumberValidTick removeFromSuperview];
            self.cardNumberValidTick = nil;
        }
        self.cardNumberValidTick = [[UIImageView alloc] initWithFrame:CGRectMake(self.cardBackgroundImage.frame.size.width - 90, self.cardNumberTextField.frame.origin.y + (self.cardNumberTextField.frame.size.height/2-20) , 40, 40)];
        
        [self.cardNumberValidTick setBackgroundColor:[UIColor clearColor]];
        if (isValid) {
            [self.cardNumberValidTick setImage:[UIImage imageNamed:@"CardTick"]];
        }else{
            [self.cardNumberValidTick setImage:[UIImage imageNamed:@"CardCross"]];
        }

        self.cardNumberValidTick.tag = 6862;
        [self.cardBackgroundImage addSubview:self.cardNumberValidTick];
        if (isValid) {
            numberVaidatedIntially = TRUE;
            [self.expiryTextField becomeFirstResponder];
        }
        
    }
    else if(type == BankCardInputFieldCardExpiry){
        if (!isValid) {
            if(self.cardExpiryValidTick){
                [self.cardExpiryValidTick removeFromSuperview];
                self.cardExpiryValidTick = nil;
            }
            self.cardExpiryValidTick = [[UIImageView alloc] initWithFrame:CGRectMake(self.expiryTextField.frame.origin.x +self.expiryTextField.frame.size.width+kTickMargin_X,self.expiryTextField.frame.origin.y + (self.expiryTextField.frame.size.height/2-20) , 40, 40)];
            [self.cardExpiryValidTick setBackgroundColor:[UIColor clearColor]];
            [self.cardExpiryValidTick setImage:[UIImage imageNamed:@"CardCross"]];
            
            [self.cardBackgroundImage addSubview:self.cardExpiryValidTick];
        }
        else{
            if(self.cardExpiryValidTick){
                [self.cardExpiryValidTick removeFromSuperview];
                self.cardExpiryValidTick = nil;
            }
            self.nameTextField.userInteractionEnabled = TRUE;
            [self.nameTextField becomeFirstResponder];
        }
    }
}

-(void)cardNumberFieldDidChange:(id)sender{
    
    UITextField *theCardNumberTextField = (UITextField *)sender;
    
    if (theCardNumberTextField.text.length>0) {
      NSString *theCardType = [Luhn getCardTypeForCardNumber:theCardNumberTextField.text];
        
        if ([[theCardType lowercaseString] isEqualToString:@"visa"]) {
            cardBrand = VisaBankCard;
            luhnCardType = OLCreditCardTypeVisa;
            self.cardLengthData = [cardLengthDict objectForKey:@"visa"];
            [self.cardBrandLogo setBackgroundColor:[UIColor whiteColor]];
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"VisaRect"]];
            
        }else if ([[theCardType lowercaseString] isEqualToString:@"maestro"]){
            cardBrand = MaestroBankCard;
            self.cardLengthData = [cardLengthDict objectForKey:@"maestro"];
            [self.cardBrandLogo setBackgroundColor:[UIColor whiteColor]];
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"MaestroRect"]];
            
        }else if ([[theCardType lowercaseString] isEqualToString:@"visaelectron"]){
            cardBrand = VisaElectronBankCard;
            self.cardLengthData = [cardLengthDict objectForKey:@"Visa"];
            [self.cardBrandLogo setBackgroundColor:[UIColor whiteColor]];
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"VisaRect"]];
            
        }else if ([[theCardType lowercaseString] isEqualToString:@"dinnersclub"]){
            cardBrand = DinersBankCard;
            self.cardLengthData = [cardLengthDict objectForKey:@"dinnersclub"];
            [self.cardBrandLogo setBackgroundColor:[UIColor whiteColor]];
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"DinersRect"]];
            
        }else if ([[theCardType lowercaseString] isEqualToString:@"mastercard"]){
            cardBrand = MasterBankCard;
            self.cardLengthData = [cardLengthDict objectForKey:@"mastercard"];
            [self.cardBrandLogo setBackgroundColor:[UIColor whiteColor]];
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"MasterRect"]];
            
        }else if ([[theCardType lowercaseString] isEqualToString:@"amex"]){
            cardBrand = AmexBankCard;
            luhnCardType = OLCreditCardTypeAmex;
            self.cardLengthData = [cardLengthDict objectForKey:@"amex"];
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"AmexRect"]];
            [self.cardBrandLogo setBackgroundColor:[UIColor whiteColor]];
        }else if ([[theCardType lowercaseString] isEqualToString:@"rupay"]){
            cardBrand = RupayBankCard;
            self.cardLengthData = [cardLengthDict objectForKey:@"rupay"];
            [self.cardBrandLogo setImage:[UIImage imageNamed:@"RupayRect"]];
            [self.cardBrandLogo setBackgroundColor:[UIColor whiteColor]];
        }else{
            cardBrand = UnknownBankCard;
            [self.cardBrandLogo setImage:[UIImage imageNamed:@""]];
            [self.cardBrandLogo setBackgroundColor:[UIColor clearColor]];
        }

    }

    
    NSNumber *minLength = [self.cardLengthData objectForKey:@"cardMinLength"];
    NSNumber *maxLength = [self.cardLengthData objectForKey:@"cardMaxLength"];
    if ([self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length>=[minLength integerValue]) {
        
        BOOL isExpiryDateValid = [self validateCardExpiry:self.expiryTextField.text];
        if (isExpiryDateValid && self.nameTextField.text.length>0) {
            if ([self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == [maxLength integerValue]) {
                if ([self validateCardNumberField:self.cardNumberTextField.text]) {
                    [self showBottomBarButtons];
                }else{
                    [self removeBottomBar];
                }
            }

        }
        
    }else{
        [self removeBottomBar];
    }
    
    if(cardBrand == UnknownBankCard){
        [self.expiryTextField setUserInteractionEnabled:FALSE];
        if (self.cardNumberTextField.text.length>5) {
            [self generateAcceptedCard];
        }
    }else{
        [self.expiryTextField setUserInteractionEnabled:TRUE];
    }

    
}


#pragma mark - Custom Methods
- (void)showBottomBarButtons{
    if (self.cardAcceptedView) {
        [self.cardAcceptedView removeFromSuperview];
        self.cardAcceptedView = nil;
    }
    if (self.bottomAccessoryView) {
        [self.bottomAccessoryView removeFromSuperview];
        self.bottomAccessoryView = nil;
    }
    CGFloat horizontalPoint = 5.0f;
    if (kDeviceHeight==480) {
        self.bottomAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cardScrollView.frame.size.height - (RelativeSizeHeight(230, 667)), self.frame.size.width, RelativeSizeHeight(60, 667))];
    }else{
        self.bottomAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cardScrollView.frame.size.height - (RelativeSizeHeight(222, 667)), self.frame.size.width, RelativeSizeHeight(60, 667))];
    }
    
    
    [self.bottomAccessoryView setBackgroundColor:[UIColor clearColor]];
    [self.bottomAccessoryView setUserInteractionEnabled:TRUE];
    self.bottomAccessoryView.tag = 2266;
    [self.cardScrollView addSubview:self.bottomAccessoryView];
    
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.layer.cornerRadius = 4.0f;
    [cancelButton setFrame:CGRectMake(self.cardBackgroundImage.frame.origin.x+15 , RelativeSizeHeight(horizontalPoint, 480), self.cardBackgroundImage.frame.size.width/2 - RelativeSize(xPadding/2, 320)-15, RelativeSizeHeight(50, 667))];
    [cancelButton setClipsToBounds:TRUE];
    cancelButton.layer.borderColor = UIColorFromRGB(kGenderSelectorTintColor).CGColor;
    cancelButton.layer.borderWidth = 1.0f;
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    
    if (self.isAddingCard) {
        [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        cancelButton.tag=-1;
    }else{
        [cancelButton setTitle:@"REMOVE" forState:UIControlStateNormal];
        cancelButton.tag=0;
    }

    [cancelButton addTarget:self action:@selector(cardDMLAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[SSUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorFromRGB(kGenderSelectorTintColor) forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorFromRGB(kSignUpColor) forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Regular size:14.0f];
    [self.bottomAccessoryView addSubview:cancelButton];
    
    
    //Adding Add/Save Button
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.layer.cornerRadius = 4.0f;
    [addButton setFrame:CGRectMake(cancelButton.frame.origin.x + cancelButton.frame.size.width + xPadding , cancelButton.frame.origin.y, cancelButton.frame.size.width, cancelButton.frame.size.height)];
    [addButton setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
    
    [addButton setClipsToBounds:TRUE];
    [addButton setBackgroundColor:[UIColor clearColor]];

    
    if(self.isAddingCard){
        addButton.tag=1;
        [addButton setTitle:@"ADD" forState:UIControlStateNormal];
    }else{
        [addButton setTitle:@"SAVE" forState:UIControlStateNormal];
        addButton.tag=2;
    }
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];

    addButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Regular size:14.0f];
    [addButton addTarget:self action:@selector(cardDMLAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomAccessoryView addSubview:addButton];
    if (kDeviceHeight<667)
    {
      [self animateCardScrollView:TRUE];
    }
}


- (void)cardDMLAction:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    if(button.tag==0){
        if (self.isAddingCard) {
            if([self.addCartDelegate respondsToSelector:@selector(actionPerormOnAddCard:andAddedCard:)]){
                [self.addCartDelegate actionPerormOnAddCard:102 andAddedCard:nil];
            }
        }else{
            if([self.addCartDelegate respondsToSelector:@selector(actionPerormOnAddCard:andAddedCard:)]){
                [self.addCartDelegate actionPerormOnAddCard:button.tag andAddedCard:nil];
            }
        }
    }else if(button.tag==1){
        [self addButtonActionWithTag:1];
    }
    else if(button.tag==2){
        self.selectedCard.cardName = self.nameTextField.text;
        if([self.addCartDelegate respondsToSelector:@selector(actionPerormOnAddCard:andAddedCard:)]){
            [self.addCartDelegate actionPerormOnAddCard:button.tag andAddedCard:self.selectedCard];
        }
    }
    
    else{
        if([self.addCartDelegate respondsToSelector:@selector(actionPerormOnAddCard:andAddedCard:)]){
            [self.addCartDelegate actionPerormOnAddCard:-1 andAddedCard:nil];
        }
    }
}

-(void)addButtonActionWithTag:(int)tagValue{
    BOOL isNumberValid = FALSE;
    if (!self.isAddingCard) {
        isNumberValid = TRUE;
    }else{
        isNumberValid = [self validateCardNumberField:self.cardNumberTextField.text];
    }
    BOOL isValidExpiryDate = FALSE;
    if (!self.isAddingCard) {
        isValidExpiryDate = TRUE;
    }else{
        isValidExpiryDate = [self validateCardExpiry:self.expiryTextField.text];
    }
    
    if (isNumberValid && isValidExpiryDate && self.nameTextField.text.length>=1) {
        
        NSString *expiryString = [self.expiryTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        CardModel *data = [[CardModel alloc] init];
        data.cardNumber = self.cardNumberTextField.text;
        NSArray *arr = [expiryString componentsSeparatedByString:@"/"];
        data.expiryMonth = [arr objectAtIndex:0];
        data.expiryYear = [NSString stringWithFormat:@"20%@",[arr objectAtIndex:1]];
        data.cardName = self.nameTextField.text;
        data.cardType = cardBrand;
        if([self.addCartDelegate respondsToSelector:@selector(actionPerormOnAddCard:andAddedCard:)]){
            [self.addCartDelegate actionPerormOnAddCard:tagValue andAddedCard:data];
        }
    }
}

- (void)clear{
    if(self.errorMessage){
        [self.errorMessage removeFromSuperview];
        self.errorMessage = nil;
    }
    
    if(self.cardExpiryValidTick){
        [self.cardExpiryValidTick removeFromSuperview];
        self.cardExpiryValidTick = nil;
    }
    // TODO - Remove add and cancel
    [self removeBottomBar];
}


- (void)generateAcceptedCard{

    if(self.cardAcceptedView){
        [self.cardAcceptedView removeFromSuperview];
        self.cardAcceptedView = nil;
    }
        
    [self removeBottomBar];
        if (kDeviceHeight<667) {
            self.cardAcceptedView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cardScrollView.frame.size.height - (RelativeSizeHeight(218, 667)), self.frame.size.width, RelativeSizeHeight(60, 667))];
        }else{
            self.cardAcceptedView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cardScrollView.frame.size.height - (RelativeSizeHeight(218, 667)), self.frame.size.width, RelativeSizeHeight(60, 667))];
        }
        
        [self.cardAcceptedView setUserInteractionEnabled:FALSE];
        [self.cardAcceptedView setBackgroundColor:[UIColor clearColor]];
        [self.cardScrollView addSubview:self.cardAcceptedView];
        
        CGSize size = [SSUtility getLabelDynamicSize:@"We Accept" withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
        UILabel *weAccept = [SSUtility generateLabel:@"We Accept" withRect:CGRectMake(self.cardAcceptedView.frame.size.width/2 - size.width/2,0, size.width, size.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
        [weAccept setBackgroundColor:[UIColor clearColor]];
        [weAccept setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
        [self.cardAcceptedView addSubview:weAccept];
      
        NSInteger totalCards = 6;
        CGFloat newOriginCard = self.cardAcceptedView.frame.size.width - (totalCards * RelativeSize(kAcceptedCardWidth, 375)) - ((totalCards-1)*xPadding);

        NSInteger startPoint = newOriginCard/2;
        NSInteger cardY = weAccept.frame.origin.y + weAccept.frame.size.height + RelativeSizeHeight(8, 667);
        
        if (kDeviceHeight<500) {
            cardY = 2;
            [weAccept setHidden:TRUE];
        }else{
            cardY = weAccept.frame.origin.y + weAccept.frame.size.height + RelativeSizeHeight(8, 667);
        }
        
        for(NSInteger counter =0; counter < totalCards; counter++){
            NSString *cardImageName = nil;
            if(counter ==0){
                cardImageName = @"VisaRect";
            }else if(counter ==1){
                cardImageName = @"MasterRect";
            }else if(counter ==2){
                cardImageName = @"AmexRect";
            }else if(counter ==3){
                cardImageName = @"MaestroRect";
            }else if(counter ==4){
                cardImageName = @"DinersRect";
            }else if(counter ==5){
                cardImageName = @"RupayRect";
            }
            
            UIImageView *cardImage = [[UIImageView alloc] initWithFrame:CGRectMake(startPoint, cardY, RelativeSize(kAcceptedCardWidth, 375),RelativeSize(kAcceptedCardHeight, 375))];
            [cardImage setBackgroundColor:[UIColor whiteColor]];
            [cardImage.layer setCornerRadius:3.0];
            [cardImage setClipsToBounds:TRUE];
            [cardImage setImage:[UIImage imageNamed:cardImageName]];
            [self.cardAcceptedView addSubview:cardImage];
            startPoint += cardImage.frame.size.width + xPadding;
    }
    if (kDeviceHeight<667) {
        [self animateCardScrollView:TRUE];
    }
}


-(void)animateCardScrollView:(BOOL)isUp{

    NSInteger yValue = 0;
    if(isUp){
        isCardContainerUp = TRUE;
        [self.bottomAccessoryView setHidden:FALSE];
        [self.cardAcceptedView setHidden:FALSE];
        yValue = RelativeSizeHeight(45, 667);
        
        if(kDeviceHeight == 568){
            yValue = RelativeSizeHeight(60, 667);
            [self.cardScrollView setContentSize:CGSizeMake(self.cardScrollView.frame.size.width, self.cardScrollView.frame.size.height + RelativeSize(120, 667))];
            [self.cardScrollView setScrollEnabled:YES];
            
        }else if(kDeviceHeight == 480){
            yValue = RelativeSizeHeight(90, 667);
            [self.cardScrollView setContentSize:CGSizeMake(self.cardScrollView.frame.size.width, self.cardScrollView.frame.size.height + RelativeSize(150, 667))];
            [self.cardScrollView setScrollEnabled:YES];
        }
        
    }
    else{
        isCardContainerUp = FALSE;
        [self.bottomAccessoryView setHidden:TRUE];
        [self.cardAcceptedView setHidden:TRUE];
        yValue = 0;
        [self.cardScrollView setScrollEnabled:false];

    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.cardScrollView setContentOffset:CGPointMake(self.cardScrollView.frame.origin.x,yValue)];
    
    [UIView commitAnimations];
}

-(void)hideKeyboard{
    if([self.nameTextField isFirstResponder]){
        [self.nameTextField resignFirstResponder];
    }
    
    if([self.expiryTextField isFirstResponder]){
        [self.expiryTextField resignFirstResponder];
    }
    
    if([self.cardNumberTextField isFirstResponder]){
        [self.cardNumberTextField resignFirstResponder];
    }
    [self animateCardScrollView:NO];
    
    if([self.bottomAccessoryView isHidden]){
        [self.bottomAccessoryView setHidden:FALSE];
    }

}

-(void)removeBottomBar{
    [self animateCardScrollView:FALSE];
    if (self.bottomAccessoryView) {
        [self.bottomAccessoryView removeFromSuperview];
        self.bottomAccessoryView = nil;
    }

}


-(void)checkCardNameFieldAndShowButtons{
    if (self.nameTextField.text.length == 0) {
        [self removeBottomBar];
    }else if (self.nameTextField.text.length>0){
        NSString *cardNumberString= [self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        BOOL isNumberValid = [self validateCardNumberField:cardNumberString];
        if (isNumberValid) {
            [self showBottomBarButtons];
        }else{
            [self removeBottomBar];
        }

    }
    if (self.isAddingCard) {
        //Check if Number is Valid or not
        NSString *cardNumberString= [self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self validateCardNumberField:cardNumberString];
    }else{
        [self.cardNumberTextField setUserInteractionEnabled:FALSE];
    }

}

-(void)populateFormattedNumberWithString:(NSString *)cardNumber{

    cardNumber = [cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
     NSString *endingNumbers = [cardNumber substringFromIndex:MAX((int)[cardNumber length]-4,0)];
    NSString *initialNumbers = [cardNumber substringWithRange:NSMakeRange(0, 4)];
    
    NSMutableAttributedString * paymentDetailString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ •••• •••• %@",initialNumbers, endingNumbers] attributes:@{NSFontAttributeName : kCardNumberFont}];

    [paymentDetailString setAttributes:@{NSFontAttributeName :[UIFont fontWithName:kMontserrat_Regular size:22], NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(5, 9)];
    self.cardNumberTextField.textColor = [UIColor whiteColor];
    [self.cardNumberTextField setAttributedText:paymentDetailString];
}

@end



