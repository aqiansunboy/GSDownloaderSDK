//
//  MTDDownloadFileModel.m
//  GSDownloaderSDKDemo
//
//  Created by Chaoqian Wu on 14-3-6.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import "MTDDownloadFileModel.h"

@implementation MTDDownloadFileModel
{
    NSString* _downloadFileName;
    
    NSString* _downloadFileAvatorURL;
    
    NSString* _downloadFinishTime;
    
    NSNumber* _downloadFileSize;
    
    NSNumber* _downloadedFileSize;
    
    NSString* _downloadFileVersion;
    
    NSString* _downloadTaskURL;
    
    NSString* _downloadFileSavePath;
    
    NSString* _downloadTempSavePath;
    
    NSString* _downloadFilePlistURL;
}

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

#pragma mark - GSDownloadFileModelProtocol
- (void)setDownloadFileName:(NSString*)fileName
{
    _downloadFileName = fileName;
}
- (NSString*)getDownloadFileName
{
    return _downloadFileName;
}

- (void)setDownloadFileAvatorURL:(NSString *)avatorUrl
{
    _downloadFileAvatorURL = avatorUrl;
}
- (NSString*)getDownloadFileAvatorURL
{
    return _downloadFileAvatorURL;
}

- (void)setDownloadFinishTime:(NSString*)finishTime
{
    _downloadFinishTime = finishTime;
}
- (NSString*)getDownloadFinishTime
{
    return _downloadFinishTime;
}

- (void)setDownloadFileSize:(NSNumber*)fileSize
{
    _downloadFileSize = fileSize;
}
- (NSNumber*)getDownloadFileSize
{
    return _downloadFileSize;
}

- (void)setDownloadedFileSize:(NSNumber*)fileSize
{
    _downloadedFileSize = fileSize;
}
- (NSNumber*)getDownloadedFileSize
{
    return _downloadedFileSize;
}

- (void)setDownloadFileVersion:(NSString*)fileVersion
{
    _downloadFileVersion = fileVersion;
}
- (NSString*)getDownloadFileVersion
{
    return _downloadFileVersion;
}

- (void)setDownloadTaskURL:(NSString*)taskUrl
{
    _downloadTaskURL = taskUrl;
}
- (NSString*)getDownloadTaskURL
{
    return _downloadTaskURL;
}

/**
 *  需要指定完整文件路径
 *
 *  @param fileSavePath
 */
- (void)setDownloadFileSavePath:(NSString*)fileSavePath
{
    _downloadFileSavePath = fileSavePath;
}
- (NSString*)getDownloadFileSavePath
{
    return _downloadFileSavePath;
}

/**
 *  需要指定完整文件路径
 *
 *  @param fileTempPath
 */
- (void)setDownloadTempSavePath:(NSString*)fileTempPath
{
    _downloadTempSavePath = fileTempPath;
}
- (NSString*)getDownloadTempSavePath
{
    return _downloadTempSavePath;
}

- (void)setDownloadFilePlistURL:(NSString*)plistURL
{
    _downloadFilePlistURL = plistURL;
}
- (NSString*)getDownloadFilePlistURL
{
    return _downloadFilePlistURL;
}

@end
