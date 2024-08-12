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
@property  NSMutableArray<Tasks *> *allTasks;
@property  NSMutableArray<NSMutableArray<Tasks *> *> *tasksByPriority;
@property (weak, nonatomic) IBOutlet UIImageView *defaultimg;

@end

NS_ASSUME_NONNULL_END
