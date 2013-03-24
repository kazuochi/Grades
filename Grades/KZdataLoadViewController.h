//
//  KZViewController.h
//  Grades
//
//  Created by Kazuhito Ochiai on 3/20/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZStudentGradeTableViewController.h"

@interface KZdataLoadViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, KZStudentGradeTableViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *loadGradesTable;

@end
