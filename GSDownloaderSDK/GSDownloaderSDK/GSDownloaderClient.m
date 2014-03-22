//
//  GSDownloaderClient.m
//  GSDownloaderSDK
//
//  Created by Chaoqian Wu on 14-3-5.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import "GSDownloaderClient.h"
#import "GSDownloadTaskQueue.h"
#import "GSFileUtil.h"
#import "NSObject+KVOBlock.h"
#import "GSDownloadFileModel.h"

#define DEFAULT_QUEUE_CAPACITY 6        //默认队列容量
#define DEFAULT_FAITURE_RETRY_CHANCE 6  //默认失败重试机会

@implementation GSDownloaderClient
{
    /**
     *  下载任务列表
     */
    NSMutableArray* _downloadTasks;
    
    /**
     *  下载任务进行队列
     */
    GSDownloadTaskQueue* _taskDoingQueue;
    /**
     *  下载任务队列KVO观察者
     */
    id _taskDoingQueueKVO;
    
    /**
     *  下载任务等待队列
     */
    GSDownloadTaskQueue* _taskWaitingQueue;
    /**
     *  等待队列KVO观察者
     */
    id _taskWaitingQueueKVO;
    
    /**
     *  下载任务暂停队列
     */
    GSDownloadTaskQueue* _taskPausedQueue;
    /**
     *  暂停队列KVO观察者
     */
    id _taskPausedQueueKVO;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        // add by zhenwei
        _downloadTasks = [NSMutableArray array];
        // end
        
        _maxDownload    = DEFAULT_QUEUE_CAPACITY;
        _maxWaiting     = DEFAULT_QUEUE_CAPACITY;
        _maxPaused      = DEFAULT_QUEUE_CAPACITY;
        
        _maxFailureRetryChance = DEFAULT_FAITURE_RETRY_CHANCE;
        
        _taskDoingQueue     = [[GSDownloadTaskQueue alloc] initWithMaxCapacity:_maxDownload];
        _taskWaitingQueue   = [[GSDownloadTaskQueue alloc] initWithMaxCapacity:_maxWaiting];
        _taskPausedQueue    = [[GSDownloadTaskQueue alloc] initWithMaxCapacity:_maxPaused];
        
        //初始下载中队列容量变化观察
        [self initDownloadTaskDoingQueueObserver];
        
    }
    
    return  self;
}

+ (GSDownloaderClient*)sharedDownloaderClient
{
    //用来标记block是否已经执行过
    static dispatch_once_t p = 0;
    
    //初始化，只有第一次执行到
    __strong static id _sharedObject = nil;
    
    //执行对象初始化，程序生命周期内，只执行一次
    dispatch_once(&p, ^{
        _sharedObject = [[GSDownloaderClient alloc] init];
    });
    
    return _sharedObject;
}

- (void)downloadDataAsyncWithTask:(GSDownloadTask*)downloadTask
                             begin:(GSDownloadBeginEventHandler)begin
                          progress:(GSDownloadingEventHandler)progress
                          complete:(GSDownloadedEventHandler)complete
{
    
    if ([_taskWaitingQueue full])
    {
        NSLog(@"等待队列满了，通知客户端达到下载最大限了");
        
        return;
    }
    
    [self beginDownloadTask:downloadTask begin:begin progress:progress complete:complete];
    
}

- (void)beginDownloadTask:(GSDownloadTask*)downloadTask
                            begin:(GSDownloadBeginEventHandler)begin
                         progress:(GSDownloadingEventHandler)progress
                         complete:(GSDownloadedEventHandler)complete
{
    //获取文件模型数据
    GSDownloadFileModel* fileModel = [downloadTask getDownloadFileModel];
    
    if (![self validateFileMetaData:fileModel])
    {
        return;
    }
    
    if (begin)
    {
        begin();
    }
    
    BOOL isResuming = NO;
    
    NSString* dataUrl = [fileModel getDownloadTaskURL];
    // add by zhenwei
    //NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:dataUrl]];
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[dataUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    // end
    
    NSString* tempPath = [fileModel getDownloadTempSavePath];
    
    //获取已下载文件大小，如果不为零，表示可以继续下载
    unsigned long long downloadedBytes = [GSFileUtil fileSizeForPath:tempPath];
    
    NSLog(@"已下载文件大小:%lld",downloadedBytes);
    
    //断点续传
    if (downloadedBytes > 0)
    {
        
        NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
        [urlRequest setValue:requestRange forHTTPHeaderField:@"Range"];
        
        isResuming = YES;
    }
    
    //产生下载请求
    AFHTTPRequestOperation* downloadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    //产生输出流
    downloadOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:tempPath append:isResuming];
    
    //设置完成回调
    [downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //标记下载成功
        [downloadTask setDownloadStatus:GSDownloadStatusSuccess];
        
        //从请求队列中移除
        [_taskDoingQueue dequeue];
        
        //获得下载完成时间
        NSDate* curDate = [NSDate date];
        NSString* downloadFinishTime = [GSDateUtil stringWithDate:curDate withFormat:@"yyyy-MM-dd HH:mm:ss"];
        [fileModel setDownloadFinishTime:downloadFinishTime];
        
        //保存下载完成的文件信息
        NSDictionary* downloadFinishInfo = @{
                                             @"downloadFileName"       : [fileModel getDownloadFileName],
                                             @"downloadFinishTime"     : [fileModel getDownloadFinishTime],
                                             @"downloadFileSize"       : [fileModel getDownloadFileSize],
                                             @"downloadFileSavePath"   : [fileModel getDownloadFileSavePath],
                                             @"downloadFileAvator"     : [fileModel getDownloadFileAvatorURL],
                                             @"downloadFileVersion"    : [fileModel getDownloadFileVersion],
                                             @"downloadFileFromURL"    : [fileModel getDownloadTaskURL],
                                             @"downloadFilePlistURL"   : [fileModel getDownloadFilePlistURL]
                                             };
        
        NSString* finishPlist = [[fileModel getDownloadFileSavePath] stringByAppendingPathExtension:@"plist"];
        if (![downloadFinishInfo writeToFile:finishPlist atomically:YES])
        {
            NSLog(@"%@写入失败",finishPlist);
        }
        
        //将文件从临时目录内剪切到下载目录
        NSString* tempFile = [fileModel getDownloadTempSavePath];
        NSString* saveFile = [fileModel getDownloadFileSavePath];
        [GSFileUtil cutFileAtPath:tempFile toPath:saveFile];
        
        //移除临时plist
        NSString* tempFilePlist = [[fileModel getDownloadTempSavePath] stringByAppendingPathExtension:@"plist"];
        [GSFileUtil deleteFileAtPath:tempFilePlist];
        
        //调用外部回调（比如执行UI更新）
        if (complete) {
            complete(nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //从请求队列中移除
        [_taskDoingQueue dequeue];
        
        int failureCount = [downloadTask increaseFailureCount];
        NSString* tmpPath = [[downloadTask getDownloadFileModel] getDownloadTempSavePath];
        
        NSLog(@"保存路径:%@,失败次数:%d,重试机会:%d",tmpPath,failureCount,self.maxFailureRetryChance);
        
        if (failureCount <= self.maxFailureRetryChance)
        {
            NSLog(@"重试中...");
            //下载失败重新发起下载请求（即重试）
            [self beginDownloadTask:downloadTask begin:begin progress:progress complete:complete];
        }
        else
        {
            NSLog(@"宣告失败...");
            
            [downloadTask setDownloadStatus:GSDownloadStatusFailure];
            
            //调用外部回调（比如执行UI更新），通知UI任务已经失败了
            if (complete) {
                complete(error);
            }
        }
        
    }];
    
    __block NSDate* lastProgressTime = [NSDate date];
    
    //设置下载中回调
    [downloadOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        //计算平均速度
        NSDate* currentDate = [NSDate date];
        NSTimeInterval speedTime = [currentDate timeIntervalSinceDate:lastProgressTime];
        double downloadRate = ((double)totalBytesRead / speedTime);
        NSLog(@"下载速度:%0.1fB/s(totalBytesRead=%lld,speedTime=%f,totalBytesExpectedToRead=%lld)",downloadRate,totalBytesRead,speedTime,totalBytesExpectedToRead);
        
        
        //设置文件大小
        totalBytesExpectedToRead += downloadedBytes;
        NSNumber* fileSize = [NSNumber numberWithLongLong:totalBytesExpectedToRead];
        [fileModel setDownloadFileSize:fileSize];
        
        totalBytesRead += downloadedBytes;
        
        //保存已下载文件大小
        [fileModel setDownloadedFileSize:[NSNumber numberWithLongLong:totalBytesRead]];
        
        //更新临时文件信息
        NSDictionary* downloadTmpInfo = @{
                                          @"downloadFileName"       : [fileModel getDownloadFileName],
                                          @"downloadFileSize"       : [fileModel getDownloadFileSize],
                                          @"downloadedFileSize"     : [fileModel getDownloadedFileSize],
                                          @"downloadFileSavePath"   : [fileModel getDownloadFileSavePath],
                                          @"downloadFileTempPath"   : [fileModel getDownloadTempSavePath],
                                          @"downloadFileAvator"     : [fileModel getDownloadFileAvatorURL],
                                          @"downloadFileVersion"    : [fileModel getDownloadFileVersion]
                                          };
        
        NSString* tempFilePlist = [[fileModel getDownloadTempSavePath] stringByAppendingPathExtension:@"plist"];
        if (![downloadTmpInfo writeToFile:tempFilePlist atomically:YES]) {
            NSLog(@"%@写入失败",tempFilePlist);
        }
        
        //调用外部回调（比如执行UI更新，更新下载进度条等）
        if (progress) {
            progress(bytesRead,totalBytesRead,totalBytesExpectedToRead,downloadRate);
        }
        
    }];
    
    [downloadTask setDownloadOperation:downloadOperation];
    
    [self startOneDownloadTaskWith:downloadTask];
    
}

- (void)startOneDownloadTaskWith:(GSDownloadTask*)downloadTask
{
    [downloadTask setDownloadStatus:GSDownloadStatusWaitingForStart];
    
    if ([_taskDoingQueue full]) //下载队列满了....进入等待队列
    {
        NSLog(@"下载队列满了....进入等待队列.downloadTask = %@",downloadTask);
        
        [_taskWaitingQueue enqueue:downloadTask];
        
    }
    else //将任务推入下载队列，并开启下载
    {
        [_taskDoingQueue enqueue:downloadTask];
        [downloadTask startDownloadTask:^(){
            [downloadTask setDownloadStatus:GSDownloadStatusDownloading];
        }];
    }
}

/**
 *  继续一项下载任务
 *
 *  @param downloadTask 要继续的任务
 */
- (void)doContinueOneDownloadTaskWith:(GSDownloadTask*)downloadTask
{
    
    if ([_taskDoingQueue full]) //下载队列满了....进入等待队列
    {
        NSLog(@"下载队列满了....进入等待队列.downloadTask = %@",downloadTask);
        
        //将处于任务暂停状态的，改为等待回复状态
        if ([downloadTask getDownloadStatus] == GSDownloadStatusPaused)
        {
            [downloadTask setDownloadStatus:GSDownloadStatusWaitingForResume];
        }
        
        [_taskWaitingQueue enqueue:downloadTask];
        
    }
    else //将任务推入下载队列，并恢复下载
    {
        [_taskDoingQueue enqueue:downloadTask];
        
        //暂停的直接恢复
        if ([downloadTask getDownloadStatus] == GSDownloadStatusPaused)
        {
            [downloadTask continueDownloadTask:^(){
                [downloadTask setDownloadStatus:GSDownloadStatusDownloading];
            }];
        }
        //还未启动的需要启动
        else if([downloadTask getDownloadStatus] == GSDownloadStatusWaitingForStart)
        {
            [downloadTask startDownloadTask:^(){
                [downloadTask setDownloadStatus:GSDownloadStatusDownloading];
            }];
        }
        
    }
    
}

- (void)continueOneDownloadTaskWith:(GSDownloadTask*)downloadTask
{
    //从暂停队列中移除掉
    [_taskPausedQueue remove:downloadTask];
    
    [self doContinueOneDownloadTaskWith:downloadTask];

}

/**
 *  暂停一项下载任务
 *
 *  @param downloadTask 要暂停的任务
 */
- (void)doPauseOneDownloadTaskWith:(GSDownloadTask*)downloadTask
{
    if ([downloadTask getDownloadStatus] == GSDownloadStatusDownloading)
    {
        //暂停任务
        [downloadTask pauseDownloadTask:^(){
            [downloadTask setDownloadStatus:GSDownloadStatusPaused];
        }];
    }
    
    //推入暂停队列
    [_taskPausedQueue enqueue:downloadTask];
}

- (void)pauseOneDownloadTaskWith:(GSDownloadTask*)downloadTask
{
    //从下载队列中移除
    [_taskDoingQueue remove:downloadTask];
    
    [self doPauseOneDownloadTaskWith:downloadTask];
}

- (void)doCancelOneDownloadTaskWith:(GSDownloadTask*)downloadTask
{
    //取消任务
    [downloadTask cancelDownloadTask:^(){
        [downloadTask setDownloadStatus:GSDownloadStatusCanceled];
    }];
    
    GSDownloadFileModel* fileModel = [downloadTask getDownloadFileModel];
    
    //移除临时文件
    NSString* tempFile = [fileModel getDownloadTempSavePath];
    [GSFileUtil deleteFileAtPath:tempFile];
    
    //移除临时plist
    NSString* tempFilePlist = [[fileModel getDownloadTempSavePath] stringByAppendingPathExtension:@"plist"];
    [GSFileUtil deleteFileAtPath:tempFilePlist];
}

- (void)cancelOneDownloadTaskWith:(GSDownloadTask*)downloadTask
{
    [self doPauseOneDownloadTaskWith:downloadTask];
    
    //从下载队列中移除
    [_taskDoingQueue remove:downloadTask];
    //从等待队列中移除
    [_taskWaitingQueue remove:downloadTask];
    //从暂停队列中移除
    [_taskPausedQueue remove:downloadTask];
    
    [self doCancelOneDownloadTaskWith:downloadTask];
    
}

- (void)startAllDownloadTask
{
    int taskCount = [_taskPausedQueue queueCount];
    
    for (int i = 0; i < taskCount; i++)
    {
        GSDownloadTask* downloadTask = [_taskPausedQueue peekAtIndex:i];
        
        [self doContinueOneDownloadTaskWith:downloadTask];
    }
    
    [_taskPausedQueue clearQueue];
}

- (void)pauseAllDownloadTask
{
    
    int doingTaskCount = [_taskDoingQueue queueCount];
    for (int i = 0; i < doingTaskCount; i++)
    {
        GSDownloadTask* downloadTask = [_taskDoingQueue peekAtIndex:i];
        
        [self doPauseOneDownloadTaskWith:downloadTask];
    }
    [_taskDoingQueue clearQueue];
    
    int waitingTaskCount = [_taskWaitingQueue queueCount];
    for (int i = 0; i < waitingTaskCount; i++)
    {
        GSDownloadTask* downloadTask = [_taskWaitingQueue peekAtIndex:i];
        
        [self doPauseOneDownloadTaskWith:downloadTask];
    }
    [_taskWaitingQueue clearQueue];
}

- (void)cancelAllDownloadTask
{
    //取消前先暂停
    [self pauseAllDownloadTask];
    
    int pausedTaskCount = [_taskPausedQueue queueCount];
    for (int i = 0; i < pausedTaskCount; i++) {
        
        GSDownloadTask* downloadTask = [_taskPausedQueue peekAtIndex:i];
        
        [self doCancelOneDownloadTaskWith:downloadTask];
    }
    
    [_taskPausedQueue clearQueue];
    
}

- (void)testQueueKVO
{
 
    NSString* test = @"我是一个测试";
    
    _taskDoingQueue.maxCapacity = 100;
    
    [_taskDoingQueue enqueue:test];
    [_taskDoingQueue enqueue:test];
    
    [_taskDoingQueue dequeue];
    [_taskDoingQueue dequeue];
    
}

- (void)setMaxDownload:(int)maxDownload
{
    _maxDownload = maxDownload;
    _taskDoingQueue.maxCapacity = _maxDownload;
    
}

// add by zhenwei
-(void)addDownloadTask:(GSDownloadTask*)task
{
    [_downloadTasks addObject:task];
}

-(NSArray*)downloadTasks
{
    return _downloadTasks;
}
// end

- (void)setMaxWaiting:(int)maxWaiting
{
    _maxWaiting = maxWaiting;
    _taskWaitingQueue.maxCapacity = _maxWaiting;
}

- (void)setMaxPaused:(int)maxPaused
{
    _maxPaused = maxPaused;
    
    _taskPausedQueue.maxCapacity = _maxPaused;
}

#pragma mark - Utilies
/**
 *  初始化下载队列观察者
 *
 *  @param queue
 */
- (void)initDownloadTaskDoingQueueObserver
{    
    __weak GSDownloadTaskQueue* weakWaitingQueue = _taskWaitingQueue;
    __weak GSDownloadTaskQueue* weakOperationQueue = _taskDoingQueue;
    
    _taskDoingQueueKVO = [_taskDoingQueue addKVOBlockForKeyPath:@"isFull" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld handler:^(NSString *keyPath, id object, NSDictionary *change) {
        
        BOOL isFullOldValue = [[change objectForKey:NSKeyValueChangeOldKey] boolValue];
        BOOL isFullNewValue = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        
        NSLog(@"I see you changed value from \"%@\" to \"%@\" (下载队列)", isFullOldValue ? @"YES" : @"NO", isFullNewValue ? @"YES" : @"NO");
        
        if (isFullOldValue == isFullNewValue && isFullNewValue == YES) {
            return;
        }
        
        //只要下载队列不为空，就从下载等待队列中取出任务，进行下载
        if (isFullNewValue == NO)
        {
            
            GSDownloadTask* downloadTask = (id<GSSingleDownloadTaskProtocol>)[weakWaitingQueue dequeue];
            
            //开始下载任务
            if (downloadTask != nil) {
                
                [weakOperationQueue enqueue:downloadTask];
                
                if ([downloadTask getDownloadStatus] == GSDownloadStatusWaitingForStart) //开始下载
                {
                    [downloadTask startDownloadTask:^(){
                        [downloadTask setDownloadStatus:GSDownloadStatusDownloading];
                    }];
                }
                else if([downloadTask getDownloadStatus] == GSDownloadStatusWaitingForResume) //恢复下载
                {
                    [downloadTask continueDownloadTask:^(){
                        [downloadTask setDownloadStatus:GSDownloadStatusDownloading];
                    }];
                }
                
                
            }
            else
            {
                NSLog(@"下载等待队列为空....");
            }
            
        }
        
        
    }];
}

/**
 *  验证下载文件元数据是否都合法
 *
 *  @param fileModel
 *
 *  @return
 */
- (BOOL)validateFileMetaData:(GSDownloadFileModel*)fileModel
{
    // TODO
    return YES;
}

#pragma mark - dealloc
- (void)dealloc
{
    [_taskDoingQueue removeKVOBlockForToken:_taskDoingQueueKVO];
}

@end
