//  InProgressViewController.m
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import "InProgressViewController.h"
#import "Tasks.h"
@interface InProgressViewController () 

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
} - (void)viewWillAppear:(BOOL)animated{
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
        if (task.type == 1) { // Assuming type 1 means "in progress"
            [self.inProgressTasks addObject:task];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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

@end
