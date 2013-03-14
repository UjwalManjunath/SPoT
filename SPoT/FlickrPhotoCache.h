//
//  FlickrPhotoCache.h
//  SPoT
//
//  Created by Ujwal Manjunath on 3/13/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhotoCache : NSObject


-(void) storeImagetoCache:(NSData *)imageData forUrl:(NSURL *)imageUrl
;

-(NSData *)retreiveImageForUrl:(NSURL *)url;
@end
