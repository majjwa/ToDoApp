//
//  DetailsViewController.h
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property bool isEditingTask ;
@property Tasks *taskToEdit;

@end

NS_ASSUME_NONNULL_END
