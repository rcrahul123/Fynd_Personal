//
//  TextFieldWithImage.h
//  Explore
//
//  Created by Amboj Goyal on 8/12/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+NextResponder.h"

typedef void (^TextFieldCallBack)();

typedef void (^UpdateHappend)(UITextField * activeTextField);
typedef void (^TextUpdate)(NSString * string);
typedef void (^RemoveCouponStatus)(UITextField *textField);
@interface TextFieldWithImage : UIView<UITextFieldDelegate>{
    NSString *errorToBeDisplayed;
    UITapGestureRecognizer *tapGesture;
    
}
@property(nonatomic,strong)NSString *theMessage;
@property(nonatomic,strong)UITextField *theTextField;
@property (nonatomic, assign) BOOL isValid;
@property (nonatomic) TextFieldType textFieldType;
@property (nonatomic, strong) NSString *onErrorImageName;
@property (nonatomic, strong) NSString *unselectedImageName;
@property (nonatomic, strong) NSString *selectedImageName;
@property (nonatomic,assign) BOOL isreturnTypeDone;
@property (nonatomic,strong) TextFieldCallBack callBackBlock;
@property (nonatomic,strong) UITextField *currentTxtField;
@property (nonatomic,copy) UpdateHappend updateBlock;
@property (nonatomic,copy) TextUpdate updateBlock1;
@property (nonatomic,copy) RemoveCouponStatus couponStatusBlock;
@property (nonatomic,strong)    CALayer *bottomBorder;
@property (nonatomic,strong) UILabel    *errorMessageLabel;



-(id)initWithFrame:(CGRect)frame withErrorImage:(NSString *)onErrorImageName andSelectedImage:(NSString *)selectedImageName andUnSelectedImage:(NSString *)unselectedImageName;

-(void)updateLeftImage;
-(void)updateRightImageFor:(UITextField *)theTextField withImage:(NSString *)imagename;
-(BOOL)validate;

- (UITextField *)currentTextField;
- (void)showErroMessage:(NSString *)errorMessage;
@end
