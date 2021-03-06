//
//  ImageViewController.m
//  SPoT
//
//  Created by Ujwal Manjunath on 3/3/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "ImageViewController.h"
#import "StanfordFlickrTagTVC.h"
#import "FlickrPhotoCache.h" 

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tabBarTitleButton;
@property(strong,nonatomic) UIPopoverController *popOver;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property(strong,nonatomic) FlickrPhotoCache *imageCache;
@property(strong,nonatomic) IBOutlet UIBarButtonItem *splitViewBarButtonItem;

@end

@implementation ImageViewController

-(FlickrPhotoCache *)imageCache
{
    if(!_imageCache) _imageCache = [[ FlickrPhotoCache alloc]init];
    return _imageCache;
}

-(void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarbuttons = [self.toolbar.items mutableCopy];
    if(_splitViewBarButtonItem)
        [toolbarbuttons removeObject:_splitViewBarButtonItem];
    if(splitViewBarButtonItem)
        [toolbarbuttons insertObject:splitViewBarButtonItem atIndex:0];
    
    self.toolbar.items = toolbarbuttons;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"showPopOver"])
    {
        BOOL reu =self.popOver.popoverVisible? NO:YES;
        return reu;
    }
    else
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"showPopOver"])
    {
        if([segue.destinationViewController isKindOfClass:[UINavigationController class]])
        {
            if([segue isKindOfClass:[UIStoryboardPopoverSegue class]])
            {
                self.popOver = ((UIStoryboardPopoverSegue *)segue).popoverController;

                
            }
        }
    }
}

-(void)setTitle:(NSString *)title
{
    super.title = title;
    self.tabBarTitleButton.title = title;
}

-(UIImageView *)imageView
{
    if(!_imageView) _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    return _imageView;
}

-(void)setImageURL:(NSURL *)imageURL
{
    _imageURL= imageURL;
    [self loadImage];
}

-(void)loadImage
{
    if(self.scrollView)
    {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image=nil;
        [self.spinner startAnimating];
        dispatch_queue_t imageLoaderQ = dispatch_queue_create("image Loader", NULL);
        dispatch_async(imageLoaderQ, ^{
           
            NSData *imageData = [self.imageCache retreiveImageForUrl:self.imageURL];
            UIImage *image = [[UIImage alloc]initWithData:imageData];
            [self.imageCache storeImagetoCache:imageData forUrl:self.imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(image)
                {
                    self.scrollView.zoomScale=1.0;
                    self.scrollView.contentSize = image.size;
                    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                    self.imageView.image = image;
                }
                [self.spinner stopAnimating];
                
            });

        });
               
        
           }
    
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
   
    CGRect frameRect = self.imageView.frame;
  
    if((frameRect.size.height <self.view.frame.size.height) || (frameRect.size.width<self.view.frame.size.width))
    {
        CGFloat widthRatio = self.scrollView.bounds.size.width/ self.imageView.bounds.size.width;
        CGFloat heighRatio = self.scrollView.bounds.size.height/self.imageView.bounds.size.height;
        self.scrollView.zoomScale = (widthRatio>heighRatio)? widthRatio:heighRatio;
    //     [self.scrollView zoomToRect:phonewidth animated:YES];
    }
        
   
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.minimumZoomScale=0.2;
    self.scrollView.delegate=self;
	[self loadImage];
     self.tabBarTitleButton.title = self.title;
    [self setSplitViewBarButtonItem:self.splitViewBarButtonItem]; 
}



@end
