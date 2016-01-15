//
//  SXCSubSkillsVC.m
//  SXC
//
//  Created by Ketan on 12/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCSubSkillsVC.h"

@interface SXCSubSkillsVC ()

@end

@implementation SXCSubSkillsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"";
    self.navigationItem.titleView = [SXCUtility lblTitleNavBar:_strTitle];
    self.navigationItem.leftBarButtonItem = [SXCUtility leftbar:[UIImage imageNamed:@"backArrow"] :self];
    
    dictData = LoadPlist(@"SkillsDescription");
    
    UIView * view = [[[NSBundle mainBundle] loadNibNamed:@"SubSkillHeader" owner:self options:nil] lastObject];
    UIImageView * backImg = (UIImageView*) [view viewWithTag:1023];
    UILabel * lblDesc = (UILabel*) [view viewWithTag:1024];
    if (backImg) {
        
        backImg.image = [UIImage imageNamed:[[dictData valueForKey:_strTitle] valueForKey:@"image"]];
    }
    if (lblDesc) {
        lblDesc.text = [[[dictData valueForKey:_strTitle] valueForKey:_strTitle] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    }
    tbl_Skills.tableHeaderView = view;
    
    NSInteger cnt = [[[dictData valueForKey:_strTitle] valueForKey:@"level"] count];
    arrSel = [[NSMutableArray alloc]init];
    
    for (int i = 0;i < cnt; i++) {
        [arrSel addObject:@"0"];
    }
    if ([[[SXCUtility singleton].dictRating valueForKey:_strTitle] integerValue] !=0) {
        [arrSel replaceObjectAtIndex:[[[SXCUtility singleton].dictRating valueForKey:_strTitle] integerValue]-1 withObject:@"1"];
    }
    
}

-(void)leftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
#pragma mark TableView DataSource/Delegate
#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[dictData valueForKey:_strTitle] valueForKey:@"level"] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UILabel *lbllvl, *lblDesc;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
    }

//    if ([[arrSel objectAtIndex:indexPath.row] integerValue] == 1) {
//        UIView *bgColorView = [[UIView alloc] init];
//        bgColorView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:191.0f/255.0f blue:99.0f/255.0f alpha:1.0f];
//        [cell setBackgroundView:bgColorView];
//    }
    

    lbllvl = (UILabel *)[cell.contentView viewWithTag:1001];
    if (lbllvl) {
        lbllvl.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    }
    
    if ([[arrSel objectAtIndex:indexPath.row] integerValue] == 1) {
        lbllvl.textColor = [UIColor colorWithRed:71.0f/255.0f green:191.0f/255.0f blue:99.0f/255.0f alpha:1.0f];
    }else{
        lbllvl.textColor = [UIColor whiteColor];
    }
    
    lblDesc = (UILabel *)[cell.contentView viewWithTag:1002];
    if (lblDesc) {
        lblDesc.text = [[[[dictData valueForKey:_strTitle] valueForKey:@"level"] objectAtIndex:indexPath.row]stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
//        [[[dictData valueForKey:_strTitle] valueForKey:_strTitle] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]
    }
    
    return cell;
    
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
    
    [[SXCUtility singleton].dictRating setValue:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:_strTitle];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [self callSaveMyRatingAPI];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
    });
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)callSaveMyRatingAPI{
//    [ApplicationDelegate loadingShow];
    //      http://www.trigmasolutions.com/SexSkill/api/SaveMyOwnSkill
    
    //      Keys:UserID,PeakControl,SexTalk,Presence,Leading,Deeporgasms,Playfullness,Empathy,Following
    
    NSMutableDictionary * dictDataRate = [[NSMutableDictionary alloc]init];
    
    [dictDataRate setValue:[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"] forKey:@"UserID"];
    [dictDataRate setValue:[[SXCUtility singleton].dictRating valueForKey:@"PEAK CONTROL"] forKey:@"PeakControl"];
    [dictDataRate setValue:[[SXCUtility singleton].dictRating valueForKey:@"SEXTALK"] forKey:@"SexTalk"];
    [dictDataRate setValue:[[SXCUtility singleton].dictRating valueForKey:@"PRESENCE"] forKey:@"Presence"];
    [dictDataRate setValue:[[SXCUtility singleton].dictRating valueForKey:@"LEADING"] forKey:@"Leading"];
    [dictDataRate setValue:[[SXCUtility singleton].dictRating valueForKey:@"DEEP ORGASMS"] forKey:@"Deeporgasms"];
    [dictDataRate setValue:[[SXCUtility singleton].dictRating valueForKey:@"PLAYFULLNESS"] forKey:@"Playfullness"];
    [dictDataRate setValue:[[SXCUtility singleton].dictRating valueForKey:@"EMPATHY"] forKey:@"Empathy"];
    [dictDataRate setValue:[[SXCUtility singleton].dictRating valueForKey:@"FOLLOWING"] forKey:@"Following"];
    
    
    [[SXCUtility singleton] getDataForUrl:SaveMyOwnRating parameters:dictDataRate success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject valueForKey:@"Status"] && [[responseObject valueForKey:@"Status"] boolValue] == YES) {
            
            //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Saved Successfully!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            alert.tag = 101;
            //            [alert show];
            
        }else{
            [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        [ApplicationDelegate loadingDismiss];
        
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

@end
