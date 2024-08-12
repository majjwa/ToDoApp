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
    
    [self updateImage:self.prioritySegement.selectedSegmentIndex];
}

- (IBAction)addEditButton:(UIButton *)sender {
    if (self.myTitlee.text.length == 0 || self.myDescription.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
      message:@"Please fill in all fields."
    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    Tasks *newTask = [[Tasks alloc] initWithTitle:self.myTitlee.text
    description:self.myDescription.text
    priority:self.prioritySegement.selectedSegmentIndex
    type:self.typeSegement.selectedSegmentIndex
 date:self.myDatePicker.date
image:[self imageNameForPriority:self.prioritySegement.selectedSegmentIndex]];
    
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
    [tasksArray addObject:newTask];
  
    NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:tasksArray requiringSecureCoding:YES error:nil];
    [defaults setObject:newData forKey:@"userTasks"];
    [defaults synchronize];
    
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
            return @"high";
        case 1:
            return @"med";
        default:
            return @"low";
    }
}

- (void)updateImage:(NSInteger)priorityIndex {
    self.myImage.image = [UIImage imageNamed:[self imageNameForPriority:priorityIndex]];
}

@end
