//
//  ImageViewController.m
//  SPoT
//
//  Created by Ujwal Manjunath on 3/3/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) UIImageView *imageView;

@end

@implementation ImageViewController

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
        
        NSData *imageData = [[NSData alloc]initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc]initWithData:imageData];
        if(image)
        {
            self.scrollView.zoomScale=1.0;
            self.scrollView.contentSize = image.size;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            self.imageView.image = image;
        }
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
}



@end
