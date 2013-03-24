//
//  KZStudentGradeTableViewController.m
//  Grades
//
//  Created by Kazuhito Ochiai on 3/20/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import "KZStudentGradeTableViewController.h"
#import "KZStudentInfoCell.h"
#import "KZStudent.h"
#import "FetchImageOperation.h"

@interface KZStudentGradeTableViewController ()
@property (retain, nonatomic) NSOperationQueue *workQueue;
@end

@implementation KZStudentGradeTableViewController

#pragma  mark - orientation support
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - getters/setters
-(NSOperationQueue *)workQueue{
    if(!_workQueue){
        _workQueue =  [[NSOperationQueue alloc] init];
        [self.workQueue setMaxConcurrentOperationCount:1];
    }
    return _workQueue;
}

-(NSMutableDictionary *)imageDictionary{
    if(!_imageDictionary){
        _imageDictionary = [[NSMutableDictionary alloc] init];
    }
    return _imageDictionary;
}

#pragma mark - main methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.imageDictionary = [NSMutableDictionary dictionary];
}

- (void)dealloc {
    
    [_studentsArray release];
    [_studentsTable release];
    [_workQueue release];
    [_imageDictionary release];
    [super dealloc];
    
}

//send imageDictionary to delegate for cahcing images when viewcontroller is popped.
- (void)viewWillDisappear:(BOOL)animated {
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        [self.delegate kzStudentGradeTableViewControllerDelegateDidPopFromNavigationStack:self.imageDictionary];
    }
}

#pragma mark -
#pragma mark Mathods for Loading Remote Images using NSOperation
-(UIImage *)getImageForURL:(NSURL *)url
{
    id object = [self.imageDictionary objectForKey:url];
    if(object == nil) {
        // we don't have an image yet so store a temporary NSString object for the url
        [self.imageDictionary setObject:@"F" forKey:url];
        
        //create a FetchImageOperation
        FetchImageOperation *fetchImageOp = [[FetchImageOperation alloc] initWithImageURL:url target:self
                                                                             targetMethod:@selector(storeImageForURL:)];
        //add it to the queue
        [self.workQueue addOperation:fetchImageOp];
        //release it
        [fetchImageOp release];
    }else{
        if(![object isKindOfClass:[UIImage class]]) {
            ///object is not an image so set the object to nil
            object = nil;
        }
    }
    return object;
    
}

-(void)storeImageForURL:(NSDictionary *)result
{
    NSURL *url = [result objectForKey:@"url"];
    UIImage *image = [result objectForKey:@"image"];
    //store the image
    [self.imageDictionary setObject:image forKey:url];
    
    //tell the table to reload the data
    [self.studentsTable reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.studentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"studentCell";
    KZStudentInfoCell *cell = (KZStudentInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if(!cell){
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"KZStudentInfoCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (KZStudentInfoCell *) currentObject;
                break;
            }
        }
    }
    
    NSUInteger row = indexPath.row;
    KZStudent *student = self.studentsArray[row];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    cell.nameLabel.text = student.name;
    cell.gradeLabel.text= student.grade.stringValue;
    cell.thumbnailImage.image = [self getImageForURL:[NSURL URLWithString:student.thumbnailURL]];
    
    return cell;
}

#pragma mark - Table view delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
    
}

@end
