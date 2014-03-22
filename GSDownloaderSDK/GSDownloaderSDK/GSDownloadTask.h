//
//  GSDownloadTask.h
//  GSDownloaderSDK
//
//  Created by Chaoqian Wu on 14-3-11.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSSingleDownloadTaskProtocol.h"
#import "GSDownloadFileModel.h"
#import "GSDownloadUIBindProtocol.h"

/**
 *  实现下载任务（依赖GSSingleDownloadTaskProtocol协议）
 *  外部使用前，需要指定下载文件模型(实现GSDownloadFileModelProtocol接口)和关联的UI对象(实现GSDownloadUIBindProtocol)
 */
@interface GSDownloadTask : NSObject <GSSingleDownloadTaskProtocol>

@property (nonatomic,getter = getDownloadStatus) GSDownloadStatus downloadStatus;

// add by zhenwei
@property (nonatomic) NSUInteger bytesRead;

@property (nonatomic) long long totalBytesRead;

@property (nonatomic) long long totalBytesExpectedToRead;

@property (nonatomic) double bytesPerSecond;

@property (nonatomic,strong,getter = getDownloadTaskId) NSString* downloadTaskId;

@property (nonatomic,strong,getter = getDownloadFileModel) GSDownloadFileModel* downloadFileModel;

@property (nonatomic,strong,getter = getDownloadUIBinder) id<GSDownloadUIBindProtocol> downloadUIBinder;
// end

- (BOOL)isEqualToDownloadTask:(GSDownloadTask*)downloadTask;

@end
