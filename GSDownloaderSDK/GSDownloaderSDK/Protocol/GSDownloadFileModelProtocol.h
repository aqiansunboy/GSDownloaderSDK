//
//  GSDownloadFileModelProtocol.h
//  GSDownloaderSDK
//
//  Created by Chaoqian Wu on 14-3-6.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GSDownloadFileModelProtocol <NSObject>

@required

/**
 *  设置下载文件名
 *
 *  @param fileName
 */
- (void)setDownloadFileName:(NSString*)fileName;
/**
 *  获取下载文件名
 *
 *  @return
 */
- (NSString*)getDownloadFileName;


/**
 *  设置下载文件的图片缩略图地址
 *
 *  @param avatorUrl
 */
- (void)setDownloadFileAvatorURL:(NSString *)avatorUrl;
/**
 *  获取下载文件的图片缩略图地址
 *
 *  @return
 */
- (NSString*)getDownloadFileAvatorURL;


/**
 *  设置下载完成时间
 *
 *  @param finishTime
 */
- (void)setDownloadFinishTime:(NSString*)finishTime;
/**
 *  获取下载结束时间
 *
 *  @return
 */
- (NSString*)getDownloadFinishTime;


/**
 *  设置下载文件大小
 *
 *  @param fileSize
 */
- (void)setDownloadFileSize:(NSNumber*)fileSize;
/**
 *  获取下载文件大小
 *
 *  @return
 */
- (NSNumber*)getDownloadFileSize;

/**
 *  设置已下载文件大小
 *
 *  @param fileSize
 */
- (void)setDownloadedFileSize:(NSNumber*)fileSize;
/**
 *  获取已下载文件大小
 *
 *  @return
 */
- (NSNumber*)getDownloadedFileSize;


/**
 *  设置文件版本号
 *
 *  @param fileVersion
 */
- (void)setDownloadFileVersion:(NSString*)fileVersion;
/**
 *  获取文件版本号
 *
 *  @return
 */
- (NSString*)getDownloadFileVersion;


/**
 *  设置下载网络地址
 *
 *  @param taskUrl
 */
- (void)setDownloadTaskURL:(NSString*)taskUrl;
/**
 *  获取下载网络地址
 *
 *  @return
 */
- (NSString*)getDownloadTaskURL;


/**
 *  设置文件下载路径
 *
 *  @param fileSavePath
 */
- (void)setDownloadFileSavePath:(NSString*)fileSavePath;
/**
 *  获取文件下载路径
 *
 *  @return
 */
- (NSString*)getDownloadFileSavePath;


/**
 *  设置文件临时路径
 *
 *  @param fileTempPath
 */
- (void)setDownloadTempSavePath:(NSString*)fileTempPath;
/**
 *  获取文件临时路径
 *
 *  @return
 */
- (NSString*)getDownloadTempSavePath;


/**
 *  设置对应游戏服务器plist文件地址（用于后续安装游戏）
 *
 *  @param plistURL
 */
- (void)setDownloadFilePlistURL:(NSString*)plistURL;
/**
 *  对应游戏服务器plist文件地址（用于后续安装游戏）
 *
 *  @return
 */
- (NSString*)getDownloadFilePlistURL;

@end
