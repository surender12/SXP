//
//  SXCOtherChallenges.m
//  SXC
//
//  Created by Ketan on 20/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCOtherChallenges.h"

@interface SXCOtherChallenges ()

@end

@implementation SXCOtherChallenges

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"";
    self.navigationItem.titleView = [SXCUtility lblTitleNavBar:
                                     [_dictData objectAtIndex:0]];
    self.navigationItem.leftBarButtonItem = [SXCUtility leftbar:[UIImage imageNamed:@"backArrow"] :self];
    NSLog(@"_dictData---%@",_dictData);
    
    lbl_Desc.text = [[_dictData objectAtIndex:2]stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
    [lbl_Desc setFrame:CGRectMake(lbl_Desc.frame.origin.x, lbl_Desc.frame.origin.y, lbl_Desc.frame.size.width, [self getLabelHeight:lbl_Desc])];
    
    scrollVw_Container.contentSize = CGSizeMake(320, 300+[self getLabelHeight:lbl_Desc]);
    
    imgVw_Cat.image = [UIImage imageNamed:[_dictData objectAtIndex:3]];
    
    if ([[[SXCUtility singleton].dictChallenges valueForKey:[_dictData objectAtIndex:4]] isEqualToString:@"1"]) {
        btnAccept.selected = YES;
    }else{
        btnAccept.selected = NO;
    }
    
}

-(void)leftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, 20000.0f);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
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

- (IBAction)btnPressed_Accept:(id)sender {
    
    if ([sender isSelected]) {
        [sender setSelected:NO];
        [[SXCUtility singleton].dictChallenges setValue:@"0" forKey:[_dictData objectAtIndex:4]];
        [self callSaveChallengesAPI];
        
    }else{
        [sender setSelected:YES];
        [[SXCUtility singleton].dictChallenges setValue:@"1" forKey:[_dictData objectAtIndex:4]];
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
            
        }else{
            [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}

@end
