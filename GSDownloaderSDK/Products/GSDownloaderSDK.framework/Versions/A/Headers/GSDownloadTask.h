//
//  GSDownloadTask.h
//  GSDownloaderSDK
//
//  Created by Chaoqian Wu on 14-3-11.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSSingleDownloadTaskProtocol.h"

/**
 *  实现下载任务（依赖GSSingleDownloadTaskProtocol协议）
 *  外部使用前，需要指定下载文件模型(实现GSDownloadFileModelProtocol接口)和关联的UI对象(实现GSDownloadUIBindProtocol)
 */
@interface GSDownloadTask : NSObject <GSSingleDownloadTaskProtocol>

@property (nonatomic) GSDownloadStatus downloadStatus;

@end
