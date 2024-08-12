//
//  Tasks.h
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tasks : NSObject<NSSecureCoding, NSCoding>

@property NSString* image;
@property NSString* title;
@property NSString* discription;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) NSInteger type;
@property NSDate* date;

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;
- (instancetype)initWithTitle:(NSString *)title description:(NSString *)description priority:(NSInteger)priority type:(NSInteger)type date:(NSDate *)date image:(NSString *)image;

@end

NS_ASSUME_NONNULL_END
