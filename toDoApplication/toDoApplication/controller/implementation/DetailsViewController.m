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
        [self addFieldsWithTask:self.taskToEdit];
        self.addEditButton.titleLabel.text = @"Edit Task";
    }
    
    [self updateImage:self.prioritySegement.selectedSegmentIndex];
    [self.prioritySegement addTarget:self action:@selector(priorityChanged:) 
        forControlEvents:UIControlEventValueChanged];
}

- (void)addFieldsWithTask:(Tasks *)task {
    NSLog(@"Editing Task: %@", task.title);

    self.myTitlee.text = task.title;
    self.myDescription.text = task.discription;
    self.prioritySegement.selectedSegmentIndex = task.priority;
    self.typeSegement.selectedSegmentIndex = task.type;
    self.myDatePicker.date = task.date;
    [self updateImage:task.priority];
}
- (IBAction)addEditButtonTapped:(UIButton *)sender {
    if (self.myTitlee.text.length == 0 || self.myDescription.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Saving Task"
          message:@"Please fill in all fields." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
         style:UIAlertActionStyleDefault handler:nil];
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
    
    // Load existing tasks
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userTasks"];
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
        BOOL taskFound = NO;
        for (Tasks *existingTask in tasksArray) {
            if ([existingTask.title isEqualToString:self.taskToEdit.title]) {
                existingTask.title = self.myTitlee.text;
                existingTask.discription = self.myDescription.text;
                existingTask.priority = self.prioritySegement.selectedSegmentIndex;
                existingTask.type = self.typeSegement.selectedSegmentIndex;
                existingTask.date = self.myDatePicker.date;
                existingTask.image = imageName;
                taskFound = YES;
                break;
            }
        }
        if (!taskFound) {
            NSLog(@"Error: Task to edit not found in the array.");
        }
    } else {
        Tasks *newTask = [[Tasks alloc] init];
        newTask.title = self.myTitlee.text;
        newTask.discription = self.myDescription.text;
        newTask.priority = self.prioritySegement.selectedSegmentIndex;
        newTask.type = self.typeSegement.selectedSegmentIndex;
        newTask.date = self.myDatePicker.date;
        newTask.image = imageName;
        [tasksArray addObject:newTask];
    }
    
    // Save updated tasks
    NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:tasksArray requiringSecureCoding:YES error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:newData forKey:@"userTasks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *message = self.isEditingTask ? @"Are you sure you want to edit?" : @"Task added successfully";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
     message:message  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm"  style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TasksUpdatedNotification" object:nil];
    }];
    
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss"
   style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirm];
    [alert addAction:dismiss];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)updateImage:(NSInteger)priorityIndex {
    switch (priorityIndex) {
        case 0:
            self.myImage.image = [UIImage imageNamed:@"low"];
            break;
        case 1:
            self.myImage.image = [UIImage imageNamed:@"med"];
            break;
        default:
            self.myImage.image = [UIImage imageNamed:@"high"];
            break;
    }
}

- (void)priorityChanged:(UISegmentedControl *)sender {
    [self updateImage:sender.selectedSegmentIndex];
}

@end
