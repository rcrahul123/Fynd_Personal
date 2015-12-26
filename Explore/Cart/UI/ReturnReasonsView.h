//
//  ReturnReasonsView.h
//  Explore
//
//  Created by Amboj Goyal on 9/21/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnReasonsTableViewCell.h"

typedef void (^ReturnReasonsPopUpSave) (NSArray *reasonsArray);
typedef void (^ReturnReasonsPopUpCancel) ();
@interface ReturnReasonsView : UIView<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ReturnReasonsCellDelegate>{
    UITableView *returnReasonTableView;
    UITextView *theReasonTextView;
    
}
@property (nonatomic,strong)NSMutableArray *reasonsOptions;
@property(nonatomic,strong) UIView *bottomButtonsBar;
@property (nonatomic,strong)NSMutableArray *selectedOptions;
@property (nonatomic, strong) ReturnReasonsPopUpSave theSaveButton;
@property (nonatomic, strong) ReturnReasonsPopUpCancel theCancelButton;
-(void)configureWithData:(NSArray *)theData;
@end
