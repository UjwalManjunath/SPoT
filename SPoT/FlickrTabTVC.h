//
//  FlickrTabTVC.h
//  SPoT
//
//  Created by Ujwal Manjunath on 3/4/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrTabTVC : UITableViewController
@property(nonatomic,strong) NSArray *photos ;
@property(nonatomic,strong) NSArray *tags ;
@property(nonatomic) NSUInteger picCount;

-(NSString *)removeUnwantedTags:(NSString *)tagName;

@end
