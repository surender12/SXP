//
//  SXCAcceptChallengeVC.m
//  SXC
//
//  Created by Ketan on 22/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCAcceptChallengeVC.h"

@interface SXCAcceptChallengeVC ()

@end

@implementation SXCAcceptChallengeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"";
    self.navigationItem.titleView = [SXCUtility lblTitleNavBar:
                                     _strTitle];
    self.navigationItem.leftBarButtonItem = [SXCUtility leftbar:[UIImage imageNamed:@"backArrow"] :self];
    
    collVw_Videos.hidden = YES;
    scrollVw_Container.contentSize = CGSizeMake(272, 1300);
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]
                                                   initWithString:@"INFO"];
    [attributedString1 addAttribute:NSUnderlineStyleAttributeName
                             value:@(NSUnderlineStyleSingle)
                             range:NSMakeRange(0, 4)];
    [attributedString1 addAttribute:NSFontAttributeName value:FontOpenSans(12) range:NSMakeRange(0, 4)];
    btn_Info.titleLabel.attributedText = attributedString1;
  
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:@"VIDEOS"];
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:@(NSUnderlineStyleSingle)
                             range:NSMakeRange(0, 6)];
    [attributedString addAttribute:NSFontAttributeName value:FontOpenSans(12) range:NSMakeRange(0, 6)];
    btn_Videos.titleLabel.attributedText = attributedString;
    btn_Videos.alpha = 0.5;
    
    arrVideoLinks = @[@"https://www.youtube.com/watch?v=PcE1tP7kFag",
                      @"https://www.youtube.com/watch?v=Srm5biS2R_A",
                      @"https://www.youtube.com/watch?v=bGvHj2otWwU",
                      @"https://www.youtube.com/watch?v=EAFKusQKmGU",
                      @"https://www.youtube.com/watch?v=h_9RLh3lPl8",
                      @"https://www.youtube.com/watch?v=7iENY0fswLU",
                      @"https://www.youtube.com/watch?v=imZoNGobynI",
                      @"https://www.youtube.com/watch?v=6H4B-ssPC3w",
                      @"https://www.youtube.com/watch?v=JaNEwfQzSjg",
                      @"https://www.youtube.com/watch?v=d2UxzWbcffE",
                      @"https://www.youtube.com/watch?v=y4dnvrsDgIo",
                      @"https://www.youtube.com/watch?v=AEelzkdhXwo",
                      @"https://www.youtube.com/watch?v=7ZmYh-mM9f4",
                      @"https://www.youtube.com/watch?v=glD1y5KHf8Y",
                      @"https://i.ytimg.com/vi/8sK8E8MYGh4/mqdefault.jpg",
                      @"https://www.youtube.com/watch?v=jJbcVuhtZhA",
                      @"https://www.youtube.com/watch?v=38GH9tsKW0Q",
                      @"https://www.youtube.com/watch?v=CT0OETR_pHE",
                      @"https://www.youtube.com/watch?v=AEelzkdhXwo",
                      @"https://www.youtube.com/watch?v=zWUbzm7WUhw",
                      @"https://www.youtube.com/watch?v=Eiswyf3a9H0",
                      @"https://www.youtube.com/watch?v=2RK4_-pO9hI"];
    
    if ([[[SXCUtility singleton].dictChallenges valueForKey:@"TwentryOneDayChallenge"] isEqualToString:@"1"]) {
        btn_Accept.selected = YES;
    }else{
        btn_Accept.selected = NO;
    }
    
    
}


-(void)leftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark Collection View Datasource/Delegates


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return 22;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView * imgThumb = (UIImageView*)[cell viewWithTag:1001];
    UILabel * lblTitle = (UILabel*)[cell viewWithTag:1002];
    if (lblTitle) {
        if (indexPath.row == 0) {
            lblTitle.text = @"Intro";
        }else{
            lblTitle.text = [NSString stringWithFormat:@"Day %ld",(long)indexPath.row];
        }
        
    }
    
    if (imgThumb) {
        if ([[[SXCUtility singleton].dictChallenges valueForKey:@"TwentryOneDayChallenge"] isEqualToString:@"1"]) {
            imgThumb.image = [UIImage imageNamed:@"youtubeLogo"];
        }else{
            imgThumb.image = [UIImage imageNamed:@"lockV"];
        }
        
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[SXCUtility singleton].dictChallenges valueForKey:@"TwentryOneDayChallenge"] isEqualToString:@"1"]) {
        NSDictionary * dict  = LoadPlist(@"iframe");
        
        TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc]initWithString:[dict valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        webBrowser.delegate = self;
        webBrowser.mode = TSMiniWebBrowserModeNavigation;
        webBrowser.showActionButton = NO;
        webBrowser.showReloadButton = NO;
        webBrowser.barStyle = UIBarStyleBlack;
        
        if (webBrowser.mode == TSMiniWebBrowserModeModal) {
            webBrowser.modalDismissButtonTitle = @"CLOSE";
            [self presentViewController:webBrowser animated:YES completion:nil];
        } else if(webBrowser.mode == TSMiniWebBrowserModeNavigation) {
            [self.navigationController pushViewController:webBrowser animated:YES];
        }

    }else{
        [ApplicationDelegate showAlert:@"Please accept 21 Day Challenge to watch videos."];
    }
   
}

-(void) tsMiniWebBrowserDidDismiss {
    NSLog(@"TSMiniWebBrowser was dismissed");
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

- (IBAction)btnPressed_InfoVideoTab:(UIButton*)sender {
    
    if (sender.tag == 1022) {
        collVw_Videos.hidden = YES;
        lbl_Info.hidden = NO;
        btn_Videos.alpha = 0.5;
        btn_Info.alpha = 1.0;
        
        scrollVw_Container.contentSize = CGSizeMake(272, 1300);
    }else{
        collVw_Videos.hidden = NO;
        lbl_Info.hidden = YES;
        btn_Videos.alpha = 1.0;
        btn_Info.alpha = 0.5;
        [collVw_Videos reloadData];
        float height = collVw_Videos.contentSize.height;
        [collVw_Videos setFrame:CGRectMake(collVw_Videos.frame.origin.x, collVw_Videos.frame.origin.y, collVw_Videos.frame.size.width, height)];
        
        scrollVw_Container.contentSize = CGSizeMake(272, 350+height);
    }
}

- (IBAction)btnPressed_Accept:(UIButton*)sender {
    
    if ([sender isSelected]) {
        [sender setSelected:NO];
        [[SXCUtility singleton].dictChallenges setValue:@"0" forKey:@"TwentryOneDayChallenge"];
        [self callSaveChallengesAPI];
        
    }else{
        [sender setSelected:YES];
        [[SXCUtility singleton].dictChallenges setValue:@"1" forKey:@"TwentryOneDayChallenge"];
        [self callSaveChallengesAPI];
    }
}

-(void)callSaveChallengesAPI{
    [ApplicationDelegate loadingShow];
//      http://www.trigmasolutions.com/SexSkill/api/SaveUserChallenges
    
//Keys:UserID,TwentryOneDayChallenge,LikeYourLovers,RateYourLover,ReceiveLikes,ReceiveRatings,FreeFromPorn,AnalRelaxation,TantricMasturbation
    
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    
    [dictData setValue:[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"] forKey:@"UserID"];
    [dictData setValue:[[SXCUtility singleton].dictChallenges valueForKey:@"TwentryOneDayChallenge"] forKey:@"TwentryOneDayChallenge"];
    [dictData setValue:[[SXCUtility singleton].dictChallenges valueForKey:@"LikeYourLovers"] forKey:@"LikeYourLovers"];
    [dictData setValue:[[SXCUtility singleton].dictChallenges valueForKey:@"RateYourLover"] forKey:@"RateYourLover"];
    [dictData setValue:[[SXCUtility singleton].dictChallenges valueForKey:@"ReceiveLikes"] forKey:@"ReceiveLikes"];
    [dictData setValue:[[SXCUtility singleton].dictChallenges valueForKey:@"ReceiveRatings"] forKey:@"ReceiveRatings"];
    [dictData setValue:[[SXCUtility singleton].dictChallenges valueForKey:@"FreeFromPorn"] forKey:@"FreeFromPorn"];
    [dictData setValue:[[SXCUtility singleton].dictChallenges valueForKey:@"AnalRelaxation"] forKey:@"AnalRelaxation"];
    [dictData setValue:[[SXCUtility singleton].dictChallenges valueForKey:@"TantricMasturbation"] forKey:@"TantricMasturbation"];
    
    
    [[SXCUtility singleton] getDataForUrl:SaveChallenges parameters:dictData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject valueForKey:@"Status"] && [[responseObject valueForKey:@"Status"] boolValue] == YES) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Saved Successfully!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 101;
            [alert show];
            [collVw_Videos reloadData];
            
        }else{
            [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        [ApplicationDelegate loadingDismiss];
    }];
    
    
}


@end
