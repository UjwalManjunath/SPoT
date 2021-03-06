//
//  StandardFlickrPhotoTVC.m
//  SPoT
//
//  Created by Ujwal Manjunath on 3/5/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "StandardFlickrPhotoTVC.h"
#import "FlickrFetcher.h"
@interface StandardFlickrPhotoTVC ()

@end

@implementation StandardFlickrPhotoTVC

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
	// Do any additional setup after loading the view.
}

-(NSString *)cellIdentifier
{
    return @"Images";
}
-(NSString *)segueIdentifier
{
    return @"showImage";
}

-(void) sortList:(NSArray *)photos
{
    NSSortDescriptor *photoNameDescriptor = [[NSSortDescriptor alloc]initWithKey:@"title" ascending:YES];
    NSArray *arrayOfNameDescriptor = @[photoNameDescriptor];
    NSArray *sortedPhotos = [photos sortedArrayUsingDescriptors:arrayOfNameDescriptor];
    
    self.Photos = sortedPhotos;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
