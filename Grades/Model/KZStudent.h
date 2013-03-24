//
//  KZStudent.h
//  Grades
//
//  Created by Kazuhito Ochiai on 3/20/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZStudent : NSObject
@property (copy, nonatomic) NSString *name;
@property (retain, nonatomic) NSNumber *grade;
@property (retain, nonatomic) UIImage *thumbnailImage;
@property (copy, nonatomic) NSString *thumbnailURL;

-(id) initWithDictionary:(NSDictionary *)studentInfoDictionary;
@end
