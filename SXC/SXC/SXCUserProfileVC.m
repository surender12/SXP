//
//  SXCUserProfileVC.m
//  SXC
//
//  Created by Ketan on 23/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCUserProfileVC.h"
#import "SXCProfileHeader.h"
#import "SXCProfileLikes.h"

@interface SXCUserProfileVC ()

@end

@implementation SXCUserProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"";
    
    self.navigationItem.leftBarButtonItem = [SXCUtility leftbar:[UIImage imageNamed:@"backArrow"] :self];
    
    self.navigationItem.rightBarButtonItems = [SXCUtility rightbar:nil :@"SAVE" :self];
    
    tbl_Rating.hidden = YES;
    
    arrListOfSkills = @[@{@"skill":@"PEAK CONTROL",@"description":@"Learn to control the peak orgasm."},@{@"skill":@"SEXTALK",@"description":@"Learn to say the right words."},@{@"skill":@"PRESENCE",@"description":@"How present are you with your lover?"},@{@"skill":@"LEADING",@"description":@"Guide your lover into horniness."},@{@"skill":@"DEEP ORGASMS",@"description":@"Experience deep tantric orgasms."},@{@"skill":@"PLAYFULLNESS",@"description":@"A doorway to deeper horniness."},@{@"skill":@"EMPATHY",@"description":@"Know your lovers deepest longing."},@{@"skill":@"FOLLOWING",@"description":@"Let yourself be guided deeper."}];
    
    
    arrLikeList = @[@"Peak control",
                    @"Playfulness",
                    @"Presence",
                    @"Empathy",
                    @"Deep orgasms",
                    @"Leading",
                    @"Following",
                    @"Sextalk",
                    @"You look hot",
                    @"You are sexy",
                    @"You are a great kisser",
                    @"You have a sexy body",
                    @"You have great hands",
                    @"You are very masculine",
                    @"You are a great fuck",
                    @"You are a great person",
                    @"You are a good cocksucker",
                    @"I like your looks",
                    @"I like your body",
                    @"I like your smell",
                    @"I like your cock",
                    @"I like your personality",
                    @"I like the way you talk to me",
                    @"I like the way you look at me",
                    @"I like the way you touch me",
                    @"I like the way you kiss me",
                    @"I like the way you look",
                    @"I would introduce you to my friends",
                    @"I am attracted to you"];
    
    arrLikeSelected = [[NSMutableArray alloc]init];
    
    [arrLikeList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [arrLikeSelected addObject:@"0"];
        
    }];
    
    
    
    NSLog(@"UserID---%@",_userID);
    [self callGetProfileAPI];
    
    tbl_Likes.layer.borderColor = [UIColor whiteColor].CGColor;
    tbl_Likes.hidden = YES;
}

-(void)likeDone{
    
    tbl_Likes.hidden = YES;
    [self callSaveUseLikesAPI];
}

-(void)rightBtn{
    
}
-(void)rightBtnTxt{
    if ([[[SXCUtility singleton].dictChallenges valueForKey:@"RateYourLover"] isEqualToString:@"1"]) {
        
        [self callSaveUserRatingsAPI];
        
    }else{
        [ApplicationDelegate showAlert:@"Accept RATE YOUR LOVER Challenge."];
    }
    
}

-(void)callGetProfileAPI{
    [ApplicationDelegate loadingShow];
    
    //      http://www.trigmasolutions.com/SexSkill/api/GetFreindProfileDetail
    //      Keys:UserID
    
    NSLog(@"[[UserDefaults ---%@",[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"]);
    
    [[SXCUtility singleton] getDataGETForUrl:[NSString stringWithFormat:@"%@%@/%@",GetFriendProfileDetail,_userID,[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject objectAtIndex:0] && [[responseObject objectAtIndex:0] valueForKey:@"Status"] && [[[responseObject objectAtIndex:0] valueForKey:@"Status"] boolValue] == YES) {
            
            self.navigationItem.titleView = [SXCUtility lblTitleNavBar:
                                             [[responseObject objectAtIndex:0] valueForKey:@"UserName"]];
            tbl_Rating.hidden = NO;
            SXCProfileHeader * backView = [[[NSBundle mainBundle] loadNibNamed:@"SXCProfileHeader" owner:self options:nil] lastObject];
            backView.delegate = self;
            [backView getData:responseObject];
            
            tbl_Rating.tableHeaderView = backView;
            
            if ([[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] && [[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] && [[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"Status"] boolValue] == YES) {
                
                dictSelectedData = [[NSMutableDictionary alloc]init];
                [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"PeakControl"] forKey:@"PeakControl"];
                //            [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"PeakControlLike"] forKey:@"PealControlLike"];
                [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"SexTalk"] forKey:@"SexTalk"];
                //            [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"SextalkLike"] forKey:@"SexTalkLike"];
                [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"Presence"] forKey:@"Presence"];
                //            [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"PresenceLike"] forKey:@"PresenceLike"];
                [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"Leading"] forKey:@"Leading"];
                //            [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"LeadingLike"] forKey:@"LeadingLike"];
                [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"Deeporgasms"] forKey:@"Deeporgasms"];
                //            [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"DeeporgasmsLike"] forKey:@"DeeporgasmsLike"];
                [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"Playfullness"] forKey:@"Playfullness"];
                //            [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"PlayfullnessLike"] forKey:@"PlayfullnessLike"];
                [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"Empathy"] forKey:@"Empathy"];
                //            [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"EmpathryLike"] forKey:@"EmpathyLike"];
                [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"Following"] forKey:@"Following"];
                //            [dictSelectedData setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"FreindRatings"] objectAtIndex:0] valueForKey:@"FollowingLike"] forKey:@"FollowingLike"];
                
            }else{
                dictSelectedData = [[NSMutableDictionary alloc]init];
                [dictSelectedData setValue:@"0" forKey:@"PeakControl"];
                //                [dictSelectedData setValue:@"0" forKey:@"PealControlLike"];
                [dictSelectedData setValue:@"0" forKey:@"SexTalk"];
                //                [dictSelectedData setValue:@"0" forKey:@"SexTalkLike"];
                [dictSelectedData setValue:@"0" forKey:@"Presence"];
                //                [dictSelectedData setValue:@"0" forKey:@"PresenceLike"];
                [dictSelectedData setValue:@"0" forKey:@"Leading"];
                //                [dictSelectedData setValue:@"0" forKey:@"LeadingLike"];
                [dictSelectedData setValue:@"0" forKey:@"Deeporgasms"];
                //                [dictSelectedData setValue:@"0" forKey:@"DeeporgasmsLike"];
                [dictSelectedData setValue:@"0" forKey:@"Playfullness"];
                //                [dictSelectedData setValue:@"0" forKey:@"PlayfullnessLike"];
                [dictSelectedData setValue:@"0" forKey:@"Empathy"];
                //                [dictSelectedData setValue:@"0" forKey:@"EmpathyLike"];
                [dictSelectedData setValue:@"0" forKey:@"Following"];
                //                [dictSelectedData setValue:@"0" forKey:@"FollowingLike"];
            }
            
            if ([[responseObject objectAtIndex:0] valueForKey:@"FriendLikes"] && [[[responseObject objectAtIndex:0] valueForKey:@"FriendLikes"] objectAtIndex:0] && [[[[[responseObject objectAtIndex:0] valueForKey:@"FriendLikes"] objectAtIndex:0] valueForKey:@"Status"] boolValue] == YES) {
                [arrLikeSelected enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSString *strValuesKeys = [[arrLikeList objectAtIndex:idx] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    NSLog(@"strValuesKeys---%@",strValuesKeys);
                    if ([[[[responseObject objectAtIndex:0] valueForKey:@"FriendLikes"] objectAtIndex:0] valueForKey:strValuesKeys] != [NSNull null]) {
                        [arrLikeSelected replaceObjectAtIndex:idx withObject:[[[[responseObject objectAtIndex:0] valueForKey:@"FriendLikes"] objectAtIndex:0] valueForKey:strValuesKeys]];
                    }
                    
                }];
                NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
                [dictData setObject:arrLikeSelected forKey:@"liked"];
                [dictData setObject:arrLikeList forKey:@"likeList"];
                [likesFooter setupLikesFooter:dictData];
                
            }
            NSLog(@"arrLikeSelected---%@",arrLikeSelected);
            //            arrSkillLikeSeq = @[@"PealControlLike",@"SexTalkLike",@"PresenceLike",@"LeadingLike",@"DeeporgasmsLike",@"PlayfullnessLike",@"EmpathyLike",@"FollowingLike"];
            arrSkillRateSeq = @[@"PeakControl",@"SexTalk",@"Presence",@"Leading",@"Deeporgasms",@"Playfullness",@"Empathy",@"Following"];
            
            [tbl_Rating reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}

#pragma mark
#pragma mark ProfileView Delegate
#pragma mark
- (void)profileType:(NSString *)value{
    
    if ([value isEqualToString:@"like"]) {
        isLikes = YES;
        
        likesFooter = [[[NSBundle mainBundle] loadNibNamed:@"SXCProfileLikes" owner:self options:nil] lastObject];
        likesFooter.delegate = self;
        NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
        [dictData setObject:arrLikeSelected forKey:@"liked"];
        [dictData setObject:arrLikeList forKey:@"likeList"];
        [likesFooter setupLikesFooter:dictData];
        tbl_Rating.tableFooterView = likesFooter;
        
    }else{
        isLikes = NO;
        tbl_Rating.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    [tbl_Rating reloadData];
    
}

-(void)likePressed{
    if ([[[SXCUtility singleton].dictChallenges valueForKey:@"LikeYourLovers"] isEqualToString:@"1"]) {
        
        tbl_Likes.hidden = NO;
        [tbl_Likes reloadData];
        
    }else{
        [ApplicationDelegate showAlert:@"Accept LIKE YOUR LOVER Challenge."];
    }
    
}

-(void)callSaveUserRatingsAPI{
    [ApplicationDelegate loadingShow];
    //      http://www.trigmasolutions.com/SexSkill/api/SaveRatingGivenByUser
    //Keys:UserID,SentByUserID,PeakControl,PealControlLike,SexTalk,SexTalkLike,Presence,PresenceLike,Leading,LeadingLike,Deeporgasms,DeeporgasmsLike,Playfullness,PlayfullnessLike,Empathy,EmpathyLike,Following,FollowingLike
    
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    
    [dictData setValue:[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"] forKey:@"SentByUserID"];
    [dictData setValue:_userID forKey:@"UserID"];
    
    [dictData setValue:[dictSelectedData valueForKey:@"PeakControl"] forKey:@"PeakControl"];
    //    [dictData setValue:[dictSelectedData valueForKey:@"PealControlLike"] forKey:@"PealControlLike"];
    [dictData setValue:[dictSelectedData valueForKey:@"SexTalk"] forKey:@"SexTalk"];
    //    [dictData setValue:[dictSelectedData valueForKey:@"SexTalkLike"] forKey:@"SexTalkLike"];
    [dictData setValue:[dictSelectedData valueForKey:@"Presence"] forKey:@"Presence"];
    //    [dictData setValue:[dictSelectedData valueForKey:@"PresenceLike"] forKey:@"PresenceLike"];
    [dictData setValue:[dictSelectedData valueForKey:@"Leading"] forKey:@"Leading"];
    //    [dictData setValue:[dictSelectedData valueForKey:@"LeadingLike"] forKey:@"LeadingLike"];
    [dictData setValue:[dictSelectedData valueForKey:@"Deeporgasms"] forKey:@"Deeporgasms"];
    //    [dictData setValue:[dictSelectedData valueForKey:@"DeeporgasmsLike"] forKey:@"DeeporgasmsLike"];
    [dictData setValue:[dictSelectedData valueForKey:@"Playfullness"] forKey:@"Playfullness"];
    //    [dictData setValue:[dictSelectedData valueForKey:@"PlayfullnessLike"] forKey:@"PlayfullnessLike"];
    [dictData setValue:[dictSelectedData valueForKey:@"Empathy"] forKey:@"Empathy"];
    //    [dictData setValue:[dictSelectedData valueForKey:@"EmpathyLike"] forKey:@"EmpathyLike"];
    [dictData setValue:[dictSelectedData valueForKey:@"Following"] forKey:@"Following"];
    //    [dictData setValue:[dictSelectedData valueForKey:@"FollowingLike"] forKey:@"FollowingLike"];
    
    
    [[SXCUtility singleton] getDataForUrl:SaveProfileRating parameters:dictData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject valueForKey:@"Status"] && [[responseObject valueForKey:@"Status"] boolValue] == YES) {
            
            [[SXCUtility singleton].dictChallenges setValue:@"1" forKey:@"IsLocked"];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Rating saved Successfully!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 101;
            [alert show];
            
        }else{
            [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
}

-(void)leftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark
#pragma mark TableView DataSource/Delegate
#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == tbl_Rating) {
        if (!isLikes) {
            return [[arrListOfSkills valueForKey:@"skill"] count];
        }else{
            return 0;
        }
    }else
        return [arrLikeList count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == tbl_Likes) {
        return 50;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * likeHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 263, 50)];
    likeHeader.backgroundColor = ColorBackground;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(likeDone)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"DONE" forState:UIControlStateNormal];
    button.frame = CGRectMake(190, 0, 80, 50);
    button.titleLabel.font = FontOpenSans(12);
    [likeHeader addSubview:button];
    UIImageView * imgVw = [[UIImageView alloc]initWithFrame:CGRectMake(0, 49, 263, 1)];
    imgVw.backgroundColor = [UIColor whiteColor];
    [likeHeader addSubview:imgVw];
    return likeHeader;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tbl_Rating) {
        static NSString *cellIdentifier = @"cell";
        UILabel *lblTitle;
        UISlider * sliderRate;
        UILabel *lblRate;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
        }
        sliderRate = (UISlider*)[cell.contentView viewWithTag:1002];
        lblTitle = (UILabel *)[cell.contentView viewWithTag:1001];
        lblRate = (UILabel *)[cell.contentView viewWithTag:1003];
        //    UIButton *btn_star = (UIButton *)[cell.contentView viewWithTag:1004];
        
        if (sliderRate) {
            [sliderRate setMinimumTrackImage:[UIImage imageNamed:@"sliderImg.png"] forState:UIControlStateNormal];
            sliderRate.value = [[dictSelectedData valueForKey:[arrSkillRateSeq objectAtIndex:indexPath.row]] floatValue];
        }
        if (lblTitle) {
            lblTitle.text = [[arrListOfSkills objectAtIndex:indexPath.row] valueForKey:@"skill"];
        }
        if (lblRate) {
            lblRate.text = [NSString stringWithFormat:@"%.f", [[dictSelectedData valueForKey:[arrSkillRateSeq objectAtIndex:indexPath.row]] floatValue]];
        }
        //    if (btn_star) {
        //        if ([[dictSelectedData valueForKey:[arrSkillLikeSeq objectAtIndex:indexPath.row]] floatValue] == 1) {
        //            btn_star.selected = YES;
        //        }else
        //            btn_star.selected = NO;
        //    }
        return cell;
    }else{
        
        static NSString *cellIdentifier = @"cellLikes";
        UILabel *lblTitle;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
        }
        lblTitle = (UILabel *)[cell.contentView viewWithTag:1089];
        UIButton *btn_star = (UIButton *)[cell.contentView viewWithTag:1090];
        
        if (lblTitle) {
            lblTitle.text = [arrLikeList objectAtIndex:indexPath.row];
        }
        if (btn_star) {
            if ([[arrLikeSelected objectAtIndex:indexPath.row] floatValue] == 1) {
                btn_star.selected = YES;
            }else
                btn_star.selected = NO;
        }
        return cell;
        
        
    }
    
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/*
 - (IBAction)btnPressed_Star:(id)sender {
 
 CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Rating];
 NSIndexPath *indexPath = [tbl_Rating indexPathForRowAtPoint:buttonPosition];
 NSLog(@"indexPath--%ld",(long)indexPath.row);
 UITableViewCell * cell = [tbl_Rating cellForRowAtIndexPath:indexPath];
 UIButton *btn_star = (UIButton *)[cell.contentView viewWithTag:1004];
 
 if ([btn_star isSelected]) {
 [btn_star setSelected:NO];
 [dictSelectedData setValue:@"0" forKey:[arrSkillLikeSeq objectAtIndex:indexPath.row]];
 }else{
 [btn_star setSelected:YES];
 [dictSelectedData setValue:@"1" forKey:[arrSkillLikeSeq objectAtIndex:indexPath.row]];
 }
 
 
 }
 */
- (IBAction)sliderValueChanged:(id)sender {
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Rating];
    NSIndexPath *indexPath = [tbl_Rating indexPathForRowAtPoint:buttonPosition];
    //    NSLog(@"indexPath--%ld",(long)indexPath.row);
    UITableViewCell * cell = [tbl_Rating cellForRowAtIndexPath:indexPath];
    UISlider *sliderRate = (UISlider *)[cell.contentView viewWithTag:1002];
    UILabel *lblRate = (UILabel *)[cell.contentView viewWithTag:1003];
    
    lblRate.text = [NSString stringWithFormat:@"%.f",sliderRate.value];
    [dictSelectedData setValue:lblRate.text forKey:[arrSkillRateSeq objectAtIndex:indexPath.row]];
    
    
}
- (IBAction)btnPressed_LikeStar:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Likes];
    NSIndexPath *indexPath = [tbl_Likes indexPathForRowAtPoint:buttonPosition];
    NSLog(@"indexPath--%ld",(long)indexPath.row);
    UITableViewCell * cell = [tbl_Likes cellForRowAtIndexPath:indexPath];
    UIButton *btn_star = (UIButton *)[cell.contentView viewWithTag:1090];
    
    if ([btn_star isSelected]) {
        [btn_star setSelected:NO];
        [arrLikeSelected replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }else{
        [btn_star setSelected:YES];
        [arrLikeSelected replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }
    
}

-(void)callSaveUseLikesAPI{
    [ApplicationDelegate loadingShow];
    //      http://www.trigmasolutions.com/SexSkill/api/UserLikeOnProfile
    //    Keys:SendByID,UserID,Peakcontrol,Playfulness,Presence,Empathy,Deeporgasms,Leading,Following,Sextalk,Youlookhot,Youaresexy,Youareagreatkisser,Youhaveasexybody,Youhavegreathands,Yourareverymasculine,Youareagreatfuck,Youareagreatperson,Youareagoodcocksucker,Ilikeyourlooks,Ilikeyourbody,Ilikeyoursmell,IlikeyourCock,Ilikeyourpersonalitylikethewayyoutalktome,Ilikethewayyoulookatme,Ilikethewayyoutouchme,IlikethewayyouKissme,Ilikethewayyoulook,Iwouldintroduceyoutomyfriends,Iamattractedtoyou
    
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    
    [dictData setValue:[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"] forKey:@"SendByID"];
    [dictData setValue:_userID forKey:@"UserID"];
    
    
    [arrLikeSelected enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *strValuesKeys = [[arrLikeList objectAtIndex:idx] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [dictData setValue:[arrLikeSelected objectAtIndex:idx] forKey:strValuesKeys];
    }];
    
    NSLog(@"dictData---//---%@",dictData);
    
    [[SXCUtility singleton] getDataForUrl:SaveProfileLikes parameters:dictData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject valueForKey:@"Status"] && [[responseObject valueForKey:@"Status"] boolValue] == YES) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Likes saved Successfully!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 101;
            [alert show];
            
            NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
            [dictData setObject:arrLikeSelected forKey:@"liked"];
            [dictData setObject:arrLikeList forKey:@"likeList"];
            //            [likesFooter setupLikesFooter:dictData];
            [self profileType:@"like"];
            
        }else{
            [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}


@end
