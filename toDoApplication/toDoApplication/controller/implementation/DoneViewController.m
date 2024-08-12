// 
//  DoneViewController.m
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import "DoneViewController.h"
#import "Tasks.h"

@interface DoneViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *DoneTable;

@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the table view data source and delegate
    self.DoneTable.dataSource = self;
    self.DoneTable.delegate = self;

    [self loadTasks];
    [self organizeTasksByPriority];
  
    [self.DoneTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadTasks];
    [self organizeTasksByPriority];
    [self.DoneTable reloadData];
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

- (void)organizeTasksByPriority {
    self.tasksByPriority = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
    
    for (Tasks *task in self.allTasks) {
        if (task.type == 2) { // Filter for "Done" tasks
            [self.tasksByPriority[task.priority] addObject:task];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3; // Low, Medium, High
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasksByPriority[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DoneTaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    Tasks *task = self.tasksByPriority[indexPath.section][indexPath.row];
    cell.textLabel.text = task.title;
    cell.imageView.image = [UIImage imageNamed:task.image];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Low";
        case 1:
            return @"Medium";
        case 2:
            return @"High";
        default:
            return @"";
    }
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tasks *taskToDelete = self.tasksByPriority[indexPath.section][indexPath.row];

    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
 title:@"Delete" handler:^(UIContextualAction * _Nonnull action, UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self.tasksByPriority[indexPath.section] removeObject:taskToDelete];
        [self.allTasks removeObject:taskToDelete];
        [self saveTasks];
        [self.DoneTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        completionHandler(YES);
    }];
    deleteAction.backgroundColor = [UIColor lightGrayColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
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
