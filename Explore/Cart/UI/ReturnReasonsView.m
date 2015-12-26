//
//  ReturnReasonsView.m
//  Explore
//
//  Created by Amboj Goyal on 9/21/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ReturnReasonsView.h"


@implementation ReturnReasonsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.layer setCornerRadius:3.0f];
        [self setClipsToBounds:TRUE];
    }
    return self;
}

-(void)configureWithData:(NSArray *)theData{
    
    if (self.reasonsOptions) {
        [self.reasonsOptions removeAllObjects];
        self.reasonsOptions = nil;
    }
    self.reasonsOptions = [[NSMutableArray alloc] init];
    [self.reasonsOptions addObjectsFromArray:theData];
    self.selectedOptions = [[NSMutableArray alloc] init];
    [self createTableView];
    self.bottomButtonsBar = [self generateReasonView];
//        [self registerForKeyboardNotifications];
}
-(void)createTableView{

    returnReasonTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 45*5) style:UITableViewStylePlain];
//    returnReasonTableView.layer.cornerRadius = 5.0f;
    returnReasonTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [returnReasonTableView setBackgroundColor:[UIColor whiteColor]];
    [returnReasonTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    returnReasonTableView.dataSource = self;
    returnReasonTableView.delegate = self;
    [returnReasonTableView setShowsVerticalScrollIndicator:FALSE];
    [self addSubview:returnReasonTableView];

}

//-(UIView *)generateTextViewWithFrame:(CGRect)theFrame{
//    UITextView *textView = [[UITextView alloc] initWithFrame:theFrame];
//    textView.delegate = self;
//    textView.editable = YES;
//    [textView.layer setCornerRadius:3.0f];
//    textView.layer.borderWidth = 1.0f;
//    textView.layer.borderColor = UIColorFromRGB(kDarkPurpleColor).CGColor;
//    [textView setTextColor:UIColorFromRGB(kLightGreyColor)];
//    [textView setText:@"Write Reason"];
//    
//    return textView;
//}
//
- (UIView *)generateReasonView{

    UIView *viewFeedBack = [[UIView alloc] initWithFrame:CGRectMake(returnReasonTableView.frame.origin.x, returnReasonTableView.frame.origin.y +returnReasonTableView.frame.size.height+20, returnReasonTableView.frame.size.width, 50)];
    viewFeedBack.layer.cornerRadius = 5.0f;
    [viewFeedBack setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat buttonWidth = (viewFeedBack.frame.size.width - (2*(RelativeSize(8, 320)) - 10))/2-10;
    UIButton  *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.layer.cornerRadius = 3.0f;
    [cancelButton setFrame:CGRectMake(RelativeSize(8, 320), 5, buttonWidth, 50)];
    [cancelButton setClipsToBounds:YES];
    [cancelButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xD3D3D3)] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kBackgroundGreyColor)] forState:UIControlStateHighlighted];
    [cancelButton setTitleColor:UIColorFromRGB(kDarkPurpleColor) forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    [viewFeedBack addSubview:cancelButton];
    
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.layer.cornerRadius = 3.0f;
    [submit setClipsToBounds:TRUE];
    [submit setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [submit setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    
    [submit setFrame:CGRectMake(cancelButton.frame.origin.x + cancelButton.frame.size.width+(RelativeSize(8, 320)), cancelButton.frame.origin.y, cancelButton.frame.size.width, cancelButton.frame.size.height)];
    
    [submit setTitle:@"RETURN" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont fontWithName:kMontserrat_Regular size:14.0f];
    [submit addTarget:self action:@selector(submitReasons:) forControlEvents:UIControlEventTouchUpInside];
    [viewFeedBack addSubview:submit];
    
    [self addSubview:viewFeedBack];
    return viewFeedBack;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight =0.0f;
//    if([self.reasonsOptions count] == indexPath.row)
//        rowHeight = RelativeSizeHeight(150, 667);
//    else
        rowHeight = 45;//RelativeSizeHeight(60, 667);

    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
    [addressImageView setImage:[UIImage imageNamed:@"Return"]];
    [headerView addSubview:addressImageView];
    
    UILabel *addressList = [[UILabel alloc] initWithFrame:CGRectMake(addressImageView.frame.origin.x + addressImageView.frame.size.width+5, 0, 200, 45)];
    [addressList setText:@"Return Reason"];
    [addressList setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f]];
    [addressList setTextColor:UIColorFromRGB(kSignUpColor)];
    [headerView addSubview:addressList];

    SSLine *seperatorLine  = [[SSLine alloc] initWithFrame:CGRectMake(0, 44, tableView.frame.size.width, 1)];
    [headerView addSubview:seperatorLine];
    
    return headerView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return 1;
    return [self.reasonsOptions count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ReturnReasonsCell";
//    static NSString *cellIdentifier_TextView = @"ReturnReasonsTextViewCell";
    ReturnReasonsTableViewCell *feedBackCell =  (ReturnReasonsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(feedBackCell == nil){
            feedBackCell = [[ReturnReasonsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, feedBackCell.frame.size.width, 45)];
        }
        feedBackCell.theReturnModel = [self.reasonsOptions objectAtIndex:indexPath.row];
        feedBackCell.returnReasonsCellDelegate = self;
        feedBackCell.tag = indexPath.row;
        if (indexPath.row < [self.reasonsOptions count]-1) {
            SSLine *seperatorLine  = [[SSLine alloc] initWithFrame:CGRectMake(10, 44, tableView.frame.size.width-20, 1)];//58
            [feedBackCell.contentView addSubview:seperatorLine];
        }

        return feedBackCell;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    [self returnReasonSettingChange:indexPath.row];
}

- (void)returnReasonSettingChange:(NSInteger)cellTag{
    for(NSInteger counter=0; counter < [self.reasonsOptions count]; counter++){
        
        ReturnReasons *currentDict = [self.reasonsOptions objectAtIndex:counter];
        if(counter == cellTag){
            currentDict.isReason_Selected = !currentDict.isReason_Selected;

        
        if (currentDict.isReason_Selected) {
             [self.selectedOptions addObject:currentDict];
        }else{
            if ([self.selectedOptions containsObject:currentDict]) {
                [self.selectedOptions removeObject:currentDict];
            }
        }
        }

    }
    
    [returnReasonTableView reloadData];
}

//
//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    textView.text = @"";
//    [self animateView:TRUE];
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    BOOL aBool = TRUE;
//    
//    if([text isEqualToString:@"\n"]){
//        [self animateView:FALSE];
//        aBool = FALSE;
//        [textView resignFirstResponder];
//    }
//    return aBool;
//}
//
//- (void)animateView:(BOOL)aBool{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5f];
//    CGFloat offsetValue = RelativeSizeHeight(150, 667);//175
//    if(aBool){
//        
//       [returnReasonTableView setContentOffset:CGPointMake(0, offsetValue)];
//        if (kDeviceHeight>480) {
//         [self.bottomButtonsBar setFrame:CGRectMake(self.bottomButtonsBar.frame.origin.x, self.bottomButtonsBar.frame.origin.y - offsetValue, self.bottomButtonsBar.frame.size.width, self.bottomButtonsBar.frame.size.height)];
//        }
//        CGRect tableHeight = returnReasonTableView.frame;
//        tableHeight.size.height = tableHeight.size.height - offsetValue+40;
//        returnReasonTableView.frame = tableHeight;
//    }
//    else{
//       [returnReasonTableView setContentOffset:CGPointMake(0, 0)];
//        if (kDeviceHeight>480) {
//        [self.bottomButtonsBar setFrame:CGRectMake(self.bottomButtonsBar.frame.origin.x, self.bottomButtonsBar.frame.origin.y + offsetValue, self.bottomButtonsBar.frame.size.width, self.bottomButtonsBar.frame.size.height)];
//        }
//        CGRect tableHeight = returnReasonTableView.frame;
//        tableHeight.size.height = tableHeight.size.height + offsetValue-40;
//        returnReasonTableView.frame = tableHeight;
//    }
//    [UIView commitAnimations];
//}
//

-(void)submitReasons:(id)sender{
    if (self.theSaveButton) {
        self.theSaveButton(self.selectedOptions);
    }
}

-(void)cancelTapped{
    if (self.theCancelButton) {
        self.theCancelButton();
    }
}

@end
