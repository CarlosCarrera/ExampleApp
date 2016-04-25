//
//  SongsView.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import "SongsView.h"
#import <PureLayout/PureLayout.h>

@interface SongsView()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation SongsView

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
    self.tableView = [UITableView newAutoLayoutView];
}

- (void)addSubviews {
    [self addSubview:self.tableView];
}

- (void)addStyles {
    self.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Autolayout

- (void)setupConstraints {
    [self.tableView autoPinEdgesToSuperviewEdges];
}

- (void)updateConstraints {
    if(!self.didSetupConstraints) {
        [self setupConstraints];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

@end
