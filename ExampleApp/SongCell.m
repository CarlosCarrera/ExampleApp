//
//  SongCell.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16  
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import "SongCell.h"


@implementation SongCell

+ (CGFloat)defaultHeight {
    return 105;
}

+ (CGFloat)expandedHeight {
    return 145;
}

- (IBAction)playButtonPressed:(id)sender {
    if (self.playButtonAction) {
        self.playButtonAction(sender);
    }
}

@end
