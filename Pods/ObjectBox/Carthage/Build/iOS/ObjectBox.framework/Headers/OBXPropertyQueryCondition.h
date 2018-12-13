//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "OBXQueryCondition.h"

NS_REFINED_FOR_SWIFT
@interface OBXPropertyQueryCondition : OBXQueryCondition

@property (nonatomic, readwrite, strong) OBXPropertyAlias * _Nonnull alias;

- (nonnull instancetype)init __attribute((unavailable));

@end
