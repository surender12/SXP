//
//  SXCUserProfileVC.h
//  SXC
//
//  Created by Ketan on 23/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXCProfileHeader.h"
#import "SXCProfileLikes.h"

@interface SXCUserProfileVC : UIViewController<ProfileDelegate,LikeDelegate>{
    
    __weak IBOutlet UITableView *tbl_Rating;
    NSArray *arrListOfSkills;
    NSMutableDictionary * dictSelectedData;
    NSArray * arrSkillRateSeq;
    //    NSArray * arrSkillLikeSeq;
    NSArray * arrLikeList;
    NSMutableArray * arrLikeSelected;
    BOOL isLikes;
    __weak IBOutlet UITableView *tbl_Likes;
    SXCProfileLikes *likesFooter;
}
//- (IBAction)btnPressed_Star:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;
@property (nonatomic,strong) NSString * userID;
- (IBAction)btnPressed_LikeStar:(id)sender;

@end
