//
//  Tasks.m
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import "Tasks.h"

@implementation Tasks

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_image forKey:@"image"];
    [encoder encodeObject:_title forKey:@"title"];
    [encoder encodeObject:_discription forKey:@"discription"];
    [encoder encodeInteger:_priority forKey:@"priority"];
    [encoder encodeInteger:_type forKey:@"type"];
    [encoder encodeObject:_date forKey:@"date"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        _image = [decoder decodeObjectForKey:@"image"];
        _title = [decoder decodeObjectForKey:@"title"];
        _discription = [decoder decodeObjectForKey:@"discription"];
        _priority = [decoder decodeIntegerForKey:@"priority"];
        _type = [decoder decodeIntegerForKey:@"type"];
        _date = [decoder decodeObjectForKey:@"date"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithTitle:(NSString *)title description:(NSString *)discription priority:(NSInteger)priority type:(NSInteger)type date:(NSDate *)date image:(NSString *)image {
    if (self = [super init]) {
        _title = title;
        _discription = discription;
        _priority = priority;
        _type = type;
        _date = date;
        _image = image;
    }
    return self;
}

@end
