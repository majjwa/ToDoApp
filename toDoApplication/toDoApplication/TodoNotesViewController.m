#import "TodoNotesViewController.h"
#import "UserDefaults.h"
#import "Tasks.h"
#import "DetailsViewController.h"

@interface TodoNotesViewController () 
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchbar;
@property (weak, nonatomic) IBOutlet UITableView *toDoNotesTable;

@end

@implementation TodoNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.toDoNotesTable.dataSource = self;
    self.toDoNotesTable.delegate = self;
    self.mySearchbar.delegate = self;
    self.filteredTasks = [NSMutableArray array];
    self.isSearching = NO;
    [self loadTasks];
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
    return self.isSearching ? self.filteredTasks.count : self.tasksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    Tasks *task = self.isSearching ? self.filteredTasks[indexPath.row] : self.tasksArray[indexPath.row];
    cell.textLabel.text = task.title;
    cell.imageView.image = [UIImage imageNamed:task.image];
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isSearching = NO;
        [self.filteredTasks removeAllObjects];
        [self.toDoNotesTable reloadData];
    } else {
        self.isSearching = YES;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title CONTAINS[cd] %@", searchText];
        self.filteredTasks = [[self.tasksArray filteredArrayUsingPredicate:predicate] mutableCopy];
        [self.toDoNotesTable reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
    self.isSearching = NO;
    [self.filteredTasks removeAllObjects];
    [self.toDoNotesTable reloadData];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tasks *taskToEdit = self.isSearching ? self.filteredTasks[indexPath.row] : self.tasksArray[indexPath.row];
    
    UIContextualAction *editAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
       title:@"Edit"
           handler:^(UIContextualAction * _Nonnull action, UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        
        detailsVC.taskToEdit = taskToEdit;
        detailsVC.isEditingTask = YES;
        [self.navigationController pushViewController:detailsVC animated:YES];
        completionHandler(YES);
    }];
    editAction.backgroundColor = [UIColor blackColor];
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
   title:@"Delete" handler:^(UIContextualAction * _Nonnull action, UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self.tasksArray removeObject:taskToEdit];
        [self saveTasks];
        [self.toDoNotesTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        completionHandler(YES);
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[editAction, deleteAction]];
    config.performsFirstActionWithFullSwipe = NO;
    
    return config;
}




- (void)saveTasks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:self.tasksArray requiringSecureCoding:YES error:nil];
    [defaults setObject:newData forKey:@"userTasks"];
    [defaults synchronize];
}

@end
