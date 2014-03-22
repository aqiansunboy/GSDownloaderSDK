//
//  GSSingleDownloadTaskProtocol.h
//  GSDownloaderSDK
//
//  Created by Chaoqian Wu on 14-3-6.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  标记任务下载状态
 */
typedef enum
{
    GSDownloadStatusTaskNotCreated = 0,       //任务还未创建（默认状态）
    GSDownloadStatusWaitingForStart,         //等待启动
    GSDownloadStatusDownloading,             //下载中
    GSDownloadStatusPaused,                  //被暂停
    GSDownloadStatusWaitingForResume,        //等待恢复
    GSDownloadStatusCanceled,                //被取消
    GSDownloadStatusSuccess,                 //下载成功
    GSDownloadStatusFailure                 //下载失败
    
} GSDownloadStatus;

/**
 *  定义一项下载任务接口，用于建立起对应的每款游戏下载任务，并进行对应任务的管理
 */
@protocol GSSingleDownloadTaskProtocol <NSObject>

@required

/**
 *  保存下载请求操作
 *
 *  @param downloadOperation
 */
- (void)setDownloadOperation:(AFHTTPRequestOperation*)downloadOperation;

/**
 *  开始一条下载任务
 *
 *  @param bindDoSomething 附带执行的捆绑操作
 */
- (void)startDownloadTask:(void (^)())bindDoSomething;

/**
 *  暂停一条下载任务
 *
 *  @param bindDoSomething 附带执行的捆绑操作
 */
- (void)pauseDownloadTask:(void (^)())bindDoSomething;

/**
 *  继续一条下载任务
 *
 *  @param bindDoSomething
 */
- (void)continueDownloadTask:(void (^)())bindDoSomething;

/**
 *  取消一条下载任务
 *
 *  @param bindDoSomething 附带执行的捆绑操作
 */
- (void)cancelDownloadTask:(void (^)())bindDoSomething;

/**
 *  标记失败次数增1
 *
 *  @return 返回已失败次数
 */
- (int)increaseFailureCount;


@end
