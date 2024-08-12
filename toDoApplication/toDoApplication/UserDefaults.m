//
//  UserDefaults.m
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import "UserDefaults.h"
#import "UserDefaults.h"
@implementation NSUserDefaults (customUserDefault)

- (void)setTasks:(NSMutableArray<Tasks *> *)tasks forKey:(NSString *)key {
    NSError *error = nil;
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:tasks requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"Error archiving tasks: %@", error);
    } else {
        [self setObject:archivedData forKey:key];
        NSLog(@"Putting data success");
    }
}

- (NSMutableArray<Tasks *> *)tasksForKey:(NSString *)key {
    NSData *archiveData = [self objectForKey:key];
    if (archiveData) {
        NSError *error = nil;
        NSSet *set = [NSSet setWithArray:@[[NSMutableArray class], [Tasks class]]];
        NSMutableArray<Tasks *> *tasksArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:archiveData error:&error];
        if (error) {
            NSLog(@"Error unarchiving tasks: %@", error);
        }
        return [tasksArray mutableCopy];
    }
    return nil;
}

@end
