//
//  MTDDownloadTableViewCell.m
//  GSDownloaderSDKDemo
//
//  Created by Chaoqian Wu on 14-3-10.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import "MTDDownloadTableViewCell.h"

@implementation MTDDownloadTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self commonInit];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)commonInit
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor cyanColor];
    
    _downloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _downloadButton.backgroundColor = [UIColor greenColor];
    [_downloadButton setTitle:@"开始下载" forState:UIControlStateNormal];
    [_downloadButton addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_downloadButton];
    
    _downloadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _downloadProgress.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_downloadProgress];
    
    _downloadRateLabel = [[UILabel alloc] init];
    _downloadRateLabel.textAlignment = NSTextAlignmentLeft;
    _downloadRateLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_downloadRateLabel];
    
    _downloadPercentLabel = [[UILabel alloc] init];
    _downloadPercentLabel.textAlignment = NSTextAlignmentRight;
    _downloadPercentLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_downloadPercentLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    int buttonY = 10;
    int buttonWith = 70;
    int buttonHeight = frame.size.height - 2*buttonY;
    int buttonX = frame.size.width - 10 - buttonWith;
    _downloadButton.frame = CGRectMake(buttonX, buttonY, buttonWith, buttonHeight);
    
    int progressX = 10;
    int progressHeight = 20;
    int progressY = (frame.size.height - progressHeight) / 2;
    int progressWidth = buttonX - 2*progressX;
    _downloadProgress.frame = CGRectMake(progressX, progressY, progressWidth, progressHeight);
    
    int alabelX = progressX;
    int alabelY = _downloadProgress.frame.origin.y + 10;
    int alabelHeight = frame.size.height - alabelY - 10;
    int alabelWidth = _downloadProgress.frame.size.width / 2;
    _downloadRateLabel.frame = CGRectMake(alabelX, alabelY, alabelWidth, alabelHeight);
    
    int blabelX = alabelX + alabelWidth;
    int blabelY = alabelY;
    int blabelWidth = alabelWidth;
    int blabelHeight = alabelHeight;
    _downloadPercentLabel.frame = CGRectMake(blabelX, blabelY, blabelWidth, blabelHeight);
    
}

- (void)downloadAction
{
    [self.delegate startDownloadAtIndex:self.index];
}

#pragma mark - GSDownloadUIBindProtocol
- (void)updateUIWhenDownloadStatusChanged:(GSDownloadUIStatus)downloadStatus
{
    
    switch (downloadStatus) {
        case GSDownloadUIStatusWaitingForStart:
            [_downloadButton setTitle:@"等待中..." forState:UIControlStateNormal];
            break;
            
        case GSDownloadUIStatusDownloading:
            [_downloadButton setTitle:@"下载中..." forState:UIControlStateNormal];
            break;
            
        case GSDownloadUIStatusPaused:
            [_downloadButton setTitle:@"暂停中..." forState:UIControlStateNormal];
            break;
            
        case GSDownloadUIStatusWaitingForResume:
            [_downloadButton setTitle:@"等待中..." forState:UIControlStateNormal];
            break;
            
        case GSDownloadUIStatusCanceled:
            [_downloadButton setTitle:@"取消了..." forState:UIControlStateNormal];
            break;
            
        case GSDownloadUIStatusSuccess:
            [_downloadButton setTitle:@"成功了..." forState:UIControlStateNormal];
            break;
            
        case GSDownloadUIStatusFailure:
            [_downloadButton setTitle:@"失败了..." forState:UIControlStateNormal];
            break;
            
        default:
            [_downloadButton setTitle:@"等待中..." forState:UIControlStateNormal];
            break;
    }
}

- (void)updateUIWhenDownloadProgressChanged:(NSUInteger)bytesRead totalBytesRead:(long long)totalBytesRead totalBytesExpectedToRead:(long long)totalBytesExpectedToRead bytesPerSecond:(double)bytesPerSecond
{
    NSString* downloadProgress = [NSString stringWithFormat:@"%0.2f",(float)totalBytesRead/(float)totalBytesExpectedToRead];
    float downloadProgressFloat = [downloadProgress floatValue];
    
    self.downloadProgress.progress = downloadProgressFloat;
    self.downloadPercentLabel.text = [[NSString alloc] initWithFormat:@"%0.2f%%",(float)totalBytesRead/(float)totalBytesExpectedToRead*100];
    
    self.downloadRateLabel.text = [[NSString alloc] initWithFormat:@"%0.0fK/s",(float)bytesPerSecond/1000];
}

- (void)updateUIWhenDownloadSuccessful
{
    self.downloadPercentLabel.backgroundColor = [UIColor greenColor];
}

- (void)updateUIDownloadFail
{
    self.downloadPercentLabel.backgroundColor = [UIColor redColor];
}

@end
