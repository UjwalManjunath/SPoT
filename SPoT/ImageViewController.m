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
        self.scrollView.contentSize = image.size;
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        self.imageView.image = image;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self loadImage];
}



@end
