//
//  RetunPolicyViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 17/10/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "RetunPolicyViewController.h"

@interface RetunPolicyViewController ()

@end

@implementation RetunPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar changeNavigationBarToTransparent:NO];
    
    self.title = @"Return Policy";
    
    TermsOfService *termsView = [[TermsOfService alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 49)];
    
    [termsView setBackgroundColor:[UIColor whiteColor]];
    //http://www.obcuro-staging.gofynd.com/web/
    
    
    //    http://obscuro-staging.gofynd.com/web/faqs.html?mobile_app=true
    
    termsView.urlString = @"http://www.gofynd.com/faqs.html?mobile_app=true#returns_n_exchange";
    termsView.titleValue = @"Return Policy";

    [termsView setUpTermsOfServiceView];
    [self.view addSubview:termsView];
    
    [self setBackButton];

}

-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
