//
//  GSDownloadUIBindProtocol.h
//  GSDownloaderSDK
//
//  Created by Chaoqian Wu on 14-3-10.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GSSingleDownloadTaskProtocol;


/**
 *  用于绑定外部UI更新操作的接口
 */
@protocol GSDownloadUIBindProtocol <NSObject>

@required

/**
 *  根据任务状态改变UI
 *
 *  @param downloadTask
 */
- (void)updateUIWithTask:(id<GSSingleDownloadTaskProtocol>)downloadTask;

@end
