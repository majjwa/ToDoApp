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
@property NSString* name;
@property NSString* discription;
@property (nonatomic, assign) NSInteger periority;
@property (nonatomic, assign) NSInteger type;
//@property NSString* imgTodo;


@property NSDate* date;
-(void) encodeWithCoder:(NSCoder *)encoder;
-(id) initWithCoder:(NSCoder *)deccoder;
-(instancetype) initWithName:(NSString *)name AndPrice :(int)price;

@end

NS_ASSUME_NONNULL_END

