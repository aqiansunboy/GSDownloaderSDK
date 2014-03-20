//
//  GSDownloadUIBindProtocol.h
//  GSDownloaderSDK
//
//  Created by Chaoqian Wu on 14-3-10.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  标记下载UI对应状态
 */
typedef enum
{
    GSDownloadUIStatusTaskNotCreated = 0,       //任务还未创建（默认状态）
    GSDownloadUIStatusWaitingForStart,         //等待启动
    GSDownloadUIStatusDownloading,             //下载中
    GSDownloadUIStatusPaused,                  //被暂停
    GSDownloadUIStatusWaitingForResume,        //等待恢复
    GSDownloadUIStatusCanceled,                //被取消
    GSDownloadUIStatusSuccess,                 //下载成功
    GSDownloadUIStatusFailure                 //下载失败
    
} GSDownloadUIStatus;

/**
 *  用于绑定外部UI更新操作的接口
 */
@protocol GSDownloadUIBindProtocol <NSObject>

/**
 *  通知外部UI做下载状态处理变化相关的UI更新
 */
- (void)updateUIWhenDownloadStatusChanged:(GSDownloadUIStatus)downloadUIStatus;

/**
 *  通知外部UI做下载进度变化相关的UI更新
 *
 *  @param bytesRead                一次读多少字节
 *  @param totalBytesRead           已读多少字节
 *  @param totalBytesExpectedToRead 总共需要多少字节需要读取
 *  @param bytesPerSecond           实时下载速度(Bytes/s)
 */
- (void)updateUIWhenDownloadProgressChanged:(NSUInteger)bytesRead totalBytesRead:(long long)totalBytesRead totalBytesExpectedToRead:(long long)totalBytesExpectedToRead bytesPerSecond:(double)bytesPerSecond;

/**
 *  通知外部UI做下载成功相关的UI更新
 */
- (void)updateUIWhenDownloadSuccessful;

/**
 *  通知外部UI做下载失败相关的UI更新
 */
- (void)updateUIDownloadFail;

@end
