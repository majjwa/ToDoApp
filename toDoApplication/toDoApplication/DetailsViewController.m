//
//  DetailsViewController.m
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import "DetailsViewController.h"
#import "Tasks.h"
#import "UserDefaults.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UITextField *myTitlee;
@property (weak, nonatomic) IBOutlet UITextView *myDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegement;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegement;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.prioritySegement.selectedSegmentIndex) {
        case 0:
            self.myImage.image = [UIImage imageNamed:@"1"];
            break;
        case 1:
            self.myImage.image = [UIImage imageNamed:@"2"];
            break;
        default:
            self.myImage.image = [UIImage imageNamed:@"3"];
            break;
    }
}



- (IBAction)addEditButton:(UIButton *)sender {
    if (self.myTitlee.text.length == 0 ||
        self.myDescription.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
         message:@"Please fill in all fields."
         preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSString *imageName = [self imageNameForPriority:self.prioritySegement.selectedSegmentIndex];
    Tasks *newTask = [[Tasks alloc] initWithTitle:self.myTitlee.text
     description:self.myDescription.text
       priority:self.prioritySegement.selectedSegmentIndex
       type:self.typeSegement.selectedSegmentIndex
        date:self.myDatePicker.date
        image:imageName];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray<Tasks *> *tasksArray = [[defaults tasksForKey:@"userTasks"] mutableCopy];
    
    if (!tasksArray) {
        tasksArray = [NSMutableArray array];
    }
    
    [tasksArray addObject:newTask];
    [defaults setTasks:tasksArray forKey:@"userTasks"];
    
    NSLog(@"Task added successfully.");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
      message:@"Add Success" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:NULL];
    [alert addAction:confirm];
    [alert addAction:dismiss];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (NSString *)imageNameForPriority:(NSInteger)priorityIndex {
    switch (priorityIndex) {
        case 0:
            return @"1";
        case 1:
            return @"2";
        default:
            return @"3";
    }
}



@end
