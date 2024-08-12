//
// TodoNotesViewController.m
//  toDoApplication
//  Created by marwa maky on 12/08/2024.

#import "DetailsViewController.h"
#import "Tasks.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UITextField *myTitlee;
@property (weak, nonatomic) IBOutlet UITextView *myDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegement;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegement;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *addEditButton;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isEditingTask) {
        [self populateFieldsWithTask:self.taskToEdit];
        [self.addEditButton setTitle:@"Edit" forState:UIControlStateNormal];
        
    }
    
    [self updateImage:self.prioritySegement.selectedSegmentIndex];
    [self.prioritySegement addTarget:self action:@selector(priorityChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)populateFieldsWithTask:(Tasks *)task {
    self.myTitlee.text = task.title;
    self.myDescription.text = task.discription;
    self.prioritySegement.selectedSegmentIndex = task.priority;
    self.typeSegement.selectedSegmentIndex = task.type;
    self.myDatePicker.date = task.date;
    [self updateImage:task.priority];
}

- (IBAction)addEditButtonTapped:(UIButton *)sender {
    
    if (self.myTitlee.text.length == 0 || self.myDescription.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
         message:@"Please fill in all fields." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSString *imageName;
    switch (self.prioritySegement.selectedSegmentIndex) {
        case 0:
            imageName = @"low";
            break;
        case 1:
            imageName = @"med";
            break;
        default:
            imageName = @"high";
            break;
    }
    
    Tasks *task;
    if (self.isEditingTask) {
        task = self.taskToEdit;
        task.title = self.myTitlee.text;
        task.discription = self.myDescription.text;
        task.priority = self.prioritySegement.selectedSegmentIndex;
        task.type = self.typeSegement.selectedSegmentIndex;
        task.date = self.myDatePicker.date;
        task.image = imageName;
    } else {
        task = [[Tasks alloc] initWithTitle:self.myTitlee.text
           description:self.myDescription.text
              priority:self.prioritySegement.selectedSegmentIndex
                                       type:self.typeSegement.selectedSegmentIndex
                                        date:self.myDatePicker.date
                                       image:imageName];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"userTasks"];
    NSMutableArray<Tasks *> *tasksArray = [NSMutableArray array];
    
    if (data) {
        NSError *error;
        NSSet *classes = [NSSet setWithArray:@[[NSMutableArray class], [Tasks class]]];
        tasksArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:&error];
        if (error) {
            NSLog(@"Error unarchiving tasks: %@", error.localizedDescription);
            tasksArray = [NSMutableArray array];
        }
    }
    
    if (self.isEditingTask) {
        NSInteger index = [tasksArray indexOfObject:self.taskToEdit];
        if (index != NSNotFound) {
            [tasksArray replaceObjectAtIndex:index withObject:task];
        } else {
            NSLog(@"Error: Task to edit not found in the array.");
        }
    } else {
        [tasksArray addObject:task];
    }
    
    NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:tasksArray requiringSecureCoding:YES error:nil];
    [defaults setObject:newData forKey:@"userTasks"];
    [defaults synchronize];
    
    NSString *message = self.isEditingTask ? @"Are u sure u want to edit? " : @"Task Added";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
  message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TasksUpdatedNotification" object:nil];
    }];
    
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:NULL];
    [alert addAction:confirm];
    [alert addAction:dismiss];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)updateImage:(NSInteger)priorityIndex {
    NSString *imageName;
    switch (priorityIndex) {
        case 0:
            imageName = @"low";
            break;
        case 1:
            imageName = @"med";
            break;
        default:
            imageName = @"high";
            break;
    }
    self.myImage.image = [UIImage imageNamed:imageName];
}

- (void)priorityChanged:(UISegmentedControl *)sender {
    [self updateImage:sender.selectedSegmentIndex];
}

@end
