//
//  PDPSizeGuideViewController.m
//  Explore
//
//  Created by Pranav on 28/09/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "PDPSizeGuideViewController.h"

@interface PDPSizeGuideViewController ()

@property(nonatomic,strong) UIImageView *sizeGuideImageView;
@end

@implementation PDPSizeGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"Size Guide";
    self.sizeGuideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-1, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.sizeGuideImageView setBackgroundColor:[UIColor clearColor]];
    [self.sizeGuideImageView setImage:[UIImage imageNamed:@"sizeGuide"]];
    [self.view addSubview:self.sizeGuideImageView];
    [self setBackButton];

}


-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}


-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = TRUE;
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
}

- (void)viewWillDisappear:(BOOL)animated{
[self.navigationController.navigationBar changeNavigationBarToTransparent:TRUE];
    self.tabBarController.tabBar.hidden = FALSE;
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
