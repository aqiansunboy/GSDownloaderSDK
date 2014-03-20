//
//  GSFileUtil.h
//  GSDownloaderSDK
//
//  Created by Chaoqian Wu on 14-3-5.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  文件工具类
 */
@interface GSFileUtil : NSObject

/**
 *  获取文件大小
 *
 *  @param path 文件路径
 *
 *  @return 文件大小
 */
+ (unsigned long long)fileSizeForPath:(NSString*)path;

/**
 *  获取指定文件的临时文件存放路径
 *
 *  @param path     文件路径
 *  @param saveIn   文件保存子路径
 *
 *  @return 临时文件路径
 */
+ (NSString*)tempPathFor:(NSString*)path saveIn:(NSString*)saveIn;

/**
 *  获取Documents文件夹内子文件夹的路径
 *
 *  @param subFolder   子文件夹路径
 *  @param needCeate 如果不存在，是否需要创建
 *
 *  @return
 */
+ (NSString*)getPathInDocumentsDirBy:(NSString*)subFolder createIfNotExist:(BOOL)needCeate;

/**
 *  获取Cache文件夹内子文件夹的路径
 *
 *  @param subFolder   子文件夹路径
 *  @param needCeate 如果不存在，是否需要创建
 *
 *  @return
 */
+ (NSString*)getPathInCacheDirBy:(NSString*)subFolder createIfNotExist:(BOOL)needCeate;

/**
 *  判断指定路径下的文件是否存在
 *
 *  @param path
 *
 *  @return
 */
+ (BOOL)fileExistsAtPath:(NSString*)path;

/**
 *  删除指定路径下的文件
 *
 *  @param path
 *
 *  @return
 */
+ (BOOL)deleteFileAtPath:(NSString*)path;

/**
 *  将指定文件剪切到指定位置
 *
 *  @param srcPath 源文件地址
 *  @param dstPath 目标文件地址
 *
 *  @return
 */
+ (BOOL)cutFileAtPath:(NSString*)srcPath toPath:(NSString*)dstPath;

@end
