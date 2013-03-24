//
//  KZStudentGradeTableViewController.h
//  Grades
//
//  Created by Kazuhito Ochiai on 3/20/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KZStudentGradeTableViewControllerDelegate;

@interface KZStudentGradeTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *studentsTable;
@property (retain, nonatomic) NSArray *studentsArray;
@property (assign, nonatomic) id<KZStudentGradeTableViewControllerDelegate> delegate;
@property (retain, nonatomic) NSMutableDictionary *imageDictionary;

@end

@protocol KZStudentGradeTableViewControllerDelegate
-(void)kzStudentGradeTableViewControllerDelegateDidPopFromNavigationStack:(NSDictionary *)imageCacheDictionary;
@end