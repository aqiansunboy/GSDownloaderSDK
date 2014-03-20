//
//  MTDDownloadTableViewCellDelegate.h
//  GSDownloaderSDKDemo
//
//  Created by Chaoqian Wu on 14-3-10.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTDDownloadTableViewCellDelegate <NSObject>

@required

- (void)startDownloadAtIndex:(int)index;

@end
