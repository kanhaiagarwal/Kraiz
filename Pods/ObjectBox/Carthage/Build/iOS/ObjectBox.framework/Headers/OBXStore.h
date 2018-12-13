//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>
#import "OBXBox.h"

@class OBXCursorBase;
@class OBXEntityInfo;

NS_ASSUME_NONNULL_BEGIN

// Connection to the on-disk database that manages all transactions.
//
// Use this to obtain a OBXBox (or Swift Box) for each entity type. OBXStore sets up boxes so they can
// obtain transactions from it. Keep the object alive while the app is running.
//
// The modelBytes representation of the schema is the designated initializer you will be
// using until schema files work.

NS_SWIFT_NAME(Store)
/**
 On-disk store of the boxes for your object types.

 In every app, you have to setup a @p Store only once and call @p register for each entity type to set the store up.
 Afterwards, you can obtain @p Box instances with the @p box(for:) methods. These provide the interfaces for
 object persistence.

 The code generator will create a convenience initializer for you to use, with sensible defaults set:\n
 @p init(directoryPath:maxDbSizeInKByte:fileMode:maxReaders:).

 A typical setup sequence looks like this:

 @code
let store = try Store(directoryPath: pathToStoreData)
store.register(entity: Person.self)
let personBox = store.box(for: Person.self)
ler persons = personBox.all()
 @endcode
 */
@interface OBXStore : NSObject

/** The Version of the ObjectBox library. */
@property (nonatomic, readonly) NSString* version NS_REFINED_FOR_SWIFT;

/** The path of the database directory used by the store. */
@property (nonatomic, readonly) NSString* directoryPath NS_REFINED_FOR_SWIFT;

- (instancetype) init __attribute((unavailable));

/**
 @param fileMode File mode in octal (e.g. @p 0755 in Objective-C, @p 0o755 in Swift).
 */
- (nullable instancetype)initWithModelBytes:(NSData *)modelBytes
                                  directory:(NSString *)directory
                           maxDbSizeInKByte:(uint64_t)maxDbSizeInKByte
                                   fileMode:(unsigned int)fileMode
                                 maxReaders:(unsigned int)maxReaders
                                      error:(NSError **)error
  __attribute__((swift_error(null_result)));

- (nullable instancetype)initWithDirectory:(NSString *)directory
                          maxDbSizeInKByte:(uint64_t)maxDbSizeInKByte
                                  fileMode:(unsigned int)fileMode
                                maxReaders:(unsigned int)maxReaders
                                readSchema:(bool)readSchema
                                     error:(NSError**)error
  __attribute__((swift_error(null_result)));

- (void)testUnalignedMemoryAccessAndReturnError:(NSError **)error
  __attribute__((swift_error(nonnull_error)));

- (void)dropAllDataAndReturnError:(NSError **)error
  __attribute__((swift_error(nonnull_error)));

- (void)dropAllSchemasAndDataAndReturnError:(NSError **)error
  __attribute__((swift_error(nonnull_error)));

/**
 @returns Info that can be useful for debugging.
 */
- (NSString*)diagnostics NS_REFINED_FOR_SWIFT;

- (void)registerEntityInfo:(OBXEntityInfo *)entityInfo NS_SWIFT_NAME(register(entityInfo:));

- (OBXBox*)boxFor:(Class)cls NS_SWIFT_NAME(box(entityClass:));
- (OBXBox*)boxForEntityNamed:(NSString *)entityName NS_SWIFT_NAME(box(entityName:));

- (void)runInTransaction:(NS_NOESCAPE void(^)(NSError **error))block error:(NSError **)error NS_SWIFT_NAME(__runInTransaction(_:error:)) NS_REFINED_FOR_SWIFT;
- (void)runInReadOnlyTransaction:(NS_NOESCAPE void(^)(NSError **error))block error:(NSError **)error NS_SWIFT_NAME(__runInReadOnlyTransaction(_:error:)) NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
