//
//  SongsVC.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16 
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import "SongsVC.h"
#import "SongsView.h"
#import "SongUseCases.h"
#import "DataBaseManager.h"
#import "SongCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@import AVFoundation;

@interface SongsVC() <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) SongsView *view;
@property (strong, nonatomic) NSString *artistName;
@property (strong, nonatomic) NSArray <Song *> *songs;
@property (strong, nonatomic) SongUseCases *songUseCases;
@property (strong, nonatomic) NSIndexPath *selectedIndexpath;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation SongsVC

@dynamic view;

- (instancetype)initWithArtistName:(NSString *)artistName {
    self = [super init];
    if (self) {
        self.artistName = artistName;
    }
    return self;
}

- (void)loadView {
    self.view = [SongsView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setNeedsUpdateConstraints];
    
    self.view.tableView.delegate = self;
    self.view.tableView.dataSource = self;
    
    self.songUseCases = [SongUseCases useCasesWithRestClient:[RestClient defaultClient] andDatabaseManager:[DataBaseManager sharedDataBaseManager]];
    
    [self.view.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SongCell class]) bundle:nil]
              forCellReuseIdentifier:NSStringFromClass([SongCell class])];
    
    [self loadSongs];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopSong];
}

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    [self.timer invalidate];
    self.player = nil;
    SongCell *cell = [self.view.tableView cellForRowAtIndexPath:self.selectedIndexpath];
    [cell.progressBar setProgress:0.0 animated:NO];
    [cell.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

#pragma mark - Private Methods

- (void)loadSongs {
    dispatch_async(dispatch_queue_create("searchSongs", 0), ^{
        [self.songUseCases  getSongsFromArtistWithName:self.artistName success:^(NSString *artistName) {
            self.songs = [[DataBaseManager sharedDataBaseManager] getAllSongsFromArtist:artistName];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view.tableView reloadData];
            });
        } failure:^(NSString *error) {
            NSLog(@"Error: %@",error);
        }];
    });
}

- (void)playSong:(NSIndexPath *)indexPath {
    SongCell *cell = [self.view.tableView cellForRowAtIndexPath:self.selectedIndexpath];

    if(self.player.rate == 0.0) {
        // Player Stopped
        [cell.playButton setTitle:@"Pause" forState:UIControlStateNormal];
        if(!self.player) {
            [self loadSongWithUrl:[self.songs[indexPath.row] previewUrl]];
        }
        [self.player play];
    } else {
        // Player Resumed
        [cell.playButton setTitle:@"Play" forState:UIControlStateNormal];
        [self.player pause];
    }
   self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgressForIndexPath:) userInfo:nil repeats:YES];
}

- (void)loadSongWithUrl:(NSString *)url {
    self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    self.player = [AVPlayer new];
    NSArray *keys = @[@"playable"];
    [self.playerItem.asset loadValuesAsynchronouslyForKeys:keys completionHandler:^() {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }];
}

- (void)stopSong {
    [self.player pause];
    self.player = nil;
    [self.view.tableView reloadData];
}

- (void)updateProgressForIndexPath:(NSIndexPath *)indexPath {
    SongCell *cell = [self.view.tableView cellForRowAtIndexPath:self.selectedIndexpath];
    
    NSTimeInterval aCurrentTime = !CMTIME_IS_INVALID(self.player.currentTime) ? CMTimeGetSeconds(self.player.currentTime) : 0;
    NSTimeInterval aDuration = self.player.currentItem ? CMTimeGetSeconds(self.player.currentItem.asset.duration) : 1;

    double progress = aCurrentTime/aDuration;
    
    [cell.progressBar setProgress:(float)progress animated:YES];
}

#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SongCell class])];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(SongCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.trackNameLabel.text = [self.songs[indexPath.row] trackName];
    cell.artistNameLabel.text = [[self.songs[indexPath.row] artist] name];
    
    [cell.artworkImageView setImageWithURL:[NSURL URLWithString:[self.songs[indexPath.row] artwork]]
                          placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    
    cell.collectionNameLabel.text = [self.songs[indexPath.row] collectionName];
    
    [cell.progressBar setProgress:0.0 animated:NO];
    
    [cell.playButton setTitle:NSLocalizedString(@"Play", nil) forState:UIControlStateNormal];
    
    cell.playButtonAction = ^(id sender) {
        [self playSong:indexPath];
    };
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath == self.selectedIndexpath) {
        return [SongCell expandedHeight];
    } else {
        return [SongCell defaultHeight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self stopSong];
    
    NSIndexPath *previousIndexPath = self.selectedIndexpath;
    
    if (indexPath == self.selectedIndexpath) {
        self.selectedIndexpath = nil;
    } else {
        self.selectedIndexpath = indexPath;
    }
    
    NSMutableArray *indexPaths = [NSMutableArray new];
    
    if (previousIndexPath) {
        [indexPaths addObject:previousIndexPath];
    }
    if (self.selectedIndexpath) {
        [indexPaths addObject:self.selectedIndexpath];
    }
    if ([indexPaths count] > 0 ) {

        [self.view.tableView reloadRowsAtIndexPaths:[indexPaths copy] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self.view.tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
}

@end
