//
//  GSDownloaderClient.h
//  GSDownloaderSDK
//
//  Created by Chaoqian Wu on 14-3-5.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSDownloadEvenHandler.h"
#import "GSSingleDownloadTaskProtocol.h"
#import "GSDownloadFileModelProtocol.h"
#import "GSDownloadUIBindProtocol.h"

/**
 *  下载客户端类
 *  
 */
@interface GSDownloaderClient : NSObject

/**
 *  获取单例下载客户端
 *
 *  @return
 */
+ (GSDownloaderClient*)sharedDownloaderClient;

/**
 *  指定最高下载队列容量数
 */
@property (nonatomic) int maxDownload;

/**
 *  指定最高等待队列容量数
 */
@property (nonatomic) int maxWaiting;

/**
 *  指定最高暂停队列容量数
 */
@property (nonatomic) int maxPaused;

/**
 *  指定最高重试机会
 */
@property (nonatomic) int maxFailureRetryChance;

/**
 *  开始一次下载任务（都统一先放进等待队列）
 *
 *  @param downloadTask    一条下载任务
 *  @param begin           下载开始前回调
 *  @param progress        处理下载中回调
 *  @param complete        完成回调
 */
- (void)downloadDataAsyncWithTask:(id<GSSingleDownloadTaskProtocol>)downloadTask
                             begin:(GSDownloadBeginEventHandler)begin
                          progress:(GSDownloadingEventHandler)progress
                          complete:(GSDownloadedEventHandler)complete;

/**
 *  继续一条下载任务
 *
 *  @param downloadTask 指定下载任务
 */
- (void)continueOneDownloadTaskWith:(id<GSSingleDownloadTaskProtocol>)downloadTask;

/**
 *  暂停一条下载任务
 *
 *  @param downloadTask 指定下载任务
 */
- (void)pauseOneDownloadTaskWith:(id<GSSingleDownloadTaskProtocol>)downloadTask;

/**
 *  取消一条下载任务
 *
 *  @param downloadTask 指定下载任务
 */
- (void)cancelOneDownloadTaskWith:(id<GSSingleDownloadTaskProtocol>)downloadTask;

/**
 *  开始全部下载任务
 */
- (void)startAllDownloadTask;

/**
 *  暂停全部下载任务
 */
- (void)pauseAllDownloadTask;

/**
 *  取消全部下载任务
 */
- (void)cancelAllDownloadTask;

/**
 *  测试队列KVO是否有效
 */
- (void)testQueueKVO;

@end
