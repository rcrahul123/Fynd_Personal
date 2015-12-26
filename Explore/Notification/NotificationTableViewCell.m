//
//  NotificationTableViewCell.m
//  Explore
//
//  Created by Rahul Chaudhari on 15/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
     
        self.containerView = [[UIView alloc] init];
        [self addSubview:self.containerView];
        
        
        self.offerView = [[OffersView alloc] init];
        [self.containerView addSubview:self.offerView];
    }
    return self;
}


-(id)init{
    self = [super init];
    if(self){
        
        self.containerView = [[UIView alloc] init];
        [self addSubview:self.containerView];
        
        
        self.offerView = [[OffersView alloc] init];
        [self.containerView addSubview:self.offerView];
    }
    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.containerView = [[UIView alloc] init];
        [self addSubview:self.containerView];
        
        
        self.offerView = [[OffersView alloc] init];
        [self.containerView addSubview:self.offerView];
    }
    return self;
}

-(void)prepareForReuse{
    [self.offerView setFrame:CGRectZero];
    [self.containerView setFrame:CGRectZero];
    self.model = nil;
}


-(void)layoutSubviews{
//    [super layoutSubviews];
    
    [self.containerView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - RelativeSize(8, 320))];
    [self.containerView setBackgroundColor:[UIColor whiteColor]];
    self.containerView.layer.shadowColor = UIColorFromRGB(kShadowColor).CGColor;
    [self.containerView.layer setShadowOpacity:0.1];
    [self.containerView.layer setShadowOffset:CGSizeMake(0.0, 1.0)];

    
    self.offerView.subTileModel = self.model;
    [self.offerView setFrame:CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
