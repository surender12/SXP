//
//  SXCSideMenuVC.m
//  SXC
//
//  Created by Ketan on 08/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCSideMenuVC.h"
#import "SXCPresentationVC.h"
#import "SXCAboutVC.h"
#import "SXCMyOpinionVC.h"
#import "SXCSettingsVC.h"
#import "SXCRegisterVC.h"
#import "SXCLoginVC.h"

@interface SXCSideMenuVC ()

@end

@implementation SXCSideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrMenuItems = @[@"SETTINGS",@"MY OPINION",@"ABOUT",@"PRIVATE POLICY",@"TERM OF USE",@"LOGOUT"];
    arrImages = @[@"setting",@"myopinion",@"about",@"privacy",@"terms",@"logout"];
}

#pragma mark
#pragma mark TableView DataSource/Delegate
#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrMenuItems count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UILabel *lblTitle;
    UIImageView * imgVw_icon;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    lblTitle = (UILabel *)[cell.contentView viewWithTag:101];
    if (lblTitle) {
        lblTitle.text = arrMenuItems[indexPath.row];
    }
    imgVw_icon = (UIImageView *)[cell.contentView viewWithTag:1258];
    if (imgVw_icon) {
        imgVw_icon.image = [UIImage imageNamed:arrImages[indexPath.row]] ;
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            //            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"firstViewController"]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            if ([UserDefaults objectForKey:@"userData"]) {
                SXCSettingsVC * objPre = VCWithIdentifier(@"SXCSettingsVC");
                [self.sideMenuViewController.navigationController presentViewController:objPre animated:NO completion:nil];
            }else{
                
                [[SXCUtility singleton] alertView:@"You are not aurthorised with SXC." :100 :self];
            }
            
            
        }
            break;
        case 1:
        {
            [self.sideMenuViewController hideMenuViewController];
            if ([UserDefaults objectForKey:@"userData"]) {
                SXCMyOpinionVC * objPre = VCWithIdentifier(@"SXCMyOpinionVC");
                [self.sideMenuViewController.navigationController presentViewController:objPre animated:NO completion:nil];
            }else{
                [[SXCUtility singleton] alertView:@"You are not aurthorised with SXC." :100 :self];
            }
            
        }
            break;
        case 2:
        {
            [self.sideMenuViewController hideMenuViewController];
            
            SXCAboutVC * objPre = VCWithIdentifier(@"SXCAboutVC");
            
            objPre.dictData = [[NSMutableDictionary alloc]init];
            [objPre.dictData setValue:@"About" forKey:@"type"];
            [objPre.dictData setValue:AboutUsText forKey:@"text"];
            [self.sideMenuViewController.navigationController presentViewController:objPre animated:NO completion:nil];
        }
            break;
        case 3:
        {
            [self.sideMenuViewController hideMenuViewController];
            
            SXCAboutVC * objPre = VCWithIdentifier(@"SXCAboutVC");
            objPre.dictData = [[NSMutableDictionary alloc]init];
            [objPre.dictData setValue:@"Private Policy" forKey:@"type"];
            [objPre.dictData setValue:PrivatePolicyText forKey:@"text"];
            [self.sideMenuViewController.navigationController presentViewController:objPre animated:NO completion:nil];
        }
            break;
        case 4:
        {
            [self.sideMenuViewController hideMenuViewController];
            
            SXCAboutVC * objPre = VCWithIdentifier(@"SXCAboutVC");
            objPre.dictData = [[NSMutableDictionary alloc]init];
            [objPre.dictData setValue:@"Term Of Use" forKey:@"type"];
            [objPre.dictData setValue:TermOfUseText forKey:@"text"];
            [self.sideMenuViewController.navigationController presentViewController:objPre animated:NO completion:nil];
        }
            break;
        case 5:
        {
            [self.sideMenuViewController hideMenuViewController];
            if ([UserDefaults objectForKey:@"userData"]) {
                
                [self callLogoutAPI];
                
            }
            
            //            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SXCRegisterVC"]] animated:YES];
            //            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        default:
            break;
    }
    
}
-(void)callLogoutAPI{
    [ApplicationDelegate loadingShow];
    //      http://www.trigmasolutions.com/SexSkill/api/Logout
    
    //  Keys: userId
    
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    
    [dictData setValue:[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"] forKey:@"userId"];
    
    
    [[SXCUtility singleton] getDataForUrl:LogoutUser parameters:dictData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject---%@",responseObject);
        
        [ApplicationDelegate loadingDismiss];
        if (responseObject && [responseObject valueForKey:@"Status"] && [[responseObject valueForKey:@"Status"] boolValue] == YES) {
            
            [UserDefaults removeObjectForKey:@"userData"];
            [UserDefaults synchronize];
            
            NSMutableDictionary *valueDictionary = [[NSMutableDictionary alloc]init];
            [valueDictionary setValue:@"0" forKey:@"PLAYFULLNESS"];
            [valueDictionary setValue:@"0" forKey:@"SEXTALK"];
            [valueDictionary setValue:@"0" forKey:@"PRESENCE"];
            [valueDictionary setValue:@"0" forKey:@"LEADING"];
            [valueDictionary setValue:@"0" forKey:@"DEEP ORGASMS"];
            [valueDictionary setValue:@"0" forKey:@"FOLLOWING"];
            [valueDictionary setValue:@"0" forKey:@"EMPATHY"];
            [valueDictionary setValue:@"0" forKey:@"PEAK CONTROL"];
            
            [SXCUtility singleton].dictRating = [valueDictionary mutableCopy];
            
            NSMutableDictionary *valueDictionary1 = [[NSMutableDictionary alloc]init];
            [valueDictionary1 setValue:@"0" forKey:@"AnalRelaxation"];
            [valueDictionary1 setValue:@"0" forKey:@"FreeFromPorn"];
            [valueDictionary1 setValue:@"0" forKey:@"LikeYourLovers"];
            [valueDictionary1 setValue:@"0" forKey:@"RateYourLover"];
            [valueDictionary1 setValue:@"0" forKey:@"ReceiveLikes"];
            [valueDictionary1 setValue:@"0" forKey:@"ReceiveRatings"];
            [valueDictionary1 setValue:@"0" forKey:@"TantricMasturbation"];
            [valueDictionary1 setValue:@"0" forKey:@"TwentryOneDayChallenge"];
            
            [SXCUtility singleton].dictChallenges = [valueDictionary1 mutableCopy];
            
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"LogoutNotification"
             object:self];
            [ApplicationDelegate showAlert:@"Logout Successfully."];
            
        }else{
            [ApplicationDelegate showAlert:@"Something went wrong. Please try again."];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100) {
        if (buttonIndex == 2) {
            SXCRegisterVC * objPre = VCWithIdentifier(@"SXCRegisterVC");
            [self.sideMenuViewController.navigationController presentViewController:objPre animated:NO completion:nil];
        }else if(buttonIndex == 1){
            SXCLoginVC * objPre = VCWithIdentifier(@"SXCLoginVC");
            [self.sideMenuViewController.navigationController presentViewController:objPre animated:NO completion:nil];
        }
    }
}

@end
