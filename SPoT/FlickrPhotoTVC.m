//
//  FlickrPhotoTVC.m
//  SPoT
//
//  Created by Ujwal Manjunath on 3/4/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"


@interface FlickrPhotoTVC ()

@end

@implementation FlickrPhotoTVC

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
                NSURL *url = [FlickrFetcher urlForPhoto:self.Photos[indexpath.row] format:FlickrPhotoFormatLarge] ;
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                [segue.destinationViewController setTitle:[self titleForRow:indexpath.row]];
            }
         
        }
    }
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
    
    NSMutableArray *mutableRecentPhotosFromUserDefaults = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"Recently viewed"] ;
    
    if(!mutableRecentPhotosFromUserDefaults)
        mutableRecentPhotosFromUserDefaults = [[NSMutableArray alloc]init];
    [mutableRecentPhotosFromUserDefaults removeAllObjects];
   // if([mutableRecentPhotosFromUserDefaults containsObject:self.Photos[indexPath.row]])
    {
   //     [mutableRecentPhotosFromUserDefaults removeObjectAtIndex:[mutableRecentPhotosFromUserDefaults indexOfObject:self.Photos[indexPath.row]] ];
    }
    [mutableRecentPhotosFromUserDefaults addObject:self.Photos[indexPath.row]];
    [[NSUserDefaults standardUserDefaults]setValue:mutableRecentPhotosFromUserDefaults forKey:@"Recently viewed"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}



@end
