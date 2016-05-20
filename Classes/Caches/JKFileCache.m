//
//  JKFileCache.m
//  JKKit
//
//  Created by Futao on 16/4/1.
//  Copyright © 2016年 Ftkey. All rights reserved.
//

#import "JKFileCache.h"

static NSString* JKFileCachePlistName = @"JKFileCache";

#pragma mark -

@interface JKFileCache () {
    dispatch_queue_t _cacheInfoQueue;
    dispatch_queue_t _frozenCacheInfoQueue;
    dispatch_queue_t _diskQueue;
    NSMutableDictionary* _cacheInfo;
    NSString* _directory;
    BOOL _needsSave;
    NSTimeInterval _defaultTimeoutInterval;
}

@property (nonatomic, copy) NSDictionary* frozenCacheInfo;
@end

@implementation JKFileCache
@synthesize defaultTimeoutInterval = _defaultTimeoutInterval;

+ (instancetype)defaultCache
{
    static id instance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });

    return instance;
}
- (void)__initWithCacheDirectory:(NSString*)cacheDirectory
{
    _cacheInfoQueue = dispatch_queue_create("cn.jksoft.kit.filecache", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_set_target_queue(priority, _cacheInfoQueue);

    _frozenCacheInfoQueue = dispatch_queue_create("cn.jksoft.kit.filecache.frozen", DISPATCH_QUEUE_SERIAL);
    priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_set_target_queue(priority, _frozenCacheInfoQueue);

    _diskQueue = dispatch_queue_create("cn.jksoft.kit.filecache.disk", DISPATCH_QUEUE_CONCURRENT);
    priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_set_target_queue(priority, _diskQueue);

    _directory = cacheDirectory;

    _cacheInfo = [[NSDictionary dictionaryWithContentsOfFile:cachePathForKey(_directory, JKFileCachePlistName)] mutableCopy];

    if (!_cacheInfo) {
        _cacheInfo = [[NSMutableDictionary alloc] init];
    }

    [[NSFileManager defaultManager] createDirectoryAtPath:_directory withIntermediateDirectories:YES attributes:nil error:NULL];

    NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
    NSMutableArray* removedKeys = [[NSMutableArray alloc] init];

    for (NSString* key in _cacheInfo) {
        if ([_cacheInfo[key] timeIntervalSinceReferenceDate] <= now) {
            [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(_directory, key) error:NULL];
            [removedKeys addObject:key];
        }
    }

    [_cacheInfo removeObjectsForKeys:removedKeys];
    self.frozenCacheInfo = _cacheInfo;
    _defaultTimeoutInterval = 86400;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _defaultTimeoutInterval = 86400;
        NSString* cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString* oldCachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:JKFileCachePlistName] copy];

        if ([[NSFileManager defaultManager] fileExistsAtPath:oldCachesDirectory]) {
            [[NSFileManager defaultManager] removeItemAtPath:oldCachesDirectory error:NULL];
        }
        cachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:JKFileCachePlistName] copy];
        [self __initWithCacheDirectory:cachesDirectory];
    }

    return self;
}

- (instancetype)initWithCacheDirectory:(NSString*)cacheDirectory
{
    if ((self = [super init])) {
        [self __initWithCacheDirectory:cacheDirectory];
    }
    return self;
}

- (void)dropAllCaches
{
    dispatch_sync(_cacheInfoQueue, ^{
        for (NSString* key in _cacheInfo) {
            [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(_directory, key) error:NULL];
        }

        [_cacheInfo removeAllObjects];

        dispatch_sync(_frozenCacheInfoQueue, ^{
            self.frozenCacheInfo = [_cacheInfo copy];
        });

        [self setNeedsSave];
    });
}

- (void)removeObjectForKey:(NSString*)key
{
    if ([key isEqualToString:JKFileCachePlistName])
        return;

    dispatch_sync(_diskQueue, ^{
        [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(_directory, key) error:NULL];
    });

    [self setCacheTimeoutInterval:0 forKey:key];
}

- (BOOL)objectExistsForKey:(NSString*)key
{
    NSDate* date = [self dateForKey:key];
    if (date == nil)
        return NO;
    if ([date timeIntervalSinceReferenceDate] < CFAbsoluteTimeGetCurrent())
        return NO;

    return [[NSFileManager defaultManager] fileExistsAtPath:cachePathForKey(_directory, key)];
}

- (NSDate*)dateForKey:(NSString*)key
{
    __block NSDate* date = nil;

    dispatch_sync(_frozenCacheInfoQueue, ^{
        date = (self.frozenCacheInfo)[key];
    });

    return date;
}

- (NSArray*)allKeys
{
    __block NSArray* keys = nil;

    dispatch_sync(_frozenCacheInfoQueue, ^{
        keys = [self.frozenCacheInfo allKeys];
    });

    return keys;
}

- (NSData*)dataForKey:(NSString*)key
{
    if ([self objectExistsForKey:key]) {
        return [NSData dataWithContentsOfFile:cachePathForKey(_directory, key) options:0 error:NULL];
    }
    else {
        return nil;
    }
}
#pragma mark -
#pragma mark Object methods

- (__kindof NSObject <NSCoding>*)objectForKey:(NSString*)key
{
    if ([self objectExistsForKey:key]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForKey:key]];
    }
    else {
        return nil;
    }
}

- (void)setObject:(__kindof NSObject <NSCoding>*)anObject forKey:(NSString*)key
{
    [self setObject:anObject forKey:key timeoutInterval:self.defaultTimeoutInterval];
}

- (void)setObject:(__kindof NSObject <NSCoding>*)anObject forKey:(NSString*)key timeoutInterval:(NSTimeInterval)timeoutInterval
{
    [self setData:[NSKeyedArchiver archivedDataWithRootObject:anObject] forKey:key timeoutInterval:timeoutInterval];
}

- (void)setData:(NSData*)data forKey:(NSString*)key timeoutInterval:(NSTimeInterval)timeoutInterval
{
    if ([key isEqualToString:JKFileCachePlistName])
        return;

    NSString* cachePath = cachePathForKey(_directory, key);

    dispatch_sync(_diskQueue, ^{
        [data writeToFile:cachePath atomically:YES];
    });

    [self setCacheTimeoutInterval:timeoutInterval forKey:key];
}

- (void)setCacheTimeoutInterval:(NSTimeInterval)timeoutInterval forKey:(NSString*)key
{
    NSDate* date = timeoutInterval > 0 ? [NSDate dateWithTimeIntervalSinceNow:timeoutInterval] : nil;

    // Temporarily store in the frozen state for quick reads
    dispatch_sync(_frozenCacheInfoQueue, ^{
        NSMutableDictionary* info = [self.frozenCacheInfo mutableCopy];

        if (date) {
            info[key] = date;
        }
        else {
            [info removeObjectForKey:key];
        }

        self.frozenCacheInfo = info;
    });

    // Save the final copy (this may be blocked by other operations)
    dispatch_async(_cacheInfoQueue, ^{
        if (date) {
            _cacheInfo[key] = date;
        }
        else {
            [_cacheInfo removeObjectForKey:key];
        }

        dispatch_sync(_frozenCacheInfoQueue, ^{
            self.frozenCacheInfo = [_cacheInfo copy];
        });

        [self setNeedsSave];
    });
}
- (void)setNeedsSave
{
    dispatch_async(_cacheInfoQueue, ^{
        if (_needsSave)
            return;
        _needsSave = YES;

        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, _cacheInfoQueue, ^(void) {
            if (!_needsSave)
                return;
            [_cacheInfo writeToFile:cachePathForKey(_directory, JKFileCachePlistName) atomically:YES];
            _needsSave = NO;
        });
    });
}
static inline NSString* cachePathForKey(NSString* directory, NSString* key)
{
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return [directory stringByAppendingPathComponent:key];
}

@end
