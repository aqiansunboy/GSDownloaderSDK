//
//  GSDownloadTaskQueue.m
//  GSDownloaderSDK
//
//  Created by Chaoqian Wu on 14-3-5.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import "GSDownloadTaskQueue.h"

@implementation GSDownloadTaskQueue

- (id)initWithMaxCapacity:(int)maxCapacity
{
    self = [super init];
    if (self) {
        _maxCapacity = maxCapacity;
        
        _operationQueue = [[NSMutableArray alloc] init];
        
        self.isEmpty = YES;
        self.isFull = NO;
    }
    
    return  self;
}

- (void)enqueue:(id)anObject
{
    @synchronized(_operationQueue)
    {
        if (anObject == nil) {
            return;
        }
        
        //如果超过指定最大容量，则禁止入队
        if (_operationQueue.count == _maxCapacity) {
            return;
        }
        
        //如果队列中已经存在该对象
        if ([_operationQueue containsObject:anObject]) {
            return;
        }
        
        [_operationQueue addObject:anObject];
        
        [self checkQueueEmptyAndFull];
    }
}

- (id)dequeue
{
    @synchronized(_operationQueue)
    {
        if ([_operationQueue count] == 0) {
            return nil;
        }
        
        id queueObject = [_operationQueue objectAtIndex:0];
        [_operationQueue removeObjectAtIndex:0];
        
        [self checkQueueEmptyAndFull];
        
        return queueObject;
    }
}

- (BOOL)empty
{
    @synchronized(_operationQueue)
    {
        return _operationQueue.count == 0;
    }
}

- (BOOL)full
{
    @synchronized(_operationQueue)
    {
        return _operationQueue.count == _maxCapacity;
    }
}

- (void)remove:(id)anObject
{
    @synchronized(_operationQueue)
    {
        [_operationQueue removeObject:anObject];
        
        [self checkQueueEmptyAndFull];
    }
}

/**
 *  检查队列是否空或满
 */
- (void)checkQueueEmptyAndFull
{
    self.isEmpty = ([_operationQueue count] == 0);
    self.isFull = ([_operationQueue count] == _maxCapacity);
}

- (int)queueCount
{
    @synchronized(_operationQueue)
    {
        return (int)_operationQueue.count;
    }
}

- (id)peekAtIndex:(int)index
{
    @synchronized(_operationQueue)
    {
        if (index < 0 || index > _operationQueue.count) {
            return nil;
        }
        
        id queueObject = [_operationQueue objectAtIndex:index];
        
        return queueObject;
    }
}

- (void)clearQueue
{
    @synchronized(_operationQueue)
    {
        [_operationQueue removeAllObjects];
    }
}

@end
