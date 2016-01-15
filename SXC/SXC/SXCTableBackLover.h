//
//  SXCTableBackLover.h
//  SXC
//
//  Created by Ketan on 02/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^searchAction)();


@interface SXCTableBackLover : UIView{
    searchAction blockSearch;
}
- (IBAction)btnPressed_Search:(id)sender;
@property (nonatomic, copy) searchAction blockSearch;
@end
