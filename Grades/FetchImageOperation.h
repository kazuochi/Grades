//
//  FetchImageOperation.h
//  MusicAppTemplate
//
//  Created by Kazuhito Ochiai on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchImageOperation : NSOperation {
    NSURL *imageURL;
    id targetObject;
    SEL targetMethod;
}
-(id)initWithImageURL:(NSURL *)url target:(id)targClass
         targetMethod:(SEL)targClassMethod;
@end
