#import "TodoNotesViewController.h"
#import "UserDefaults.h"
#import "Tasks.h"

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
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    Tasks *task = self.tasksArray[indexPath.row];
    cell.textLabel.text = task.title;
    cell.imageView.image = [UIImage imageNamed:task.image];
    
    return cell;
}


@end
