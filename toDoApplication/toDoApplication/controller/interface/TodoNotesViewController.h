//
//  TodoNotesViewController.h
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"
#import "UserDefaults.h"
NS_ASSUME_NONNULL_BEGIN

@interface TodoNotesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property  NSMutableArray<Tasks *> *tasksArray;
//search bar property
@property  NSMutableArray<Tasks *> *filteredTasks;
@property BOOL isSearching;
@end

NS_ASSUME_NONNULL_END
