//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
NS_SWIFT_NAME(EntityInfo)
@interface OBXEntityInfo : NSObject

@property (nonatomic, copy, readonly) NSString *entityName;
@property (nonatomic, assign, readwrite) Class cursorClass;

- (instancetype)init __attribute__((unavailable));
- (nonnull instancetype)initWithName:(NSString *)entityName cursorClass:(Class)cursorClass;
+ (instancetype)entityInfoWithName:(NSString *)entityName cursorClass:(Class)cursorClass;

@end
NS_ASSUME_NONNULL_END
