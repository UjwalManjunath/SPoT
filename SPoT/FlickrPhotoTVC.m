//
//  FlickrPhotoTVC.m
//  SPoT
//
//  Created by Ujwal Manjunath on 3/4/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"
//#import "ImageViewController.h"


@interface FlickrPhotoTVC () <UISplitViewControllerDelegate>
@end

@implementation FlickrPhotoTVC


#pragma UISplitViewController delefate

-(void)awakeFromNib
{
    self.splitViewController.delegate   = self;
}


-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Featured";
    
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    
    if([detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)])
    {
        [detailViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:barButtonItem];
    }
    
    
}


-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    
    if([detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)])
    {
        [detailViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:Nil];
    }

}

-(id)splitViewdetailViewWithBarButton
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    
    if(![detailVC respondsToSelector:@selector(setSplitViewBarButtonItem:)] ||
       ![detailVC respondsToSelector:@selector(splitViewBarButtonItem)])
        detailVC = nil;
    return detailVC;
    
}


-(void)transferSplitViewBarButtonItemToViewController:(id)destinationViewController
{

    UIBarButtonItem *barbutton = [[self splitViewdetailViewWithBarButton] performSelector:@selector(splitViewBarButtonItem)];
    [[self splitViewdetailViewWithBarButton] performSelector:@selector(setSplitViewBarButtonItem:) withObject:nil];
    if (barbutton)
        [destinationViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:barbutton];

}


-(void)setPhotos:(NSArray *)Photos
{
    _Photos= Photos;
    
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
   
    //self.tags = [self getUniqueTags];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSString *)titleForRow:(NSUInteger)row
{
    return [self.Photos[row][FLICKR_PHOTO_TITLE] description];
}

-(NSString *)subTitleForRow:(NSUInteger)row
{
    return [[self.Photos[row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION]description];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
  return [self.Photos count];
}

-(NSString *)cellIdentifier
{
    //abstract
    return @"";
}
-(NSString *)segueIdentifier
{
    //abstract
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // static NSString *CellIdentifier = [self cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier] forIndexPath:indexPath];
       
    cell.textLabel.text=[self titleForRow:indexPath.row];
    cell.detailTextLabel.text=[self subTitleForRow:indexPath.row];
        
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
        if([segue.identifier isEqualToString:[self segueIdentifier]])
        {
            if([segue.destinationViewController respondsToSelector:@selector(setImageURL:)])
            {
                [self transferSplitViewBarButtonItemToViewController:segue.destinationViewController];
                NSURL *url =
                [self getImageUrlWithFormatBasedOnDeviceusing:indexpath.row];
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                [segue.destinationViewController setTitle:[self titleForRow:indexpath.row]];
            }
         
        }
     
    }
}

-(NSURL *)getImageUrlWithFormatBasedOnDeviceusing:(NSUInteger)index
{
    NSURL *url;
    if([[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"])
    {
        url = [FlickrFetcher urlForPhoto:self.Photos[index] format:FlickrPhotoFormatLarge] ;
    }
    else if([[UIDevice currentDevice].model isEqualToString:@"iPad Simulator"])
    {
        url = [FlickrFetcher urlForPhoto:self.Photos[index] format:FlickrPhotoFormatOriginal] ;
    }

    return url;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *mutableRecentPhotosFromUserDefaults = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"Recentlyviewed"] ;
    
    if(!mutableRecentPhotosFromUserDefaults)
        mutableRecentPhotosFromUserDefaults = [[NSMutableArray alloc]init];
  //  [mutableRecentPhotosFromUserDefaults removeAllObjects];
   if([mutableRecentPhotosFromUserDefaults containsObject:self.Photos[indexPath.row]])
    {
       [mutableRecentPhotosFromUserDefaults removeObjectAtIndex:[mutableRecentPhotosFromUserDefaults indexOfObject:self.Photos[indexPath.row]] ];
    }
    if([mutableRecentPhotosFromUserDefaults count]>5)
        [mutableRecentPhotosFromUserDefaults removeObjectAtIndex:0];
   [mutableRecentPhotosFromUserDefaults addObject:self.Photos[indexPath.row]];
    [[NSUserDefaults standardUserDefaults]setValue:mutableRecentPhotosFromUserDefaults forKey:@"Recentlyviewed"];
    //self.Photos = [mutableRecentPhotosFromUserDefaults copy];
    [[NSUserDefaults standardUserDefaults] synchronize];
  
}



@end
