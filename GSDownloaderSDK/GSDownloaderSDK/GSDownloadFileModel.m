//
//  GSDownloadFileModel.m
//  GSDownloaderSDKDemo
//
//  Created by Chaoqian Wu on 14-3-6.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import "GSDownloadFileModel.h"

@implementation GSDownloadFileModel

- (id)init
{
    self = [super init];
    if (self) {
        _downloadFileName       = @"";
        _downloadFileAvatorURL  = @"";
        _downloadFinishTime     = @"";
        _downloadFileSize       = [NSNumber numberWithLongLong:0];
        _downloadFileVersion    = @"";
        _downloadTaskURL        = @"";
        _downloadFileSavePath   = @"";
        _downloadTempSavePath   = @"";
        _downloadFilePlistURL   = @"";
    }
    
    return self;
}
@end
