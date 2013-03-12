//
//  StanfordFlickrTagTVC.m
//  SPoT
//
//  Created by Ujwal Manjunath on 3/4/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "StanfordFlickrTagTVC.h"
#import "FlickrFetcher.h"

@interface StanfordFlickrTagTVC ()

@end

@implementation StanfordFlickrTagTVC

-(NSArray *)getUniqueTags
{
    
    NSMutableArray *uniqueTags = [[NSMutableArray alloc]init];
    
    for (id dict in self.photos)
    {
     
        NSString *tag = [self removeUnwantedTags:dict[FLICKR_TAGS]];
        if(![uniqueTags containsObject:tag])
            [uniqueTags addObject:tag];
    }
    
    
    return [uniqueTags copy];
}


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
    [self loadLatestStandfordPhotos];
    [self.refreshControl addTarget:self action:@selector(loadLatestStandfordPhotos) forControlEvents:UIControlEventValueChanged];
   	// Do any additional setup after loading the view.
}

-(void)loadLatestStandfordPhotos
{
    [self.refreshControl beginRefreshing ];
       dispatch_queue_t tagLoaderQ= dispatch_queue_create("flicker tag loader", NULL);
    dispatch_async(tagLoaderQ, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
    self.photos = [FlickrFetcher  stanfordPhotos];
        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
        dispatch_async(dispatch_get_main_queue(), ^{
   
            self.tags = [[self getUniqueTags] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            [self.refreshControl endRefreshing];
            

        
        });
   });
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]])
    {
      //  NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        if([segue.identifier isEqualToString:@"ListImages"])
        {
            if([segue.destinationViewController respondsToSelector:@selector(setPhotos:)])
            {
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for(id dict in self.photos)
                {
                    if([[self removeUnwantedTags: dict[FLICKR_TAGS]] isEqualToString:[sender textLabel].text])
                    {
                        [arr addObject:dict];
                    }
                }
                [segue.destinationViewController performSelector:@selector(sortList:) withObject:[arr copy]];
                
                
                
               [segue.destinationViewController setTitle:[sender textLabel].text]; 
            }
            
        }
    }
}

@end
