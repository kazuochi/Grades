//
//  FetchImageOperation.m
//  MusicAppTemplate
//
//  Created by Kazuhito Ochiai on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FetchImageOperation.h"

@implementation FetchImageOperation

-(id)initWithImageURL:(NSURL *)url target:(id)targClass
 targetMethod:(SEL)targClassMethod
{
    if(self = [super init]){
        imageURL = [url retain];
        targetObject = targClass;
        targetMethod = targClassMethod;
    }
    return self;
}

-(void)main
{
    NSAutoreleasePool *localPool;
    @try{
        //create autoreleasePool
        localPool = [[NSAutoreleasePool alloc] init];
        // see if we have been cancelled
        if([self isCancelled]) return;
        //fetch the image
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
        
        //create the image from image data
        UIImage *image = nil;
        if(imageData != nil){
         image = [[UIImage alloc] initWithData:imageData];
        }
        else{
         image = [UIImage imageNamed:@"empty.png"];
        
        }
        
        //store the image and url in a dictionary to return
        
        NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:image, @"image", imageURL, @"url", nil];
      
        
        //send it back
        [targetObject performSelectorOnMainThread:targetMethod withObject:result waitUntilDone:NO];
        [imageData release];
        [image release];
        [result release];
    }
    @catch (NSException *exception){
        //log exception
        NSLog(@"Exception:%@", [exception reason]);
        
    }
    @finally {
        [localPool release];
    }
}
-(void)dealloc
{
    [imageURL release];
    [super dealloc];
    
}
@end
