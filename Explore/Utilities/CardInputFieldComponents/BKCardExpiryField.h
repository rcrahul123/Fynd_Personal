//
//  BKCardExpiryField.h
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 7. 6..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

#import "BKForwardingTextField.h"

@interface BKCardExpiryField : BKForwardingTextField

/**
 * Date components that user typed. Undetermined components would be zero.
 */
@property (nonatomic, strong) NSDateComponents      *dateComponents;

@end
