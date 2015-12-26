//
//  PDPFeedBackViewController.m
//  Explore
//
//  Created by Pranav on 18/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PDPFeedBackViewController.h"
#import "SSUtility.h"
#import "PDPFeedBackTableViewCell.h"
#import "TermsOfService.h"

@interface PDPFeedBackViewController ()<UITableViewDataSource,UITableViewDelegate,FeedBackCellDelegate,UITextViewDelegate>

@property (nonatomic,strong) UITableView    *feedbackTable;
@property (nonatomic,strong) NSMutableArray *feedBackOptions;
@property (nonatomic,strong) UIView         *feedBackEntryView;
- (void)generateFeedBackTable;
-(void)genetateFeedBackOptions;
//- (void)generateFeedBackEntryView;
- (UIView *)generateFeedBackEntryView;
@end

@implementation PDPFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title  = @"Return Policy";
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    
    /* // Commiting FeedBack View
    [self genetateFeedBackOptions];
    [self generateFeedBackTable];
    self.feedBackEntryView =  [self generateFeedBackEntryView];
    [self.view addSubview:self.feedBackEntryView];
     */
    [self generateTermsAndCondition];
}

- (void)generateTermsAndCondition{
    TermsOfService *termsView = [[TermsOfService alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-50)];
    [termsView setUpTermsOfServiceView];
    [self.view addSubview:termsView];
}



- (void)generateFeedBackTable{
    
    self.feedbackTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 400) style:UITableViewStylePlain];
    self.feedbackTable.layer.cornerRadius = 5.0f;
    self.feedbackTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.feedbackTable setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [self.feedbackTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.feedbackTable.dataSource = self;
    self.feedbackTable.delegate = self;
    //    self.notificationOptionsTable.contentInset = UIEdgeInsetsZero;
    
    
    [self.view addSubview:self.feedbackTable];
}

- (void)genetateFeedBackOptions{
    self.feedBackOptions = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary *recommendedDict =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Image not of good quality",@"FeedBackTitle",[NSNumber numberWithBool:FALSE],@"isSelected", nil];
    [self.feedBackOptions addObject:recommendedDict];
    NSMutableDictionary *standardDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Improper Images",@"FeedBackTitle",[NSNumber numberWithBool:FALSE],@"isSelected", nil];
    [self.feedBackOptions addObject:standardDict];
    
    //    NSMutableDictionary *neverDict = [NSMutableDictionary dictionaryWithObject:@"You will get all immediate notification and reminders about all offers and exclusive items in our app" forKey:@"Never"];
    NSMutableDictionary *neverDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Image not loading properly",@"FeedBackTitle",[NSNumber numberWithBool:FALSE],@"isSelected", nil];
    [self.feedBackOptions addObject:neverDict];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Price is too high",@"FeedBackTitle",[NSNumber numberWithBool:FALSE],@"isSelected", nil];
    [self.feedBackOptions addObject:dict4];
    
    NSMutableDictionary *dict5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Cannot pick size",@"FeedBackTitle",[NSNumber numberWithBool:FALSE],@"isSelected", nil];
    [self.feedBackOptions addObject:dict5];
}


/*
- (void)generateFeedBackEntryView{
    self.feedBackEntryView = [[UIView alloc] initWithFrame:CGRectMake(self.feedbackTable.frame.origin.x, self.feedbackTable.frame.origin.y +self.feedbackTable.frame.size.height + 10, self.feedbackTable.frame.size.width, 150)];
    self.feedBackEntryView.layer.cornerRadius = 5.0f;
    [self.feedBackEntryView setBackgroundColor:[UIColor whiteColor]];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, self.feedBackEntryView.frame.size.width-5, self.feedBackEntryView.frame.size.height-5)];
    textView.delegate = self;
    [textView setText:@"Enter FeedBack"];
    [self.feedBackEntryView addSubview:textView];
    [self.view addSubview:self.feedBackEntryView];
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, textView.frame.origin.y + textView.frame.size.height +5, self.feedBackEntryView.frame.size.width, 60)];
    [buttonsView setBackgroundColor:[UIColor whiteColor]];
    [self.feedBackEntryView addSubview:buttonsView];
    
    UIButton  *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.layer.cornerRadius = 3.0f;
    [cancelButton setFrame:CGRectMake(10, 5, buttonsView.frame.size.width/2 -20, 50)];
    [cancelButton setBackgroundColor:UIColorFromRGB(0xDADADA)];
    [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];

    [buttonsView addSubview:cancelButton];

    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.layer.cornerRadius = 3.0f;
    [submit setFrame:CGRectMake(cancelButton.frame.origin.x + cancelButton.frame.size.width+10, cancelButton.frame.origin.y, cancelButton.frame.size.width, 50)];
    
    [submit setBackgroundColor:UIColorFromRGB(0xEE365E)];
    [submit setTitle:@"Submit" forState:UIControlStateNormal];
//    [submit addTarget:self action:@selector(saveProfileData:) forControlEvents:UIControlEventTouchUpInside];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
    [buttonsView addSubview:submit];
    
}
*/

- (UIView *)generateFeedBackEntryView{
    UIView *viewFeedBack = [[UIView alloc] initWithFrame:CGRectMake(self.feedbackTable.frame.origin.x, self.feedbackTable.frame.origin.y +self.feedbackTable.frame.size.height + 10, self.feedbackTable.frame.size.width, 150)];
    viewFeedBack.layer.cornerRadius = 5.0f;
    [viewFeedBack setBackgroundColor:[UIColor whiteColor]];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, viewFeedBack.frame.size.width-5, viewFeedBack.frame.size.height-5)];
    textView.delegate = self;
    [textView setText:@"Enter FeedBack"];
    [viewFeedBack addSubview:textView];
//    [self.view addSubview:self.feedBackEntryView];
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, textView.frame.origin.y + textView.frame.size.height +5, viewFeedBack.frame.size.width, 60)];
    [buttonsView setBackgroundColor:[UIColor whiteColor]];
    [viewFeedBack addSubview:buttonsView];
    
    UIButton  *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.layer.cornerRadius = 3.0f;
    [cancelButton setFrame:CGRectMake(10, 5, buttonsView.frame.size.width/2 -20, 50)];
    [cancelButton setBackgroundColor:UIColorFromRGB(0xDADADA)];
    [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
    
    [buttonsView addSubview:cancelButton];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.layer.cornerRadius = 3.0f;
    [submit setFrame:CGRectMake(cancelButton.frame.origin.x + cancelButton.frame.size.width+10, cancelButton.frame.origin.y, cancelButton.frame.size.width, 50)];
    
    [submit setBackgroundColor:UIColorFromRGB(0xEE365E)];
    [submit setTitle:@"Submit" forState:UIControlStateNormal];
    //    [submit addTarget:self action:@selector(saveProfileData:) forControlEvents:UIControlEventTouchUpInside];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
    [buttonsView addSubview:submit];
    
    return viewFeedBack;
    
}


#pragma mark UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight =0.0f;
    if(indexPath.row == 4)
        rowHeight = 150.0f;
    else
        rowHeight = 80.0f;
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return 1;
    return 4;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FeedBackCell";
    PDPFeedBackTableViewCell *feedBackCell =  (PDPFeedBackTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [feedBackCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    if(feedBackCell == nil){
        feedBackCell = [[PDPFeedBackTableViewCell alloc] initWithFrame:CGRectMake(0, 0, feedBackCell.frame.size.width, 120) andData:[self.feedBackOptions objectAtIndex:indexPath.row]];
        feedBackCell.feedBackCellDelegate = self;
        feedBackCell.tag = indexPath.row;
    }
    return feedBackCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    [self feedBackSettingChange:indexPath.row];
}


#pragma mark UITextView Delegate Method

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self animateView:TRUE];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    BOOL aBool = TRUE;
    
    if([text isEqualToString:@"\n"]){
        [self animateView:FALSE];
        aBool = FALSE;
        [textView resignFirstResponder];
    }
    return aBool;
}

- (void)animateView:(BOOL)aBool{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    if(aBool)
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 236, self.view.frame.size.width, self.view.frame.size.height)];
    else
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 236, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

- (void)feedBackSettingChange:(NSInteger)cellTag{
    
//    UIButton *btn = (UIButton *)sender;
    
    for(NSInteger counter=0; counter < [self.feedBackOptions count]; counter++){
        
        NSMutableDictionary *currentDict = [self.feedBackOptions objectAtIndex:counter];
        if(counter == cellTag){
            [currentDict setObject:[NSNumber numberWithBool:TRUE] forKey:@"isSelected"];
            [self.feedBackOptions replaceObjectAtIndex:counter withObject:currentDict];
        }else{
            [currentDict setObject:[NSNumber numberWithBool:FALSE] forKey:@"isSelected"];
            [self.feedBackOptions replaceObjectAtIndex:counter withObject:currentDict];
        }
    }
    
    [self.feedbackTable reloadData];
}

- (void)feedBackSelected:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    for(NSInteger counter=0; counter < [self.feedBackOptions count]; counter++){
        
        NSMutableDictionary *currentDict = [self.feedBackOptions objectAtIndex:counter];
        if(counter == btn.tag){
            [currentDict setObject:[NSNumber numberWithBool:TRUE] forKey:@"isSelected"];
            [self.feedBackOptions replaceObjectAtIndex:counter withObject:currentDict];
        }else{
            [currentDict setObject:[NSNumber numberWithBool:FALSE] forKey:@"isSelected"];
            [self.feedBackOptions replaceObjectAtIndex:counter withObject:currentDict];
        }
    }
    
    [self.feedbackTable reloadData];
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
