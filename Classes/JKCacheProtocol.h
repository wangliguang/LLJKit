//
//  JKCacheProtocol.h
//  JKKit
//
//  Created by Futao on 16/4/1.
//  Copyright © 2016年 Ftkey. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JKCacheProtocol <NSObject>

- (void)dropAllCaches;
- (void)removeObjectForKey:(NSString* __nonnull)key;
- (BOOL)objectExistsForKey:(NSString* __nonnull)key;

- (nullable __kindof NSObject <NSCoding>*)objectForKey:(NSString* __nonnull)key;
- (void)setObject:(nonnull __kindof NSObject <NSCoding>*)anObject forKey:(NSString* __nonnull)key;
- (void)setObject:(nonnull __kindof NSObject <NSCoding>*)anObject forKey:(NSString* __nonnull)key timeoutInterval:(NSTimeInterval)timeoutInterval;

@property (nonatomic, assign, readwrite) NSTimeInterval defaultTimeoutInterval; // Default is 1 day
@end
