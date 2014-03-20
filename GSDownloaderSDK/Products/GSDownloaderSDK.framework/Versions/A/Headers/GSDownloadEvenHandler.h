//
//  GSDownloadEvenHandler.h
//  GSCoreCommon
//
//  Created by Chaoqian Wu on 14-2-26.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#ifndef GSCoreCommon_GSDownloadEvenHandler_h
#define GSCoreCommon_GSDownloadEvenHandler_h

/**
 *  异步下载开始前，执行自定义的事件
 *
 *  @return
 */
typedef void (^GSDownloadBeginEventHandler) ();

/**
 *  异步下载中，执行自定义的事件
 *
 *  @param bytesRead                距离上次执行后又下载了多少字节
 *  @param totalBytesRead           已经下载了多少字节
 *  @param totalBytesExpectedToRead 总共需要下载多少字节
 *  @param bytesPerSecond           实时下载速度(Bytes/s)
 *
 *  @return
 */
typedef void (^GSDownloadingEventHandler) (NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead,double bytesPerSecond);

/**
 *  异步下载结束后，执行自定义的事件
 *
 *  @param error 错误对象（如果成功，error传nil）
 *
 *  @return
 */
typedef void (^GSDownloadedEventHandler) (NSError* error );

#endif
