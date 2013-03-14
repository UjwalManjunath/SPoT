//
//  FlickrPhotoCache.m
//  SPoT
//
//  Created by Ujwal Manjunath on 3/13/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "FlickrPhotoCache.h"

@implementation FlickrPhotoCache

#define CACHE_IPHONE 3000000
#define CACHE_IPAD 12000000



-(NSData *)retreiveImageForUrl:(NSURL *)url
{
    NSFileManager *fm = [[NSFileManager alloc]init];
   // NSData *imageData;
    NSURL *filePathInFileSystem = [FlickrPhotoCache getUrlintheFileSystemForImageUrl:url];
    
    if([fm fileExistsAtPath:[filePathInFileSystem path]])
    {
        return [[NSData alloc ]initWithContentsOfURL:filePathInFileSystem];
    }
    else
    {
         [UIApplication sharedApplication].networkActivityIndicatorVisible   = YES; //bad
        NSData *data= [[NSData alloc]initWithContentsOfURL:url];
        [UIApplication sharedApplication].networkActivityIndicatorVisible   = NO; //bad
        return data;

    }
}

-(void) storeImagetoCache:(NSData *)imageData forUrl:(NSURL *)imageUrl
{
    if(![imageUrl isFileURL])
    {
        NSFileManager *fm = [[NSFileManager alloc]init];
        NSURL *fileUrl = [FlickrPhotoCache getUrlintheFileSystemForImageUrl:imageUrl];
        if(![fm fileExistsAtPath:[fileUrl path]])
        [self makeRoomInCacheForData:imageData];
        [imageData writeToURL:fileUrl atomically:YES];

    }
}

-(void) makeRoomInCacheForData:(NSData *)imageData
{
    NSFileManager *fm = [[NSFileManager alloc]init];
    NSUInteger imageDataSize = [imageData length];
    NSMutableArray *filesInDirectory = [[FlickrPhotoCache getFilesInDirectorySortedBasedOnLastAccessDateInDescendingOrder] mutableCopy];
    
    NSUInteger sizeOfFilesInCache = [[filesInDirectory valueForKeyPath:@"@sum.bytes"] integerValue];
    while (imageDataSize + sizeOfFilesInCache >=[FlickrPhotoCache maximumCacheSize]) {
        [fm removeItemAtURL:[filesInDirectory lastObject][@"url"] error:nil ];
        sizeOfFilesInCache = sizeOfFilesInCache - [[filesInDirectory lastObject][@"bytes"] integerValue];
        [filesInDirectory removeLastObject];
    }
    
}

+(NSArray *)getFilesInDirectorySortedBasedOnLastAccessDateInDescendingOrder
{
    NSFileManager *fm = [[NSFileManager alloc]init];
    NSArray *propertiesForKeys = @[NSURLContentAccessDateKey,NSURLFileSizeKey];
    NSArray *filesInDirectory = [fm contentsOfDirectoryAtURL:[FlickrPhotoCache getUrlForFlickrCacheDirectory] includingPropertiesForKeys:propertiesForKeys options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    NSMutableArray *files = [[NSMutableArray alloc]init]; //of dictionary
    for(NSURL *url in filesInDirectory)
    {
        NSDate *date ;
        [url getResourceValue:&date forKey:NSURLContentAccessDateKey error:nil];
        NSNumber *bytes;
        [url getResourceValue:&bytes forKey:NSURLFileSizeKey error:nil];
        [files addObject:@{@"date":date,@"bytes":bytes,@"url":url}];
    }
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
    return [files sortedArrayUsingDescriptors:@[sortDesc]];

    
}




+(NSURL *)getUrlintheFileSystemForImageUrl:(NSURL *)imageUrl
{
    return[[FlickrPhotoCache getUrlForFlickrCacheDirectory] URLByAppendingPathComponent:[imageUrl lastPathComponent]];
}


+(NSURL *)getUrlForFlickrCacheDirectory
{
    BOOL isDir = YES;
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSArray *urls = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *cacheUrl = [[urls lastObject] URLByAppendingPathComponent:@"Flickr_Cache"];
    
    if(![fileManager fileExistsAtPath:[cacheUrl path] isDirectory:&isDir]){
       [fileManager createDirectoryAtURL:cacheUrl withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return cacheUrl;
}

+(NSUInteger)maximumCacheSize
{
    return ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)? CACHE_IPAD:CACHE_IPHONE;
}

@end


