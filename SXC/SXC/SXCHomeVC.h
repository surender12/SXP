//
//  SXCHomeVC.h
//  SXC
//
//  Created by Ketan on 08/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "SXCGraphView.h"
#import "SXCMySkillFooter.h"
#import "SXCFeedbackFooter.h"

@interface SXCHomeVC : UIViewController<SkillsDelegate,SkillsFooterDelegate>
{
    __weak IBOutlet UITableView *tbl_container;
    NSArray * arrListOfSkills;
    SXCGraphView * graphView;
    __weak IBOutlet UIDatePicker *datePkr_Calendar;
    __weak IBOutlet UIToolbar *toolBr;
    SXCMySkillFooter *mySkillFooter;
    NSArray * arrLikeList;
    NSMutableArray * arrLikeSelected;
    BOOL isMySkills;
    SXCFeedbackFooter *feedbackFooter;
    NSString * strTypeSelected;
    NSDictionary *strFriendID;
}
- (IBAction)btnPressed_DoneCal:(id)sender;

@end
