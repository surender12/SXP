//
//  SXCProfileHeader.h
//  SXC
//
//  Created by Ketan on 23/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProfileDelegate;
@interface SXCProfileHeader : UIView{
    
    __weak IBOutlet UIImageView *imgVw_cover;
    __weak IBOutlet UIImageView *imgVw_Profile;
    __weak IBOutlet UILabel *lnl_Name;
    __weak IBOutlet UISwitch *swtch_Mode;
    
    __weak IBOutlet UIButton *btnLike;
    
    __weak IBOutlet UIButton *btnRate;
}
- (IBAction)valueChanged_Switch:(id)sender;
- (IBAction)btnPressed_Like:(id)sender;
- (IBAction)btnPressed_Rate:(id)sender;
-(void)getData:(NSArray*)dict;
@property (nonatomic, weak) id<ProfileDelegate> delegate;

@end
@protocol ProfileDelegate <NSObject>
- (void)profileType:(NSString *)value;
@end