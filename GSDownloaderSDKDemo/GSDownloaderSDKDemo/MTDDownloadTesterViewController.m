//
//  MTDDownloadTesterViewController.m
//  GSDownloaderSDKDemo
//
//  Created by Chaoqian Wu on 14-3-5.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import "MTDDownloadTesterViewController.h"
#import "MTDDownloadFileModel.h"
#import "MTDDownloadTableViewCell.h"

@interface MTDDownloadTesterViewController ()
{
    UIButton* _startDownloadBtn;
    
    UIButton* _pauseDownloadBtn;
    
    UIButton* _continueDownloadBtn;
    
    UIButton* _cancelBtn;
    
    GSDownloaderClient* _client;
    
    int _downdloadCount;
    
    NSMutableArray* _downloadTasks;
    
    //任务表格视图
    UITableView* _downloadTaskTableView;
}

@end

@implementation MTDDownloadTesterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _downloadTasks = [[NSMutableArray alloc] init];
        
        _startDownloadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _startDownloadBtn.backgroundColor = [UIColor yellowColor];
        [_startDownloadBtn setTitle:@"添加下载" forState:UIControlStateNormal];
        [_startDownloadBtn addTarget:self action:@selector(addDownload) forControlEvents:UIControlEventTouchUpInside];
        
        _pauseDownloadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _pauseDownloadBtn.backgroundColor = [UIColor yellowColor];
        [_pauseDownloadBtn setTitle:@"全部暂停" forState:UIControlStateNormal];
        [_pauseDownloadBtn addTarget:self action:@selector(pauseAllDownload) forControlEvents:UIControlEventTouchUpInside];
        
        _continueDownloadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _continueDownloadBtn.backgroundColor = [UIColor yellowColor];
        [_continueDownloadBtn setTitle:@"全部开始" forState:UIControlStateNormal];
        [_continueDownloadBtn addTarget:self action:@selector(continueAllDownload) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _cancelBtn.backgroundColor = [UIColor yellowColor];
        [_cancelBtn setTitle:@"全部取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAllDownload) forControlEvents:UIControlEventTouchUpInside];
        
        _downloadTaskTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _downloadTaskTableView.delegate = self;
        _downloadTaskTableView.dataSource = self;
        _downloadTaskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _client = [GSDownloaderClient sharedDownloaderClient];
        _client.maxDownload = 2;
        _client.maxWaiting = NSIntegerMax;
        _client.maxPaused = NSIntegerMax;
        _client.maxFailureRetryChance = 10;
        
        _downdloadCount = 0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _startDownloadBtn.frame = CGRectMake(10, 30, 70, 40);
    [self.view addSubview:_startDownloadBtn];
    
    _pauseDownloadBtn.frame = CGRectMake(_startDownloadBtn.frame.origin.x + _startDownloadBtn.frame.size.width + 10,
                                         _startDownloadBtn.frame.origin.y,
                                         _startDownloadBtn.frame.size.width,
                                         _startDownloadBtn.frame.size.height);
    [self.view addSubview:_pauseDownloadBtn];
    
    _continueDownloadBtn.frame = CGRectMake(_pauseDownloadBtn.frame.origin.x + _pauseDownloadBtn.frame.size.width + 10,
                                         _pauseDownloadBtn.frame.origin.y,
                                         _pauseDownloadBtn.frame.size.width,
                                         _pauseDownloadBtn.frame.size.height);
    [self.view addSubview:_continueDownloadBtn];
    
    
    _cancelBtn.frame = CGRectMake(_continueDownloadBtn.frame.origin.x + _continueDownloadBtn.frame.size.width + 10,
                                            _continueDownloadBtn.frame.origin.y,
                                            _continueDownloadBtn.frame.size.width,
                                            _continueDownloadBtn.frame.size.height);
    [self.view addSubview:_cancelBtn];
    
    _downloadTaskTableView.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80);
    [self.view addSubview:_downloadTaskTableView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addDownload
{
    NSLog(@"添加下载...");
    
    _downdloadCount++;
    
    NSString* fromUrl = @"http://sj.img4399.com/game_list/com.tencent.pao/tencent.pao.v32077.apk";
    
    NSString* tmpFileName = [NSString stringWithFormat:@"tencent.pao.v32077-%d.tmp",_downdloadCount];
    NSString* saveFileName= [NSString stringWithFormat:@"tencent.pao.v32077-%d.ipa",_downdloadCount];
    
    NSString* savePath = [GSFileUtil getPathInDocumentsDirBy:@"Downloads/Games" createIfNotExist:YES];
    NSString* saveFile = [savePath stringByAppendingPathComponent:saveFileName];
    
    NSLog(@"成功下载路径为:%@",savePath);
    NSLog(@"成功文件为:%@",saveFile);
    
    NSString* tempPath = [GSFileUtil getPathInDocumentsDirBy:@"Downloads/Tmp" createIfNotExist:YES];
    NSString* tempFile = [tempPath stringByAppendingPathComponent:tmpFileName];
    
    NSLog(@"临时下载路径为:%@",tempPath);
    NSLog(@"临时文件为:%@",tempFile);
    
    MTDDownloadFileModel* downloadFileModel = [[MTDDownloadFileModel alloc] init];
    [downloadFileModel setDownloadFileName:@"4399手机游戏"];
    [downloadFileModel setDownloadFileAvatorURL:@"http://f1.img4399.com/mi~136383~124x124?1392195212"];
    [downloadFileModel setDownloadTaskURL:fromUrl];
    [downloadFileModel setDownloadFileSavePath:saveFile];
    [downloadFileModel setDownloadTempSavePath:tempFile];
    [downloadFileModel setDownloadFileVersion:@"2.0"];
    [downloadFileModel setDownloadFilePlistURL:@"itms-services:///?action=download-manifest&url=http://mobi.4399tech.com:8003/app/GameStoreHD/GameStoreHD.plist"];
    
    GSDownloadTask* downloadTask = [[GSDownloadTask alloc] init];
    [downloadTask setDownloadFileModel:downloadFileModel];
    
    [_downloadTasks addObject:downloadTask];
    
    //[self startDownloadWithTask:downloadTask];
    
    [_downloadTaskTableView reloadData];
    
    
    
}

- (void)pauseAllDownload
{
    NSLog(@"暂停下载...");
    
    [_client pauseAllDownloadTask];
}

- (void)continueAllDownload
{
    NSLog(@"继续下载...");
    
    [_client startAllDownloadTask];
}

- (void)cancelAllDownload
{
    NSLog(@"取消下载...");
    
    [_client cancelAllDownloadTask];
}

- (void)doTester
{
    NSLog(@"执行测试...");
    
    [_client testQueueKVO];
}

- (void)startDownloadWithTask:(GSDownloadTask*)downloadTask
{
    id<GSDownloadUIBindProtocol> downloadCell = [downloadTask getDownloadUIBinder];
    
    [_client downloadDataAsyncWithTask:downloadTask
                                 begin:^{
                                     
                                     NSLog(@"准备开始下载...");
                                     
                                 }
                              progress:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead, double bytesPerSecond) {
                                                                    
                                  [downloadCell updateUIWhenDownloadProgressChanged:bytesRead totalBytesRead:totalBytesRead totalBytesExpectedToRead:totalBytesExpectedToRead bytesPerSecond:bytesPerSecond];
                                  
                              }
                              complete:^(NSError *error) {
                                  
                                  if (error)
                                  {
                                      NSLog(@"下载失败,%@",error);
                                      
                                      [downloadCell updateUIDownloadFail];
                                      
                                  }
                                  else
                                  {
                                      NSLog(@"下载成功");
                                      
                                      [downloadCell updateUIWhenDownloadSuccessful];
                                      
                                  }
                                  
                              }];
}

#pragma mark - MTDDownloadTableViewCellDelegate
- (void)startDownloadAtIndex:(int)index
{
    GSDownloadTask* downloadTask = [_downloadTasks objectAtIndex:index];
    
    [self startDownloadWithTask:downloadTask];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _downloadTasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    static NSString* identifier = @"DownloadTaskTableViewCell";
    
    MTDDownloadTableViewCell* cell = (MTDDownloadTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[MTDDownloadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.index = indexPath.row;
    cell.delegate = self;
    
    GSDownloadTask* downloadTask = [_downloadTasks objectAtIndex:cell.index];
    [downloadTask setDownloadUIBinder:cell];
    
    return cell;
    
}

@end
