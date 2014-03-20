//
//  GSDownloadTask.m
//  GSDownloaderSDK
//
//  Created by Chaoqian Wu on 14-3-11.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import "GSDownloadTask.h"
#import "NSObject+KVOBlock.h"

@implementation GSDownloadTask
{
    AFHTTPRequestOperation* _downloadOperation;
    
    id<GSDownloadFileModelProtocol> _fileModel;
    
    GSDownloadStatus _downloadStatus;
    
    int _failureCount;
    
    id<GSDownloadUIBindProtocol> _downloadUIBinder;
    
    id _downloadStatusKVO;
}

- (id)init
{
    self = [super init];
    if (self) {
        _downloadStatus = GSDownloadStatusTaskNotCreated;
    }
    
    return self;
}

- (void)initDownloadStatusObserver
{
    __weak id<GSDownloadUIBindProtocol> weakDownloadUIBinder = _downloadUIBinder;
    
    _downloadStatusKVO = [self addKVOBlockForKeyPath:@"downloadStatus" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld handler:^(NSString *keyPath, id object, NSDictionary *change) {
        
        //GSDownloadStatus oldStatusValue = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
        
        GSDownloadStatus newStatusValue = (GSDownloadStatus)[[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        GSDownloadUIStatus uiStatus  = GSDownloadUIStatusTaskNotCreated;
        
        switch (newStatusValue) {
            case GSDownloadStatusWaitingForStart:
                uiStatus = GSDownloadUIStatusWaitingForStart;
                break;
                
            case GSDownloadStatusDownloading:
                uiStatus = GSDownloadUIStatusDownloading;
                break;
                
            case GSDownloadStatusPaused:
                uiStatus = GSDownloadUIStatusPaused;
                break;
                
            case GSDownloadStatusWaitingForResume:
                uiStatus = GSDownloadUIStatusWaitingForResume;
                break;
                
            case GSDownloadStatusCanceled:
                uiStatus = GSDownloadUIStatusCanceled;
                break;
                
            case GSDownloadStatusSuccess:
                uiStatus = GSDownloadUIStatusSuccess;
                break;
                
            case GSDownloadStatusFailure:
                uiStatus = GSDownloadUIStatusFailure;
                break;
                
            default:
                uiStatus = GSDownloadUIStatusWaitingForStart;
                break;
        }
        
        [weakDownloadUIBinder updateUIWhenDownloadStatusChanged:uiStatus];
        
    }];
    
}

#pragma mark - GSSingleDownloadTaskProtocol
- (void)setDownloadOperation:(AFHTTPRequestOperation *)downloadOperation
{
    _downloadOperation = downloadOperation;
}

- (void)startDownloadTask:(void (^)())bindDoSomething
{
    [_downloadOperation start];
    
    if (bindDoSomething)
    {
        bindDoSomething();
    }
}

- (void)pauseDownloadTask:(void (^)())bindDoSomething
{
    [_downloadOperation pause];
    
    if (bindDoSomething)
    {
        bindDoSomething();
    }
}

- (void)continueDownloadTask:(void (^)())bindDoSomething
{
    if ([_downloadOperation isPaused]) {
        [_downloadOperation resume];
    }
    
    if (bindDoSomething)
    {
        bindDoSomething();
    }
}

- (void)cancelDownloadTask:(void (^)())bindDoSomething
{
    [_downloadOperation cancel];
    
    if (bindDoSomething)
    {
        bindDoSomething();
    }
}

- (void)setDownloadFileModel:(id<GSDownloadFileModelProtocol>)fileModel
{
    _fileModel = fileModel;
}

- (id<GSDownloadFileModelProtocol>)getDownloadFileModel
{
    return _fileModel;
}

- (void)setDownloadStatus:(GSDownloadStatus)downloadStatus
{
    _downloadStatus = downloadStatus;
}

- (GSDownloadStatus)getDownloadStatus
{
    return _downloadStatus;
}

- (int)increaseFailureCount
{
    _failureCount++;
    
    return _failureCount;
}

- (void)setDownloadUIBinder:(id<GSDownloadUIBindProtocol>)uiBinder
{
    _downloadUIBinder = uiBinder;
    
    [self initDownloadStatusObserver];
}

- (id<GSDownloadUIBindProtocol>)getDownloadUIBinder
{
    return _downloadUIBinder;
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
    
    [self removeKVOBlockForToken:_downloadStatusKVO];
}

@end
