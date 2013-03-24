//
//  KZStudent.m
//  Grades
//
//  Created by Kazuhito Ochiai on 3/20/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import "KZStudent.h"

@implementation KZStudent

-(id)initWithDictionary:(NSDictionary *)studentInfoDictionary{
    self = [self init];
    if(self){
        _name = [[studentInfoDictionary valueForKey:@"student"] copy];
        _thumbnailURL = [[studentInfoDictionary valueForKey:@"thumbnail"] copy];
        _grade = [[studentInfoDictionary valueForKey:@"grade"] copy];
    }
    return self;
}

-(void)dealloc{
    [_name release];
    [_grade release];
    [_thumbnailURL release];
    [_thumbnailImage release];
    [super dealloc];
}

//return true is object has same name and same thumbnail URL.
- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToStudent:other];
}

- (BOOL)isEqualToStudent:(KZStudent *)aStudent {
    if (self == aStudent)
        return YES;
    
    if (![(id)[self name] isEqualToString:[aStudent name]] && ![[self thumbnailURL] isEqualToString:[aStudent thumbnailURL]])
        return NO;

    return YES;
}

-(NSUInteger)hash {
    
    NSUInteger result = 1;
    NSUInteger prime = 31;
    
    result = prime * result + [self.name hash];
    result = prime * result + [self.grade hash];
    result = prime * result + [self.thumbnailImage hash];
    result = prime * result + [self.thumbnailURL hash];
    return result;
}


@end
