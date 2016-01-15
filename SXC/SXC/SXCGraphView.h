//
//  SXCGraphView.h
//  SXC
//
//  Created by Ketan on 08/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTSpiderPlotterView.h"
@protocol SkillsDelegate;
@interface SXCGraphView : UIView
{
    BTSpiderPlotterView *_spiderView;
    __weak IBOutlet UIButton *btn_MySkills;
    __weak IBOutlet UIButton *btn_Feedback;
    __weak IBOutlet UIView *vw_ratingPic;
    __weak IBOutlet UIImageView *imgVw_PicRating;
    UIImageView * imgVwLock;
}
@property (nonatomic, weak) id<SkillsDelegate> delegate;
-(void)setupGraph;
-(void)graphReload :(BOOL)isVal;
- (IBAction)btnPressed_MySkills:(id)sender;
- (IBAction)btnPressed_Feedback:(id)sender;
-(void)viewSelected :(BOOL)feedback :(NSString*)imgLink;
@property (nonatomic, assign) BOOL isLocked;
@end

@protocol SkillsDelegate <NSObject>
- (void)skillType:(NSString *)value;
- (void)mySkillsPressed:(NSString *)value;
- (void)feedbackPressed:(NSString *)value;

@end