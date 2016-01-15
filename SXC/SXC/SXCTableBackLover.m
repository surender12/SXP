//
//  SXCTableBackLover.m
//  SXC
//
//  Created by Ketan on 02/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCTableBackLover.h"
#import "SXCSearchFriendVC.h"

@implementation SXCTableBackLover
@synthesize blockSearch;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnPressed_Search:(id)sender {
    self.blockSearch();
}
@end
