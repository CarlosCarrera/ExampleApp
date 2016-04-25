//
//  MovieDetailView.h
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16  
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailView : UIView

@property (strong, nonatomic) UIImageView *posterImageView;
@property (strong, nonatomic) UITextView *overviewTextView;
@property (strong, nonatomic) UILabel *averageVoteLabel;

- (void)orientationChangedTo:(UIDeviceOrientation)orientation;

@end
