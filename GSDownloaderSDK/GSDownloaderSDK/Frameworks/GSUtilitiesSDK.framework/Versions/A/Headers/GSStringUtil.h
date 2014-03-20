//
//  GSStringUtil.h
//  GSCoreCommon
//
//  Created by Chaoqian Wu on 13-12-16.
//  Copyright (c) 2013年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSStringUtil : NSObject

/**
 *  获取字符串的实际长度，比如123的实际长度为3，123呵的实际长度为5
 *
 *  @param string 字符串
 *
 *  @return 实际长度
 */
+ (int)getStringRealLength:(NSString*)string;

/**
 *  从itunesUrl解析出来
 *
 *  @param itunesUrl 应用在AppStore的地址
 *
 *  @return
 */
+ (NSString*)parseAppIdFromItunesURL:(NSString*)itunesUrl;

/**
 *  判断是否为空字符串
 *
 *  @param string 需要判断的字符串
 *
 *  @return
 */
+ (BOOL)isEmptyString:(NSString*)string;

@end
