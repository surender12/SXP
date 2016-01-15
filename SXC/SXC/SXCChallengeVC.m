//
//  SXCChallengeVC.m
//  SXC
//
//  Created by Ketan on 09/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCChallengeVC.h"
#import "SXCAcceptChallengeVC.h"
#import "SXCOtherChallenges.h"
#import "SXCLoginVC.h"

@interface SXCChallengeVC ()

@end

@implementation SXCChallengeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [SXCUtility lblTitleNavBar:@"Challenges"];
    self.navigationItem.title = @"";
    dictData = LoadPlist(@"Challenges");
    
    tbl_Challenge.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    NSLog(@"[SXCUtility singleton].dictChallenges---%@",[SXCUtility singleton].dictChallenges);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [tbl_Challenge reloadData];
}

#pragma mark
#pragma mark TableView DataSource/Delegate
#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dictData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UILabel *lblTitle, *lblDesc;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    UIImageView * indicator = (UIImageView *)[cell.contentView viewWithTag:1003];
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
       
        indicator.image = [UIImage imageNamed:@"accepted"];
        
    }else if(indexPath.row == 3 || indexPath.row == 4){
        
        if ([[[SXCUtility singleton].dictChallenges valueForKey:@"IsLocked"] isEqualToString:@"1"]) {
            indicator.image = [UIImage imageNamed:@"accepted"];
        }else
            indicator.image = [UIImage imageNamed:@"locked"];

    }else{
        indicator.image = [UIImage imageNamed:@"locked"];
    }
    
//    if ([[[SXCUtility singleton].dictChallenges valueForKey:[[dictData valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] objectAtIndex:4]] isEqualToString:@"1"]) {
//         indicator.image = [UIImage imageNamed:@"accepted"];
//    }else
//        indicator.image = [UIImage imageNamed:@"locked"];
    
    lblTitle = (UILabel *)[cell.contentView viewWithTag:1001];
    if (lblTitle) {
        lblTitle.text = [[dictData valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] objectAtIndex:0];
    }
    
    lblDesc = (UILabel *)[cell.contentView viewWithTag:1002];
    if (lblDesc) {
        lblDesc.text = [[dictData valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] objectAtIndex:1];
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
    
    if ([UserDefaults objectForKey:@"userData"]) {
        
        if (indexPath.row == 0) {
            
            SXCAcceptChallengeVC * objAccept = VCWithIdentifier(@"SXCAcceptChallengeVC");
            objAccept.strTitle = [[dictData valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] objectAtIndex:0];
            [self.navigationController pushViewController:objAccept animated:YES];
        }
        if (indexPath.row == 1 || indexPath.row == 2) {
            SXCOtherChallenges * objAccept = VCWithIdentifier(@"SXCOtherChallenges");
            objAccept.dictData = [dictData valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            [self.navigationController pushViewController:objAccept animated:YES];
        }
        if (indexPath.row == 3 || indexPath.row == 4) {
            if ([[[SXCUtility singleton].dictChallenges valueForKey:@"IsLocked"] integerValue] == 1) {
            SXCOtherChallenges * objAccept = VCWithIdentifier(@"SXCOtherChallenges");
            objAccept.dictData = [dictData valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            [self.navigationController pushViewController:objAccept animated:YES];
            }else{
                [ApplicationDelegate showAlert:[NSString stringWithFormat:@"Rate 1 user to unlock and access your %@",[[dictData valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] objectAtIndex:0]]];
            }
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
