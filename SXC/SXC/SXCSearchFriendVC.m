//
//  SXCSearchFriendVC.m
//  SXC
//
//  Created by Ketan on 02/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCSearchFriendVC.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface SXCSearchFriendVC ()

@end

@implementation SXCSearchFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"";
    
    self.navigationItem.titleView = [SXCUtility lblTitleNavBar:@"Search Friends"];
    self.navigationItem.leftBarButtonItem = [SXCUtility leftbar:[UIImage imageNamed:@"backArrow"] :self];
    //    self.navigationItem.rightBarButtonItem = [SXCUtility rightbar:nil :@"X" :self];
    
    tbl_searchUser.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    arrIsFriend = [[NSMutableArray alloc]init];
}

-(void)leftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)rightBtn
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark
#pragma mark TableView DataSource/Delegate
#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrData.count>0 && [[arrData objectAtIndex:0] isKindOfClass:[NSArray class]]) {
        return [[arrData objectAtIndex:0]count];
    }
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UILabel *lblTitle;
    UIImageView *imgVwPic;
    UIButton *btn_Add;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    [arrIsFriend addObject:[[[arrData objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"FreindStatus"]];
    NSLog(@"isfriend----%@",arrIsFriend);
    
    lblTitle = (UILabel *)[cell.contentView viewWithTag:101];
    if (lblTitle) {
        lblTitle.text = [[[arrData objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"UserName"];
    }
    
    imgVwPic = (UIImageView *)[cell.contentView viewWithTag:102];
    if (imgVwPic) {
        if ([[[arrData objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"ProfileImage"]) {
            [imgVwPic sd_setImageWithURL:[NSURL URLWithString:[[[arrData objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"ProfileImage"]]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   
                               }];
        }else{
            [imgVwPic sd_setImageWithURL:[NSURL URLWithString:@""]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   
                               }];
        }
    }
    btn_Add = (UIButton *)[cell.contentView viewWithTag:107];
    if (btn_Add) {
        if ([[[[arrData objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"FreindStatus"] isEqualToString:@"No Friend"]) {
            [btn_Add setImage:[UIImage imageNamed:@"addP"] forState:UIControlStateNormal];
        }else{
            [btn_Add setImage:[UIImage imageNamed:@"accepted"] forState:UIControlStateNormal];
        }
        
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
    
    
}


-(void)callSearchUserAPI :(NSString*)searchtxt{
    [ApplicationDelegate loadingShow];
    //      http://www.trigmasolutions.com/SexSkill/api/SearchUsers
    
    //      Keys:UserID,SearchText
    
    [[SXCUtility singleton] getDataGETForUrl:[NSString stringWithFormat:@"%@%@/%@",SearchUser,[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"],searchtxt] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [[responseObject objectAtIndex:0] valueForKey:@"Status"] && [[[responseObject objectAtIndex:0] valueForKey:@"Status"] boolValue] == YES) {
            [arrIsFriend removeAllObjects];
            arrData = [[NSMutableArray alloc]init];
            [arrData addObject:responseObject];
            NSLog(@"arrData--%@",arrData);
            [tbl_searchUser reloadData];
        }else{
//            self.navigationItem.prompt = @"No Result Found";
//            [self performSelector:@selector(removePrompt) withObject:nil afterDelay:3];
            
            [ApplicationDelegate showAlert:@"No Result Found"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}

//-(void)removePrompt{
//    
//    self.navigationItem.prompt = nil;
//}

#pragma mark - Search Implementation
#pragma mark
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    [searchBar setShowsCancelButton:YES animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        //        [tbl_searchUser reloadData];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [arrIsFriend removeAllObjects];
    [arrData removeAllObjects];
    
    [tbl_searchUser reloadData];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //    [self filterContentForSearchText:searchBar.text];
    
    if (searchBar.text.length != 0 && [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
    {
        if ([[SXCUtility singleton] checkLetter:searchBar.text]) {
            [self callSearchUserAPI :[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }else
        [ApplicationDelegate showAlert:@"Please enter valid name."];
    }else{
        [ApplicationDelegate showAlert:@"Please enter valid name."];
    }
    
    [searchBar resignFirstResponder];
    
}


-(void)filterContentForSearchText:(NSString*)searchText
{
    //    [filteredArray removeAllObjects];
    //    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"medicineName beginswith[c] %@", searchText];
    
    //    filteredArray =[NSMutableArray arrayWithArray:[mainArr filteredArrayUsingPredicate:resultPredicate]];
    
    //    [tblVw_contacts reloadData];
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

- (IBAction)btnPressed_AddUser:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_searchUser];
    NSIndexPath *indexPath = [tbl_searchUser indexPathForRowAtPoint:buttonPosition];
    UITableViewCell * cell = [tbl_searchUser cellForRowAtIndexPath:indexPath];
    UIButton *btn_Add;
    btn_Add = (UIButton *)[cell.contentView viewWithTag:107];
    if (btn_Add) {
        if ([[arrIsFriend objectAtIndex:indexPath.row] isEqualToString:@"No Friend"]) {
            [btn_Add setImage:[UIImage imageNamed:@"accepted"] forState:UIControlStateNormal];
            [arrIsFriend replaceObjectAtIndex:indexPath.row withObject:@"Friend"];
            [self callAddFriendAPI:@"Friend" :[[[arrData  objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"UserID"]];
        }else{
            [btn_Add setImage:[UIImage imageNamed:@"addP"] forState:UIControlStateNormal];
            [arrIsFriend replaceObjectAtIndex:indexPath.row withObject:@"No Friend"];
            [self callAddFriendAPI:@"Un Friend" :[[[arrData objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"UserID"]];
        }
    }
    
}

-(void)callAddFriendAPI :(NSString *)type :(NSString*)userID{
    [ApplicationDelegate loadingShow];
    //      http://www.trigmasolutions.com/SexSkill/api/AddUserToFriedList
    
    //      Keys:AddUserID,SentByID,AddedDateTime
    
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    
    [dictData setValue:userID forKey:@"AddUserID"];
    [dictData setValue:[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"] forKey:@"SentByID"];
    [dictData setValue:[[SXCUtility singleton] dateFormat:@"MM-dd-yyyy HH:mm:ss" :[NSDate date]] forKey:@"AddedDateTime"];
    [dictData setValue:type forKey:@"AddfriendKey"];
    
    [[SXCUtility singleton] getDataForUrl:AddFriend parameters:dictData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject---%@",responseObject);
        
        [ApplicationDelegate loadingDismiss];
        if (responseObject && [responseObject valueForKey:@"Status"] && [[responseObject valueForKey:@"Status"] boolValue] == YES) {
            
            [ApplicationDelegate showAlert:[responseObject valueForKey:@"Response"]];
        }else{
            [ApplicationDelegate showAlert:@"Something went wrong. Please try again."];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}


@end
