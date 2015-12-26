//
//  EditProfileView.h
//  Explore
//
//  Created by Pranav on 11/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OpenGallery)();
typedef void (^SendOTPScreen)(NSDictionary * dict);
typedef void (^CancelEditProfile)();
typedef void (^UpdateImage)(NSString *picUrl);
typedef void (^ProfileUpdateBlock)(BOOL imageUpdated,NSString *imageUrl);
typedef void (^ChangePassword)();

@interface EditProfileView : UIView{
    NSURLSessionConfiguration *config;
    NSURLCache *cache;
    
    FyndActivityIndicator *editProfileLoader;
}

- (void)configureEditProfile;
@property (nonatomic,copy)  OpenGallery     galleryBlock;
@property (nonatomic,copy)  SendOTPScreen   sendOTPBlock;
@property (nonatomic,copy)  CancelEditProfile   cancelEditProfileBlock;
@property (nonatomic,copy)  UpdateImage         updateUserImage;
@property (nonatomic,copy)  ProfileUpdateBlock  profileUpdateBlock;
@property (nonatomic,copy) ChangePassword   changePasswordBlock;
- (void)updateProfileImage:(UIImage *)image;
- (void)updateCaptureImage:(UIImage *)image;
-(void) keyboardShow: (NSNotification *)notif;
-(void) keyboardHide: (NSNotification *)notif;
@end
