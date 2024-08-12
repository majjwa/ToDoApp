//
//  Tasks.m
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import "Tasks.h"

@implementation Tasks
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        _name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}
- (instancetype)initWithName:(NSString *)name AndPrice:(int)price {
    if (self=[super init]) {
        self.name=name;
    }
    return  self;
}
@end
