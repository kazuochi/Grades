//
//  KZStudentInfoCell.h
//  Grades
//
//  Created by Kazuhito Ochiai on 3/20/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZStudentInfoCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *gradeLabel;

@end
