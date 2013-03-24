//
//  KZStudentInfoCell.m
//  Grades
//
//  Created by Kazuhito Ochiai on 3/20/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import "KZStudentInfoCell.h"

@implementation KZStudentInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_thumbnailImage release];
    [_nameLabel release];
    [_gradeLabel release];
    [super dealloc];
}
@end
