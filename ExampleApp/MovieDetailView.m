//
//  MovieDetailView.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16  
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import "MovieDetailView.h"
#import <PureLayout/PureLayout.h>

@interface MovieDetailView()

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) NSArray *horizontalLayoutConstraints;
@property (nonatomic, strong) NSArray *verticalLayoutConstraints;

@end

@implementation MovieDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initialize];
        return self;
    }
    return nil;
}

- (void)initialize {
    [self createSubviews];
    [self addSubviews];
    [self addStyles];
}

- (void)createSubviews {
    self.posterImageView = [UIImageView newAutoLayoutView];
    self.overviewTextView = [UITextView newAutoLayoutView];
    self.averageVoteLabel = [UILabel newAutoLayoutView];
}

- (void)addSubviews {
    [self addSubview:self.posterImageView];
    [self addSubview:self.overviewTextView];
    [self.posterImageView addSubview:self.averageVoteLabel];
}

- (void)addStyles {
    [self.posterImageView setBackgroundColor:[UIColor blackColor]];
    [self.posterImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.posterImageView.clipsToBounds = YES;

    [self.overviewTextView setFont:[UIFont systemFontOfSize:18]];
    self.overviewTextView.scrollEnabled = YES;
    self.overviewTextView.editable = NO;

    [self.averageVoteLabel setFont:[UIFont systemFontOfSize:24]];
    self.averageVoteLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Autolayout

- (void)setupConstraints {
    self.verticalLayoutConstraints = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
        [self.posterImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(33.0, 0.0, 0.0, 0.0) excludingEdge:ALEdgeBottom];
        [self.posterImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:0.5 relation:NSLayoutRelationEqual];
        
        [self.overviewTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.posterImageView];
        [self.overviewTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:33.0];
        [self.overviewTextView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    }];
    
    self.horizontalLayoutConstraints = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
        [self.posterImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:33.0];
        [self.posterImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.posterImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.posterImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.overviewTextView];
        
        [self.overviewTextView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:33.0];
        [self.overviewTextView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.overviewTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:33.0];
        [self.overviewTextView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5 relation:NSLayoutRelationEqual];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self orientationChangedTo:[UIDevice currentDevice].orientation];
}

- (void)orientationChangedTo:(UIDeviceOrientation)orientation {
    if(UIDeviceOrientationIsLandscape(orientation)) {
        [self.verticalLayoutConstraints autoRemoveConstraints];
        [self.horizontalLayoutConstraints autoInstallConstraints];
    }
    if(UIDeviceOrientationIsPortrait(orientation)) {
        [self.horizontalLayoutConstraints autoRemoveConstraints];
        [self.verticalLayoutConstraints autoInstallConstraints];
    }
}

- (void)updateConstraints {
    if(!self.didSetupConstraints) {
        [self setupConstraints];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

@end
