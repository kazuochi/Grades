//
//  KZViewController.m
//  Grades
//
//  Created by Kazuhito Ochiai on 3/20/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import "KZdataLoadViewController.h"
#import "KZStudentGradeTableViewController.h"
#import "KZStudent.h"
#import "JSON.h"
#import "UINavigationController+allOrientation.h"


@interface KZdataLoadViewController ()
@property (nonatomic) BOOL dataAvailable;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) NSMutableArray *studentsArray;
@property (nonatomic, retain) NSDictionary *thumbnailImageCacheDictionary;
@property (nonatomic) BOOL isShowingLandscapeView;

@end

@implementation KZdataLoadViewController

#pragma  mark - orientation support
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !self.isShowingLandscapeView)
    {
        self.loadingIndicator.frame = CGRectMake(380.0, 17.0, 10, 10);
        self.isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
             self.isShowingLandscapeView)
    {
        self.loadingIndicator.frame = CGRectMake(240.0, 17.0, 10, 10);
        self.isShowingLandscapeView = NO;
    }
}

#pragma  mark - getters/setters
-(NSDictionary *)thumbnailImageCacheDictionary{
    
    if(!_thumbnailImageCacheDictionary){
        _thumbnailImageCacheDictionary = [[NSDictionary alloc] init];
    }
    return _thumbnailImageCacheDictionary;
}
-(NSMutableArray *)studentsArray{
    
    if(!_studentsArray){
        _studentsArray = [[NSMutableArray alloc] init];
    }
    
    return _studentsArray;
}

-(UIActivityIndicatorView *)loadingIndicator{
    
    if(!_loadingIndicator)
    {
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingIndicator.frame = CGRectMake(240.0, 17.0, 10, 10);
    }
    return _loadingIndicator;
    
}

#pragma  mark - main methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initController];
}

-(void)initController{
    
    self.loadGradesTable.scrollEnabled = NO;
    self.isShowingLandscapeView = NO;
    
    //observe UIDeviceOrientationDidChangeNotification to detect orientation change
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

}

//download students grade from network
-(void)downloadGrade{
    
    [self.loadingIndicator startAnimating];
 
    dispatch_queue_t downloadJsonQueue = dispatch_queue_create("download json", NULL);
    dispatch_async(downloadJsonQueue, ^{
        
        //request JSON to server
       // https://dl.dropbox.com/s/siajtkyzworpuh3/challenge_grades.json?token_hash=AAHh9lQ4QInS- D18W0474instLN3rnEDehBd0MvShlwU4g&dl=1
        NSURL *gradeJsonURL = [NSURL URLWithString:[@"https://dl.dropbox.com/s/sn5s0hpowrf1rq1/challenge_grades-.json?token_hash=AAH7rsultkLJ2xNbhEhRH_By--dzKovovSK9Z7FoSNQe6g&dl=1" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:gradeJsonURL];
        NSURLResponse *response = NULL;
        NSError *requestError = NULL;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
        
        //if error, pop alert with error description, parse JSON into model otherwise.
        if(requestError){
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.loadingIndicator stopAnimating];
                 
                 UIAlertView *networkErrorAlert = [[[UIAlertView alloc] initWithTitle:@"Network Error" message:requestError.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
                 [networkErrorAlert show];
                 
             });
        }
        else{
            NSDictionary *jsonValue = [[[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease] JSONValue];
            
            [self createStudentsArray:jsonValue];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *showStudentCellPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [self.loadingIndicator stopAnimating];
                
                //insert show student cell
                if([self.loadGradesTable cellForRowAtIndexPath:showStudentCellPath] == nil && [self.studentsArray lastObject] != nil){
                    [self.loadGradesTable beginUpdates];
                    [self.loadGradesTable insertRowsAtIndexPaths:[NSArray arrayWithObject:showStudentCellPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.loadGradesTable endUpdates];
                }
                
            });
        }
    });
    
    dispatch_release(downloadJsonQueue);
    
}

-(void)createStudentsArray:(NSDictionary *)jsonValue{
    
    NSArray *gradesArray = [jsonValue objectForKey:@"grades"];

    for (NSDictionary *studentDic in gradesArray){
        
        KZStudent *student = [[[KZStudent alloc] initWithDictionary:studentDic] autorelease];
        
        //avoid adding duplicate student info.
        if(![self.studentsArray containsObject:student]){
            [self.studentsArray addObject:student];
        }
        
    }
    if([self.studentsArray count] > 0){
        self.dataAvailable = YES;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.thumbnailImageCacheDictionary = [NSDictionary dictionary];
}

- (void)dealloc {
    [_loadGradesTable release];
    [_studentsArray release];
    [_loadingIndicator release];
    [_thumbnailImageCacheDictionary release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAvailable? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.textAlignment = NSTextAlignmentCenter; //align text center
        if(row == 0){
            [cell addSubview:self.loadingIndicator];
        }
    }
    
    if(row == 0){

        cell.textLabel.text = @"Load Grades";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else if(row == 1){
        
        cell.textLabel.text = @"Show Grades";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    if(row == 0){
        [self downloadGrade];
    }
    else if(row == 1){
        KZStudentGradeTableViewController * studentGradeTableViewController = [[[KZStudentGradeTableViewController alloc] initWithNibName:@"KZStudentGradeTableViewController" bundle:nil] autorelease];

        studentGradeTableViewController.studentsArray = self.studentsArray;
        studentGradeTableViewController.delegate = self;
        studentGradeTableViewController.imageDictionary = [[self.thumbnailImageCacheDictionary mutableCopy] autorelease];
        
        [self.navigationController pushViewController:studentGradeTableViewController animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UILabel *headerLabel = [[[UILabel alloc] init] autorelease];
        headerLabel.text = @"Student Grades";
        headerLabel.backgroundColor = [UIColor blueColor];
        return headerLabel;
    }
    
    return nil;

}

//save loaded imaged in cache
-(void) kzStudentGradeTableViewControllerDelegateDidPopFromNavigationStack:(NSDictionary *)imageCacheDictionary{
        self.thumbnailImageCacheDictionary = imageCacheDictionary;
    
    
}

@end
