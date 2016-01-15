//
//  SXCOtherChallenges.h
//  SXC
//
//  Created by Ketan on 20/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXCOtherChallenges : UIViewController{
    
    __weak IBOutlet UIImageView *imgVw_Cat;
    __weak IBOutlet UILabel *lbl_Desc;
    __weak IBOutlet UIScrollView *scrollVw_Container;
    
    __weak IBOutlet UIButton *btnAccept;
}
- (IBAction)btnPressed_Accept:(id)sender;
@property (nonatomic,strong) NSArray *dictData;

@end
