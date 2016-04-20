//
//  TrackCell.m
//  URLSessionDemo
//
//  Created by jiechen on 16/4/15.
//  Copyright © 2016年 chenjie. All rights reserved.
//

#import "TrackCell.h"

@interface TrackCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *atristLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UILabel *apreciateLabel;
@property (nonatomic, assign)DownloadStatus status;

@end

@implementation TrackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configWithDownloadStatus:DownloadStatusReady];
    [self.downloadButton addTarget:self action:@selector(onDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseButton addTarget:self action:@selector(onPause) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)prepareForReuse {
    self.download.cell = nil;
}

- (void)setEntity:(TrackEntity *)entity {
    _entity = entity;
    self.titleLabel.text = entity.trackName;
    self.atristLabel.text = entity.artistName;
}

- (void)setDownload:(Download *)download {
    _download = download;
    _download.cell = self;
    
    if (download.status != _status) {
        [self configWithDownloadStatus:download.status];
    }
    
    self.progressView.progress = download.progress;
    NSString *sizeStr = [NSByteCountFormatter stringFromByteCount:download.totalSize countStyle:NSByteCountFormatterCountStyleBinary];
    self.infoLabel.text = [NSString stringWithFormat:@"%.1f%% of %@", download.progress * 100, sizeStr];
 }

- (void)configWithDownloadStatus:(DownloadStatus)status {
    _status = status;
    switch (status) {
        case DownloadStatusReady: {
            self.downloadButton.hidden = NO;
            self.progressView.hidden =
            self.infoLabel.hidden =
            self.pauseButton.hidden =
            self.cancelButton.hidden = YES;
            self.apreciateLabel.hidden = YES;
            break;
        }
        case DownloadStatusDownloading: {
            self.downloadButton.hidden = YES;
            self.progressView.hidden =
            self.infoLabel.hidden =
            self.pauseButton.hidden =
            self.cancelButton.hidden = NO;
            self.apreciateLabel.hidden = YES;
            [self.pauseButton setTitle:@"pause" forState:UIControlStateNormal];
            break;
        }
        case DownloadStatusPause: {
            self.downloadButton.hidden = YES;
            self.progressView.hidden =
            self.infoLabel.hidden =
            self.pauseButton.hidden =
            self.cancelButton.hidden = NO;
            self.apreciateLabel.hidden = YES;
            [self.pauseButton setTitle:@"resume" forState:UIControlStateNormal];
            break;
        }
        case DownloadStatusFinished: {
            self.downloadButton.hidden =
            self.progressView.hidden =
            self.infoLabel.hidden =
            self.pauseButton.hidden =
            self.cancelButton.hidden = YES;
            self.apreciateLabel.hidden = NO;
            break;
        }
    }
}

- (BOOL)canAppreciate {
    return self.status == DownloadStatusFinished;
}

#pragma mark -
- (void)onDownload {
    if (self.delegate && [self.delegate respondsToSelector:@selector(trackCellDownload:)]) {
        [self.delegate trackCellDownload:self];
    }
}

- (void)onPause {
    if (self.status == DownloadStatusPause) {
        if ([self.delegate respondsToSelector:@selector(trackCellResume:)]) {
            [self.delegate trackCellResume:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(trackCellPause:)]) {
            [self.delegate trackCellPause:self];
        }
    }
}

- (void)onCancel {
    if ([self.delegate respondsToSelector:@selector(trackCellCancel:)]) {
        [self.delegate trackCellCancel:self];
    }
}

@end
