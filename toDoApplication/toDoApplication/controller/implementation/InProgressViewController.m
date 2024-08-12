//  
// InProgressViewController.m
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import "InProgressViewController.h"
#import "Tasks.h"
#import "DetailsViewController.h"

@interface InProgressViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *inProgressTable;
@property (strong, nonatomic) NSMutableArray<Tasks *> *allTasks;
@property (strong, nonatomic) NSMutableArray<Tasks *> *inProgressTasks;

@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inProgressTable.dataSource = self;
    self.inProgressTable.delegate = self;
   
    
    [self loadTasks];
    [self filterInProgressTasks];
    
    
    [self.inProgressTable reloadData];
    [self updateimage];
}

- (void)updateimage {
    self.imagedefault.hidden = self.inProgressTasks.count > 0;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadTasks];
    [self filterInProgressTasks];
    [self.inProgressTable reloadData];
}

- (void)loadTasks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"userTasks"];
    
    if (data) {
        NSError *error;
        NSSet *classes = [NSSet setWithArray:@[[NSMutableArray class], [Tasks class]]];
        self.allTasks = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:&error];
        if (error) {
            NSLog(@"Error unarchiving tasks: %@", error.localizedDescription);
            self.allTasks = [NSMutableArray array];
        }
    } else {
        self.allTasks = [NSMutableArray array];
    }
}

- (void)filterInProgressTasks {
    self.inProgressTasks = [NSMutableArray array];
    
    for (Tasks *task in self.allTasks) {
       
        
        if (task.type == 1) {
            [self.inProgressTasks addObject:task];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [self updateimage];

    return self.inProgressTasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    Tasks *task = self.inProgressTasks[indexPath.row];
    cell.textLabel.text = task.title;
    cell.imageView.image = [UIImage imageNamed:task.image];
    
    return cell;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tasks *taskToEdit = self.inProgressTasks[indexPath.row];
    
    UIContextualAction *editAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
       title:@"Edit"
           handler:^(UIContextualAction * _Nonnull action, UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        DetailsViewController *detailsVC = [self.storyboard
                        instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        detailsVC.taskToEdit = taskToEdit;
        detailsVC.isEditingTask = YES;
        [self.navigationController pushViewController:detailsVC animated:YES];
        completionHandler(YES);
    }];
    editAction.backgroundColor = [UIColor darkGrayColor];
    
  
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
       title:@"Delete" handler:^(UIContextualAction * _Nonnull action, UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self.inProgressTasks removeObject:taskToEdit];
        [self.allTasks removeObject:taskToEdit];
        [self saveTasks];
        [self.inProgressTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        completionHandler(YES);
    }];
    deleteAction.backgroundColor = [UIColor lightGrayColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[editAction, deleteAction]];
    config.performsFirstActionWithFullSwipe = NO;
    
    return config;
}

- (void)saveTasks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.allTasks requiringSecureCoding:YES error:nil];
    [defaults setObject:data forKey:@"userTasks"];
    [defaults synchronize];
}

@end
