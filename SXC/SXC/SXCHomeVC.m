//
//  SXCHomeVC.m
//  SXC
//
//  Created by Ketan on 08/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCHomeVC.h"
#import "SXCSubSkillsVC.h"
#import "SXCFilterTblVW.h"
#import "SXCGraphView.h"
#import "SXCMySkillFooter.h"
#import "SXCFeedbackFooter.h"
#import "SXCLoginVC.h"


@interface SXCHomeVC ()

@end

@implementation SXCHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"";
    self.navigationItem.titleView = [SXCUtility lblTitleNavBar:@"What I think of me"];
    self.navigationItem.rightBarButtonItems = [SXCUtility rightbar:[UIImage imageNamed:@"infoBtn"] :nil :self];
    
    graphView = [[[NSBundle mainBundle] loadNibNamed:@"SXCGraphView" owner:self options:nil] lastObject];
    strFriendID = [[NSDictionary alloc]init];
    [graphView setupGraph];
    [graphView viewSelected:NO :nil];
    graphView.delegate = self;
    
    tbl_container.tableHeaderView = graphView;
    
    mySkillFooter = [[[NSBundle mainBundle] loadNibNamed:@"SXCMySkillFooter" owner:self options:nil] lastObject];
    mySkillFooter.delegate = self;
    
    tbl_container.tableFooterView = mySkillFooter;
    
    arrListOfSkills = @[@{@"skill":@"PEAK CONTROL",@"description":@"Learn to control the peak orgasm."},@{@"skill":@"SEXTALK",@"description":@"Learn to say the right words."},@{@"skill":@"PRESENCE",@"description":@"How present are you with your lover?"},@{@"skill":@"LEADING",@"description":@"Guide your lover into horniness."},@{@"skill":@"DEEP ORGASMS",@"description":@"Experience deep tantric orgasms."},@{@"skill":@"PLAYFULLNESS",@"description":@"A doorway to deeper horniness."},@{@"skill":@"EMPATHY",@"description":@"Know your lovers deepest longing."},@{@"skill":@"FOLLOWING",@"description":@"Let yourself be guided deeper."}];
    
    toolBr.hidden = YES;
    datePkr_Calendar.hidden = YES;
    datePkr_Calendar.backgroundColor = [UIColor whiteColor];
    datePkr_Calendar.maximumDate = [NSDate date];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLogoutNotification:)
                                                 name:@"LogoutNotification"
                                               object:nil];
    
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
    
    
    NSMutableDictionary *valueDictionary = [[NSMutableDictionary alloc]init];
    [valueDictionary setValue:@"0" forKey:@"AnalRelaxation"];
    [valueDictionary setValue:@"0" forKey:@"FreeFromPorn"];
    [valueDictionary setValue:@"0" forKey:@"LikeYourLovers"];
    [valueDictionary setValue:@"0" forKey:@"RateYourLover"];
    [valueDictionary setValue:@"0" forKey:@"ReceiveLikes"];
    [valueDictionary setValue:@"0" forKey:@"ReceiveRatings"];
    [valueDictionary setValue:@"0" forKey:@"TantricMasturbation"];
    [valueDictionary setValue:@"0" forKey:@"TwentryOneDayChallenge"];
    [valueDictionary setValue:@"0" forKey:@"IsLocked"];
    
    [SXCUtility singleton].dictChallenges = [valueDictionary mutableCopy];
    strTypeSelected = @"MySkills";
    
    if ([UserDefaults objectForKey:@"userData"]) {
        
        [self callMyRatings:strTypeSelected friendID:@"0"];
        
    }
    
    
    
}

-(void)callSkillTypeNotification:(NSString*)value{
    
    NSDictionary* userInfo = @{@"isClickable":value};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SkillTypeNotification" object:self userInfo:userInfo];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if ([[SXCUtility singleton] isLoginRegi]) {
        [SXCUtility singleton].isLoginRegi = NO;
        [self callMyRatings:strTypeSelected friendID:@"0"];
    }
    if ([strTypeSelected isEqualToString:@"MySkills"]) {
        [graphView viewSelected:NO :nil];
        [graphView graphReload:YES];
    }else{
        if ([[[SXCUtility singleton].dictChallenges valueForKey:@"ReceiveRatings"] isEqualToString:@"1"]) {
            
            if ([strTypeSelected isEqualToString:@"OtherSay"]) {
                [graphView viewSelected:YES :nil];
                [self callMyRatings:strTypeSelected friendID:@"0"];
            }else{
                [graphView viewSelected:YES :[strFriendID valueForKey:@"image"]];
                [self callMyRatings:strTypeSelected friendID:[strFriendID valueForKey:@"friendID"]];
            }
            
        }else{
            [graphView viewSelected:YES :nil];
            [graphView graphReload:NO];
        }
        if ([[[SXCUtility singleton].dictChallenges valueForKey:@"ReceiveLikes"] isEqualToString:@"1"]) {
            if ([strTypeSelected isEqualToString:@"OtherSay"]) {
                [graphView viewSelected:YES :nil];
                feedbackFooter.isMyFeeback = YES;
                [self callMyRatings:strTypeSelected friendID:@"0"];
            }else{
                feedbackFooter.isMyFeeback = NO;
                [graphView viewSelected:YES :[strFriendID valueForKey:@"image"]];
                [self callMyRatings:strTypeSelected friendID:[strFriendID valueForKey:@"friendID"]];
            }
        }else{
            [feedbackFooter setupLikesFooter:nil];
            [tbl_container reloadData];
        }
        
    }
    //    [graphView graphReload:YES];
}


- (void) receiveLogoutNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"LogoutNotification"]){
        NSLog (@"Successfully received the LogoutNotification!");
        [graphView graphReload:YES];
        
    }
}

#pragma mark
#pragma mark MySkillsSpiderGraph Delegate
#pragma mark
- (void)skillType:(NSString *)value{
    if ([UserDefaults objectForKey:@"userData"]) {
        
        SXCSubSkillsVC * obj_SubSkills = VCWithIdentifier(@"SXCSubSkillsVC");
        obj_SubSkills.strTitle = value;
        [self.navigationController pushViewController:obj_SubSkills animated:YES];
        
    }else{
        
        [[SXCUtility singleton] alertView:@"You are not aurthorised with SXC." :100 :self];
    }

}

- (void)calendarTapped{
    if ([UserDefaults objectForKey:@"userData"]) {
        if ([[[SXCUtility singleton].dictChallenges valueForKey:@"TwentryOneDayChallenge"] isEqualToString:@"1"]) {
            toolBr.hidden = NO;
            datePkr_Calendar.hidden = NO;
        }else{
            [ApplicationDelegate showAlert:@"Please accept 21 DAY CHALLENGE"];
        }
        
        
    }else{
        
        [[SXCUtility singleton] alertView:@"You are not aurthorised with SXC." :100 :self];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100) {
        if (buttonIndex == 2) {
            SXCRegisterVC * objPre = VCWithIdentifier(@"SXCRegisterVC");
            [self.navigationController presentViewController:objPre animated:NO completion:nil];
        }else if(buttonIndex == 1){
            SXCLoginVC * objPre = VCWithIdentifier(@"SXCLoginVC");
            [self.navigationController presentViewController:objPre animated:NO completion:nil];
        }
    }
}


- (void)mySkillsPressed:(NSString *)value{
    if ([UserDefaults objectForKey:@"userData"]) {
        
        if (isMySkills) {
            strTypeSelected = @"MySkills";
            [self callSkillTypeNotification:@"0"];
            self.navigationItem.titleView = [SXCUtility lblTitleNavBar:@"What I think of me"];
            [graphView viewSelected:NO :nil];
            tbl_container.tableFooterView = mySkillFooter;
            self.navigationItem.rightBarButtonItems = [SXCUtility rightbar:[UIImage imageNamed:@"infoBtn"] :nil :self];
            
            [self callMyRatings:strTypeSelected friendID:@"0"];
            isMySkills = NO;
        }
        
        
    }else{
        
        [[SXCUtility singleton] alertView:@"You are not aurthorised with SXC." :100 :self];
    }
    
}
- (void)feedbackPressed:(NSString *)value{
    if ([UserDefaults objectForKey:@"userData"]) {
        
        if (!isMySkills) {
            strTypeSelected = @"OtherSay";
            [self callSkillTypeNotification:@"1"];
            self.navigationItem.titleView = [SXCUtility lblTitleNavBar:@"What others say of me"];
            
            [graphView viewSelected:YES :nil];
            feedbackFooter = [[[NSBundle mainBundle] loadNibNamed:@"SXCFeedbackFooter" owner:self options:nil] lastObject];
            feedbackFooter.isMyFeeback = YES;
            NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
            [dictData setObject:arrLikeSelected forKey:@"liked"];
            [dictData setObject:arrLikeList forKey:@"likeList"];
            [feedbackFooter setupLikesFooter:dictData];
            
            tbl_container.tableFooterView = feedbackFooter;
            [tbl_container reloadData];
            self.navigationItem.rightBarButtonItems = [SXCUtility rightbar:nil :@"FILTER" :self];
            
            [self callMyRatings:strTypeSelected friendID:@"0"];
            isMySkills = YES;
        }
        
        
    }else{
        
        [[SXCUtility singleton] alertView:@"You are not aurthorised with SXC." :100 :self];
    }
    
}


-(void)rightBtn{
    
}

-(void)rightBtnTxt
{
    if ([UserDefaults objectForKey:@"userData"]) {
        if ([[[SXCUtility singleton].dictChallenges valueForKey:@"ReceiveRatings"] integerValue] == 1) {
            UIView * sdf = self.view.subviews.lastObject;
            if ([sdf isKindOfClass:[SXCFilterTblVW class]]) {
                [sdf removeFromSuperview];
            }else{
                SXCFilterTblVW * filterView = [[[NSBundle mainBundle] loadNibNamed:@"SXCFilterTblVW" owner:self options:nil] lastObject];
                [filterView callSetup];
                filterView.blockFilter = ^(NSDictionary*dictData){
                    
                    NSLog(@"dictData--%@",dictData);
                    if ([[dictData valueForKey:@"title"] isEqualToString:@"Individuals rating"] || [[dictData valueForKey:@"title"] isEqualToString:@"What I think of me"] || [[dictData valueForKey:@"title"] isEqualToString:@"What others say of me"]) {
                        self.navigationItem.titleView = [SXCUtility lblTitleNavBar:[dictData valueForKey:@"title"]];
                        [graphView viewSelected:YES :nil];
                        feedbackFooter.isMyFeeback = YES;
                        
                        strTypeSelected = @"OtherSay";
                        [self callMyRatings:strTypeSelected friendID:@"0"];
                    }else{
                        self.navigationItem.titleView = [SXCUtility lblTitleNavBar:[NSString stringWithFormat:@"Feedback: %@",[dictData valueForKey:@"title"]]];
                        feedbackFooter.isMyFeeback = NO;
                        [graphView viewSelected:YES :[dictData valueForKey:@"image"]];
                        
                        strTypeSelected = @"FriendRating";
                        strFriendID = dictData;
                        [self callMyRatings:strTypeSelected friendID:[dictData valueForKey:@"friendID"]];
                        
                    }
                    
                    
                };
                [self.view addSubview:filterView];
            }
        }else{
            [ApplicationDelegate showAlert:@"Accept RECEIVE RATINGS Challenge."];
        }
    }else{
        
        [[SXCUtility singleton] alertView:@"You are not aurthorised with SXC." :100 :self];
    }
    
}

#pragma mark
#pragma mark TableView DataSource/Delegate
#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //    return arrListOfSkills.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UILabel *lblTitle, *lbl_Desc;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    lblTitle = (UILabel *)[cell.contentView viewWithTag:1001];
    lbl_Desc = (UILabel *)[cell.contentView viewWithTag:1002];
    if (lblTitle) {
        lblTitle.text = [[arrListOfSkills objectAtIndex:indexPath.row] valueForKey:@"skill"];
    }
    if (lbl_Desc) {
        lbl_Desc.text = [[arrListOfSkills objectAtIndex:indexPath.row] valueForKey:@"description"];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SXCSubSkillsVC * obj_SubSkills = VCWithIdentifier(@"SXCSubSkillsVC");
    obj_SubSkills.strTitle = [[arrListOfSkills objectAtIndex:indexPath.row] valueForKey:@"skill"];
    [self.navigationController pushViewController:obj_SubSkills animated:YES];
    
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

- (IBAction)btnPressed_DoneCal:(id)sender {
    
    toolBr.hidden = YES;
    datePkr_Calendar.hidden = YES;
    
    NSDate *date1 = datePkr_Calendar.date;
    NSDate *date2 = [NSDate date];
    
    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
    
    int numberOfDays = secondsBetween / 86400;
    
    [mySkillFooter setUpCalendarView:[NSString stringWithFormat:@"%d",numberOfDays]];
    
    [self callSaveOrgasmDateAPI:[NSString stringWithFormat:@"%d",numberOfDays]];
    
}

-(void)callMyRatings :(NSString*)strType friendID:(NSString*)strID{
    [ApplicationDelegate loadingShow];
    
    //      http://www.trigmasolutions.com/SexSkill/api/GetAllSkills
    
    //      Keys:UserID,GetSkillType(MySkills)
    [mySkillFooter setUpCalendarView:@"0"];
    
    [[SXCUtility singleton] getDataGETForUrl:[NSString stringWithFormat:@"%@%@/%@/%@",GetMySkillsRating,[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"],strType,strID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject objectAtIndex:0] && [[responseObject objectAtIndex:0] valueForKey:@"Status"] && [[[responseObject objectAtIndex:0] valueForKey:@"Status"] boolValue] == YES) {
            
            [[SXCUtility singleton].dictRating setValue:[[responseObject objectAtIndex:0] valueForKey:@"Playfullness"] forKey:@"PLAYFULLNESS"];
            [[SXCUtility singleton].dictRating setValue:[[responseObject objectAtIndex:0] valueForKey:@"SexTalk"] forKey:@"SEXTALK"];
            [[SXCUtility singleton].dictRating setValue:[[responseObject objectAtIndex:0] valueForKey:@"Presence"] forKey:@"PRESENCE"];
            [[SXCUtility singleton].dictRating setValue:[[responseObject objectAtIndex:0] valueForKey:@"Leading"] forKey:@"LEADING"];
            [[SXCUtility singleton].dictRating setValue:[[responseObject objectAtIndex:0] valueForKey:@"Deeporgasms"] forKey:@"DEEP ORGASMS"];
            [[SXCUtility singleton].dictRating setValue:[[responseObject objectAtIndex:0] valueForKey:@"Following"] forKey:@"FOLLOWING"];
            [[SXCUtility singleton].dictRating setValue:[[responseObject objectAtIndex:0] valueForKey:@"Empathy"] forKey:@"EMPATHY"];
            [[SXCUtility singleton].dictRating setValue:[[responseObject objectAtIndex:0] valueForKey:@"PeakControl"] forKey:@"PEAK CONTROL"];
            [mySkillFooter setUpCalendarView:[[responseObject objectAtIndex:0] valueForKey:@"UsersOrgism"]];
            
            if ([strType isEqualToString:@"FriendRating"] || [strType isEqualToString:@"OtherSay"]) {
                
                
                if (![[[responseObject objectAtIndex:0] valueForKey:@"UsersTotalLikes"] isKindOfClass:[NSNull class]] && [[[responseObject objectAtIndex:0] valueForKey:@"UsersTotalLikes"] objectAtIndex:0] && [[[[[responseObject objectAtIndex:0] valueForKey:@"UsersTotalLikes"] objectAtIndex:0] valueForKey:@"Status"] boolValue] == YES) {
                    [arrLikeSelected enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSString *strValuesKeys = [[arrLikeList objectAtIndex:idx] stringByReplacingOccurrencesOfString:@" " withString:@""];
                        
                        NSLog(@"strValuesKeys---%@",strValuesKeys);
                        
                        if ([[[[responseObject objectAtIndex:0] valueForKey:@"UsersTotalLikes"] objectAtIndex:0] valueForKey:strValuesKeys]!= [NSNull null]) {
                            [arrLikeSelected replaceObjectAtIndex:idx withObject:[[[[responseObject objectAtIndex:0] valueForKey:@"UsersTotalLikes"] objectAtIndex:0] valueForKey:strValuesKeys]];
                        }
                        
                    }];
                    tbl_container.tableFooterView = nil;
                    
                    if ([strType isEqualToString:@"FriendRating"]) {
                        feedbackFooter.isMyFeeback = NO;
                    }
                    
                    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
                    [dictData setObject:arrLikeSelected forKey:@"liked"];
                    [dictData setObject:arrLikeList forKey:@"likeList"];
                    [feedbackFooter setupLikesFooter:dictData];
                    tbl_container.tableFooterView = feedbackFooter;
                    
                }
                NSLog(@"arrLikeSelected---%@",arrLikeSelected);
            }
            
            if (![[[responseObject objectAtIndex:0] valueForKey:@"UserSaveChallenges"] isKindOfClass:[NSNull class]] && [[[responseObject objectAtIndex:0] valueForKey:@"UserSaveChallenges"] objectAtIndex:0] && [[[[[responseObject objectAtIndex:0] valueForKey:@"UserSaveChallenges"] objectAtIndex:0] valueForKey:@"Status"] boolValue] == YES) {
                
                [[SXCUtility singleton].dictChallenges  setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"UserSaveChallenges"] objectAtIndex:0] valueForKey:@"AnalRelaxation"] forKey:@"AnalRelaxation"];
                [[SXCUtility singleton].dictChallenges setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"UserSaveChallenges"] objectAtIndex:0] valueForKey:@"FreeFromPorn"] forKey:@"FreeFromPorn"];
                [[SXCUtility singleton].dictChallenges setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"UserSaveChallenges"] objectAtIndex:0] valueForKey:@"LikeYourLovers"] forKey:@"LikeYourLovers"];
                [[SXCUtility singleton].dictChallenges setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"UserSaveChallenges"] objectAtIndex:0] valueForKey:@"RateYourLover"] forKey:@"RateYourLover"];
                [[SXCUtility singleton].dictChallenges setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"UserSaveChallenges"] objectAtIndex:0] valueForKey:@"ReceiveLikes"] forKey:@"ReceiveLikes"];
                [[SXCUtility singleton].dictChallenges setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"UserSaveChallenges"] objectAtIndex:0] valueForKey:@"ReceiveRatings"] forKey:@"ReceiveRatings"];
                [[SXCUtility singleton].dictChallenges setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"UserSaveChallenges"] objectAtIndex:0] valueForKey:@"TantricMasturbation"] forKey:@"TantricMasturbation"];
                [[SXCUtility singleton].dictChallenges setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"UserSaveChallenges"] objectAtIndex:0] valueForKey:@"TwentryOneDayChallenge"] forKey:@"TwentryOneDayChallenge"];
                [[SXCUtility singleton].dictChallenges setValue:[[[[responseObject objectAtIndex:0] valueForKey:@"UserSaveChallenges"] objectAtIndex:0] valueForKey:@"IsLocked"] forKey:@"IsLocked"];
                
            }else{
                
            }
            NSLog(@"[SXCUtility singleton].dictChallenges---%@",[SXCUtility singleton].dictChallenges);
            [tbl_container reloadData];
            
            if ([strType isEqualToString:@"FriendRating"] || [strType isEqualToString:@"OtherSay"]) {
                if ([[[SXCUtility singleton].dictChallenges valueForKey:@"ReceiveRatings"] integerValue] == 1) {
                    [graphView graphReload:YES];
                }else{
                    [graphView graphReload:NO];
                }
            }else{
                
                [graphView graphReload:YES];
            }
            
        }else{
            if ([[[SXCUtility singleton].dictChallenges valueForKey:@"ReceiveRatings"] integerValue] == 1 || !isMySkills) {
                self.navigationItem.prompt = @"No Rating Found";
//            [ApplicationDelegate showAlert:@"No Rating Found"];
                [self performSelector:@selector(removePrompt) withObject:nil afterDelay:3];
            }
            
            [graphView graphReload:NO];
        }
        
        [ApplicationDelegate loadingDismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}

-(void)removePrompt{
    
    self.navigationItem.prompt = nil;
}

-(void)callSaveOrgasmDateAPI :(NSString*)days{
    [ApplicationDelegate loadingShow];
    //      http://www.trigmasolutions.com/SexSkill/api/SaveUserOrgism
    
    //      Keys:UserID,OrgasimDate
    
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    
    [dictData setValue:[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"] forKey:@"UserID"];
    [dictData setValue:days forKey:@"OrgasimDate"];
    
    
    [[SXCUtility singleton] getDataForUrl:SaveOrgasmDate parameters:dictData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject valueForKey:@"Status"] && [[responseObject valueForKey:@"Status"] boolValue] == YES) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Saved Successfully!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 101;
            [alert show];
            
        }else{
            [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}

@end
