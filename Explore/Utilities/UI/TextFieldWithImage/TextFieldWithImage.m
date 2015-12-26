//
//  TextFieldWithImage.m
//  Explore
//
//  Created by Amboj Goyal on 8/12/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "TextFieldWithImage.h"
#import <objc/runtime.h>

@interface TextFieldWithImage(){
    UIImage *onErrorImage;
    UIImage *selectedImage;
    UIImage *unselectedImage;
    UIImageView *leftImageView;
//    UILabel *errorMessageLabel;
    UIImageView *rightImageView;
    NSString * passwordImage;
    CALayer *bottomBorder;
    UIView *viewForRightImage;

}
@property (nonatomic,strong)    UITapGestureRecognizer *eyeTapGesture;
@property (nonatomic,assign)    BOOL shouldShowPassword;

@end

@implementation TextFieldWithImage
@synthesize bottomBorder;

//static char defaultHashKey;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        [self initialize];
    }
    return self;
}




-(id)initWithFrame:(CGRect)frame withErrorImage:(NSString *)onErrorImageName andSelectedImage:(NSString *)selectedImageName andUnSelectedImage:(NSString *)unselectedImageName{
    
    self = [super initWithFrame:frame];
    
    if(self){
        [self initialize];
        self.onErrorImageName = onErrorImageName;
        self.selectedImageName = selectedImageName;
        self.unselectedImageName = unselectedImageName;
    }
    return self;
}


-(void)initialize{
    self.theTextField = [[UITextField alloc] init];
    self.theTextField.delegate = self;
    [self addSubview:self.theTextField];
    
    self.errorMessageLabel = [[UILabel alloc] init];
    [self addSubview:self.errorMessageLabel];
    
    leftImageView = [[UIImageView alloc] init];
    
    self.bottomBorder = [CALayer layer];
    [self.layer addSublayer:self.bottomBorder];
    
    self.isValid = TRUE;
    
    tapGesture = [[UITapGestureRecognizer alloc] init];
}


-(void)layoutSubviews{
    [tapGesture addTarget:self.theTextField action:@selector(becomeFirstResponder)];
    [self addGestureRecognizer:tapGesture];
    [self.theTextField setFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    self.theTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.theTextField.font = [UIFont fontWithName:kMontserrat_Light size:15.0];
    [leftImageView setFrame:CGRectMake(0, self.theTextField.frame.size.height - 12, 32, 32)];
    
    if(self.textFieldType == TextFieldTypeEmail){
        self.theTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }

    [self.errorMessageLabel setFrame:CGRectMake(0, self.theTextField.frame.size.height + 8 + 8, self.frame.size.width, 14)];
    if(self.textFieldType == TextFieldTypeCoupon)
        [self.errorMessageLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
   else{
        [self.errorMessageLabel setFont:[UIFont fontWithName:kMontserrat_Light size:11.0f]];
    }


    [self.errorMessageLabel setTextColor:UIColorFromRGB(kRedColor)];
    [self.errorMessageLabel setBackgroundColor:[UIColor clearColor]];
    
    onErrorImage = [UIImage imageNamed:self.onErrorImageName];
    selectedImage = [UIImage imageNamed:self.selectedImageName];
    unselectedImage = [UIImage imageNamed:self.unselectedImageName];
    
    if (self.onErrorImageName == nil && self.unselectedImageName == nil && self.selectedImageName == nil) {
        self.theTextField.leftViewMode = UITextFieldViewModeNever;
    }else{
        self.theTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    [self updateLeftImage];
    [self setBottomBorder];
    //        [self updateRightImage];
    [self setBackgroundColor:[UIColor clearColor]];

    [self.theTextField setBackgroundColor:[UIColor clearColor]];
    
    if(self.textFieldType == TextFieldTypeMobile){
        if(self.theTextField.text.length <= 0){
            self.theTextField.text = @"+91 ";
            self.theTextField.keyboardAppearance = UIKeyboardAppearanceDark;
        }
    }
    
    if (self.textFieldType == TextFieldTypeUserName || self.textFieldType == TextFieldTypeAddress) {
        self.theTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    
    if(self.textFieldType == TextfielTypeOTP || self.textFieldType == TextFieldTypePinCode){
            self.theTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    }
}



- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    return CGRectMake(0, self.theTextField.frame.size.height/2 - 16, 32, 32);
}


-(void)updateLeftImage{
    
    if(!self.isValid && ![self.theTextField isFirstResponder]){
        if(onErrorImage){
            [leftImageView setImage:onErrorImage];
        }else{
            [leftImageView setImage:unselectedImage];
        }
    }else{
        if(self.textFieldType == TextFieldTypeMobile){
            if(self.theTextField.text.length == 4 || self.theTextField.text == nil || [self.theTextField isFirstResponder] || [self.theTextField.text isEqualToString:@""]){
                [leftImageView setImage:unselectedImage];
                
            }else{
                [leftImageView setImage:selectedImage];
            }
        }else{
            if(self.theTextField.text.length == 0 || self.theTextField.text == nil || [self.theTextField isFirstResponder]){
                [leftImageView setImage:unselectedImage];
                
            }else{
                [leftImageView setImage:selectedImage];
            }
        }
    }
    self.theTextField.leftView = leftImageView;
}

-(void)setBottomBorder{
//    CALayer *bottomBorder = [CALayer layer];
    self.bottomBorder.frame = CGRectMake(0.0f, self.theTextField.frame.size.height + 8, self.frame.size.width, 1.0f);
    self.bottomBorder.backgroundColor = UIColorFromRGB(KTextFieldBorderColor).CGColor;
//    [bottomBorder setOpacity:0.8];
}

- (void) drawRect:(CGRect)rect{
    if ([self.theTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        if(self.theTextField.placeholder && self.theTextField.placeholder.length >0){
            self.theTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.theTextField.placeholder attributes:@{
                            NSForegroundColorAttributeName : UIColorFromRGB(kLightGreyColor),
                            NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0],
                            }];
        }
    }}

-(void)updateRightImageFor:(UITextField *)theTextField withImage:(NSString *)imagename{
        rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 32, 32)];
        rightImageView.image = [UIImage imageNamed:imagename];
        passwordImage = imagename;
    
        viewForRightImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [viewForRightImage setUserInteractionEnabled:TRUE];

    [viewForRightImage addSubview:rightImageView];
    
        theTextField.rightView = viewForRightImage;
        theTextField.rightViewMode = UITextFieldViewModeAlways;
        self.eyeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSecureText:)];
        [viewForRightImage addGestureRecognizer:self.eyeTapGesture];
        [theTextField.rightView setUserInteractionEnabled:TRUE];
}

-(void)handleSecureText:(id)sender{
    UITextField *theTextFiled = (UITextField *)[sender view].superview;
    theTextFiled.font = [UIFont fontWithName:kMontserrat_Light size:16.0];
    if (theTextFiled.text != nil && theTextFiled.text.length >0) {
        theTextFiled.secureTextEntry = !theTextFiled.secureTextEntry;
        if (theTextFiled.secureTextEntry) {
            rightImageView.image = [UIImage imageNamed:passwordImage];
            theTextFiled.font = [UIFont fontWithName:kMontserrat_Light size:16.0];
        }else{
            rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Selected",passwordImage]];
            theTextFiled.font = [UIFont fontWithName:kMontserrat_Light size:16.0];
        }
        NSString * tmpString = theTextFiled.text;
        theTextFiled.text = @" ";
        theTextFiled.text = tmpString;
    }
}



-(BOOL)validate{
    if(self.textFieldType == TextFieldTypeFirstName || self.textFieldType == TextFieldTypeLastName || self.textFieldType == TextFieldTypeUserName){
        self.isValid = [self isNameValid];
        
    }else if (self.textFieldType == TextFieldTypeMobile){
        self.isValid = [self isMobileValid];
        
    }else if (self.textFieldType == TextFieldTypeEmail){
        self.isValid = [self isEmailValid];
        
    }else if (self.textFieldType == TextFieldTypePassword){
        self.isValid = [self isPasswordValid];
        
    }else if (self.textFieldType == TextfielTypeOTP){
        self.isValid = [self isOTPValid];
        
    }else if (self.textFieldType == TextFieldTypeAddress){
        self.isValid = [self isAddressValid];
    }
    else if(self.textFieldType == TextFieldTypePinCode){
        self.isValid = [self isPinCodeValid];
    }
    
    if(!self.isValid){
        self.errorMessageLabel.text = self.theMessage;
    }else
        self.errorMessageLabel.text = @"";
    
    return self.isValid;
}


-(BOOL)isNameValid{
    BOOL valid = false;
    NSString *textToValidate = self.theTextField.text;
    [textToValidate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(textToValidate.length == 0){
        if(self.textFieldType == TextFieldTypeFirstName){
         self.theMessage = @"Enter first name";
        }else if(self.textFieldType == TextFieldTypeLastName){
            self.theMessage = @"Enter last name";
        }else if(self.textFieldType == TextFieldTypeUserName) {
            self.theMessage = @"Enter name";
        }
        
    }else{
        if (self.textFieldType == TextFieldTypeUserName) {
            NSString *nameRegex = @"[a-zA-Z. ]+";
            NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
            valid = [test evaluateWithObject:textToValidate];
            if (!valid) {
                self.theMessage = @"Only letters allowed";
            }
        }else{
            NSString *nameRegex = @"[a-zA-Z.]+";
            NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
            valid = [test evaluateWithObject:textToValidate];
            if(!valid){
                if(self.textFieldType == TextFieldTypeFirstName){
                    self.theMessage = @"Only letters allowed";
                    
                }else if(self.textFieldType == TextFieldTypeLastName){
                    self.theMessage = @"Only letters allowed";
                }
            }
        }
    }
    return valid;
}


-(BOOL)isMobileValid{
    BOOL valid = false;
    NSString *textToValidate = [[self.theTextField.text componentsSeparatedByString:@" "] lastObject];
    
    [textToValidate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *phoneRegex = @"[1-9]{1}[0-9]{9}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    valid = [test evaluateWithObject:textToValidate];
    
    if(textToValidate.length >= 10 && valid){
        valid = TRUE;
//        self.theMessage = @"";
    }else if (textToValidate.length ==0){
        self.theMessage = @"Enter mobile number";
        valid = false;
    }
    else{
        self.theMessage = @"Invalid mobile number";
        valid = false;
    }
    return valid;
}


-(BOOL)isEmailValid{
    BOOL valid = false;
    NSString *textToValidate = self.theTextField.text;
    [textToValidate stringByReplacingOccurrencesOfString:@" " withString:@""];
 
    NSString *regex = @"[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if(textToValidate.length ==0){
        self.theMessage = @"Enter email";
        valid = false;

    }else if([emailPredicate evaluateWithObject:textToValidate]){
        valid = TRUE;
//        self.theMessage = @"";
    }else{
            self.theMessage = @"Invalid email";
        valid = false;
    }
    return valid;
}


-(BOOL)isPasswordValid{
    BOOL valid = false;
    NSString *textToValidate = self.theTextField.text;
    [textToValidate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(textToValidate.length ==0){
        self.theMessage = @"Enter password";
        valid = false;
        
    }else if(textToValidate.length >= 6){
        valid = TRUE;
//        self.theMessage = @"";
    }else{
            self.theMessage = @"Minimum 6 characters";
        valid = false;
    }
    return valid;
}


-(BOOL)isOTPValid{
    BOOL valid = false;
    NSString *textToValidate = self.theTextField.text;
    [textToValidate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
//    NSString *phoneRegex = @"[1-9]{1}[0-9]{5}";
    NSString *phoneRegex = @"[1-9]{1}[0-9]*";

    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    valid = [test evaluateWithObject:textToValidate];
    
    if(textToValidate.length ==0){
        self.theMessage = @"Enter OTP";
        valid = false;
        
    }else if(valid){
//        self.theMessage = @"";
        valid = TRUE;
        
    }else{
            self.theMessage = @"Incorrect OTP";
        
        valid = false;
    }
    return valid;
}


-(BOOL)isPinCodeValid{
    BOOL valid = false;
    NSString *textToValidate = self.theTextField.text;
    [textToValidate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(textToValidate.length ==0){
        self.theMessage = @"Enter pincode";
        valid = false;
        
    }else if(textToValidate.length > 0){
        //        self.theMessage = @"";
        valid = TRUE;
        
    }else{
        if(!self.theMessage){
            self.theMessage = @"Pincode should be 6 characters long";
        }
        valid = false;
    }
    return valid;
}



-(BOOL)isAddressValid{
    BOOL valid = FALSE;
    NSString *textToValidate = self.theTextField.text;
    [textToValidate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(textToValidate.length ==0){
        self.theMessage = @"Enter address";
        valid = false;
        
    }else if(textToValidate.length > 0){
        valid = TRUE;
        
    }else{
        valid = false;
    }

    return valid;
}


#pragma mark - TextField Delegate 

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
        
    if(self.updateBlock){
        self.updateBlock(textField);
    }
    if (self.textFieldType == TextFieldTypeCoupon){
        if(self.couponStatusBlock){
            self.couponStatusBlock(textField);
        }
    }
    if (self.textFieldType == TextFieldTypePinCode) {
        return NO;
    }else
        return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.errorMessageLabel.text = @"";
    
    if (self.isreturnTypeDone) {
        [textField setReturnKeyType:UIReturnKeyDone];
    }else
    [textField setReturnKeyType:UIReturnKeyNext];
    [self updateLeftImage];
    
    self.currentTxtField = textField;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self validate];
    [self updateLeftImage];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self updateLeftImage];
    self.errorMessageLabel.text = @"";
    
    if(self.textFieldType == TextFieldTypeMobile){
        NSString *mobileNumberString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(mobileNumberString.length == 14){
            self.isValid = true;
            [leftImageView setImage:selectedImage];
        }
        
        if(mobileNumberString.length <= 3 || mobileNumberString.length > 14)
            return NO;
        
    }else if (self.textFieldType == TextfielTypeOTP){
        NSString *mobileNumberString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(mobileNumberString.length == 6){
            self.isValid = true;
            [leftImageView setImage:selectedImage];
        }
    }
    else if (self.textFieldType == TextFieldTypeCoupon){
//        self.theTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        
        NSRange lowercaseCharRange;
        lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
        
        if (lowercaseCharRange.location != NSNotFound) {
            
            textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                     withString:[string uppercaseString]];
            return NO;
        }
        
         NSString *couponString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(self.updateBlock1){
            self.updateBlock1(couponString);
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self updateLeftImage];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UITextField *next = textField.nextTextField;
    if (next) {
        [next becomeFirstResponder];
    }else if (self.isreturnTypeDone == TRUE && textField.returnKeyType == UIReturnKeyDone){
        [textField resignFirstResponder];
        if (self.callBackBlock) {
            self.callBackBlock();
        }
    }
    else {
        [textField resignFirstResponder];
        [(TextFieldWithImage *)textField.superview updateLeftImage];
    }
    
    [self updateLeftImage];
    return YES;
}

- (UITextField *)currentTextField{
    [self textFieldDidBeginEditing:self.theTextField];
    return self.currentTxtField;
}

- (void)showErroMessage:(NSString *)errorMessage{
    if(errorMessage && errorMessage.length >0){
        self.errorMessageLabel.text = errorMessage;
        
    }
}


@end
