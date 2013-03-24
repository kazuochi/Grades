//
//  UINavigationController+allOrientation.m
//  SimpleClock
//
//  Created by Kazuhito Ochiai on 3/19/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import "UINavigationController+allOrientation.h"

@implementation UINavigationController (allOrientation)
- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown);
}

@end
