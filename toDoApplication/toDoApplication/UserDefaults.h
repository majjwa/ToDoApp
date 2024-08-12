//
//  UserDefaults.h
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import <Foundation/Foundation.h>
#import "Tasks.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (customUserDefault)

- (void)setTasks:(NSMutableArray<Tasks *> *)tasks forKey:(NSString *)key;
- (NSMutableArray<Tasks *> *)tasksForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
