#import "TodoNotesViewController.h"
#import "UserDefaults.h"
#import "Tasks.h"
#import "DetailsViewController.h"

@interface TodoNotesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *toDoNotesTable;

@end

@implementation TodoNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"userTasks"];
    if (data) {
        NSError *error;
        NSSet *classes = [NSSet setWithArray:@[[NSMutableArray class], [Tasks class]]];
        self.tasksArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:&error];
        if (error) {
            NSLog(@"Error unarchiving tasks: %@", error.localizedDescription);
        }
    } else {
        self.tasksArray = [NSMutableArray array];
    }
    
    self.toDoNotesTable.dataSource = self;
    self.toDoNotesTable.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadTasks];
    [self.toDoNotesTable reloadData];
}

- (void)loadTasks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"userTasks"];
    if (data) {
        NSError *error;
        NSSet *classes = [NSSet setWithArray:@[[NSMutableArray class], [Tasks class]]];
        self.tasksArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:&error];
        if (error) {
            NSLog(@"Error unarchiving tasks: %@", error.localizedDescription);
        }
    } else {
        self.tasksArray = [NSMutableArray array];
    }
}

- (IBAction)addEditButton:(UIBarButtonItem *)sender {
    UIViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    Tasks *task = self.tasksArray[indexPath.row];
    cell.textLabel.text = task.title;
    cell.imageView.image = [UIImage imageNamed:task.image];
    
    return cell;
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {

    UIContextualAction *editAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
     title:@"Edit"
  handler:^(UIContextualAction * _Nonnull action, UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self editTaskAtIndexPath:indexPath];
        completionHandler(YES);
    }];
    editAction.backgroundColor = [UIColor blackColor];
  
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
    title:@"Delete" handler:^(UIContextualAction * _Nonnull action, UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self deleteTaskAtIndexPath:indexPath];
        completionHandler(YES);
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[editAction, deleteAction]];
    config.performsFirstActionWithFullSwipe = NO;
    
    return config;
}

- (void)editTaskAtIndexPath:(NSIndexPath *)indexPath {
   Tasks *taskToEdit = self.tasksArray[indexPath.row];
   DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
 
   detailsVC.taskToEdit = taskToEdit;
    detailsVC.isEditingTask = YES;
[self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)deleteTaskAtIndexPath:(NSIndexPath *)indexPath {
   [self.tasksArray removeObjectAtIndex:indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:self.tasksArray requiringSecureCoding:YES error:nil];
    [defaults setObject:newData forKey:@"userTasks"];
    [defaults synchronize];
    [self.toDoNotesTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
