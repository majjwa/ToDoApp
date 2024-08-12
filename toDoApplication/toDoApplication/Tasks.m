#import "Tasks.h"

@interface Tasks () <NSSecureCoding>
@end

@implementation Tasks

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.discription forKey:@"discription"];
    [encoder encodeInteger:self.priority forKey:@"priority"];
    [encoder encodeInteger:self.type forKey:@"type"];
    [encoder encodeObject:self.date forKey:@"date"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _image = [decoder decodeObjectOfClass:[NSString class] forKey:@"image"];
        _title = [decoder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _discription = [decoder decodeObjectOfClass:[NSString class] forKey:@"discription"];
        _priority = [decoder decodeIntegerForKey:@"priority"];
        _type = [decoder decodeIntegerForKey:@"type"];
        _date = [decoder decodeObjectOfClass:[NSDate class] forKey:@"date"];
    }
    return self;
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
