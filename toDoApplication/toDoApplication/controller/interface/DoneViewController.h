//
//  DoneViewController.h
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"
NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray<Tasks *> *allTasks;
@property (strong, nonatomic) NSMutableArray<NSMutableArray<Tasks *> *> *tasksByPriority;
@end

NS_ASSUME_NONNULL_END
