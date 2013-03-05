//
//  RecentFlickrPhotoTVC.m
//  SPoT
//
//  Created by Ujwal Manjunath on 3/5/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "RecentFlickrPhotoTVC.h"

@interface RecentFlickrPhotoTVC ()

@end

@implementation RecentFlickrPhotoTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *images =[[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:@"Recentlyviewed"];
    if(images)
    {
        self.Photos = [images copy];
    }
  
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
   
    NSMutableArray *images =[[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:@"Recentlyviewed"];
    if(images)
    {
        self.Photos = [images copy];
    }
      [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)cellIdentifier
{
    return @"RecentImages";
}

-(NSString *)segueIdentifier
{
    return @"showRecentImage";
}

@end
