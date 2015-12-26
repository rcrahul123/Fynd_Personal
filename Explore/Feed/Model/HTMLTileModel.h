//
//  HTMLTileModel.h
//  Explore
//
//  Created by Rahul Chaudhari on 09/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLTileModel : NSObject

@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, assign) BOOL isPageLoaded;
@property (nonatomic, assign) BOOL toBeRemoved;

@end
