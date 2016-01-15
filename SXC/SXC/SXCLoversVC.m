//
//  SXCLoversVC.m
//  SXC
//
//  Created by Ketan on 09/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCLoversVC.h"
#import "SXCUserProfileVC.h"
#import "SXCSearchFriendVC.h"
#import "SXCTableBackLover.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SXCLoginVC.h"

@interface SXCLoversVC ()

@end

@implementation SXCLoversVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [SXCUtility lblTitleNavBar:@"Lover(s)"];
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItems = [SXCUtility rightbar:[UIImage imageNamed:@"search"] :@"EDIT" :self];

    tbl_lovers.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLogoutNotification:)
                                                 name:@"LogoutNotification"
                                               object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    if ([UserDefaults objectForKey:@"userData"]) {
        arrData = nil;
        [self callGetFriendsAPI];
    }else{
        arrData = nil;
        [tbl_lovers reloadData];
//        [[SXCUtility singleton] alertView:@"You are not aurthorised with SXC." :100 :self];
        [self addBackView];
    }

    
}

- (void) receiveLogoutNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"LogoutNotification"]){
        NSLog (@"Successfully received the LogoutNotification!");
        arrData = nil;
        [self addBackView];
        [tbl_lovers reloadData];
        
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

-(void)callGetFriendsAPI{
    [ApplicationDelegate loadingShow];
//      http://www.trigmasolutions.com/SexSkill/api/GetAllFriends
    
//      Keys:UserID
    NSLog(@"[[UserDefaults ---%@",[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"]);
    [[SXCUtility singleton] getDataGETForUrl:[NSString stringWithFormat:@"%@%@",GetAllFriend,[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject objectAtIndex:0] && [[responseObject objectAtIndex:0] valueForKey:@"Status"] && [[[responseObject objectAtIndex:0] valueForKey:@"Status"] boolValue] == YES) {
            
            arrData = [[NSMutableArray alloc]init];
            [arrData addObject:responseObject];
            if ([[arrData objectAtIndex:0] count] == 0) {
                [self addBackView];
            }else{
                tbl_lovers.backgroundView = nil;
            }
            
        }else{
            [self addBackView];
        }

        
        NSLog(@"arrData--%@",arrData);
        [tbl_lovers reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}


-(void)addBackView{
    SXCTableBackLover * backView = [[[NSBundle mainBundle] loadNibNamed:@"TableBackLoverVw" owner:self options:nil] lastObject];
    backView.blockSearch =^(){
        if ([UserDefaults objectForKey:@"userData"]) {
            SXCSearchFriendVC* objsearch = VCWithIdentifier(@"SXCSearchFriendVC");
            [self.navigationController pushViewController:objsearch animated:YES];
        }else{
            [[SXCUtility singleton] alertView:@"You are not aurthorised with SXC." :100 :self];
        }
    };
    tbl_lovers.backgroundView = backView;
}

-(void)rightBtn
{
    if ([UserDefaults objectForKey:@"userData"]) {
        SXCSearchFriendVC* objsearch = VCWithIdentifier(@"SXCSearchFriendVC");
        [self.navigationController pushViewController:objsearch animated:YES];
    }else{
        [[SXCUtility singleton] alertView:@"You are not aurthorised with SXC." :100 :self];
    }
    
}
-(void)rightBtnTxt{
    
    if ([UserDefaults objectForKey:@"userData"]) {
        if ([tbl_lovers isEditing]) {
            [tbl_lovers setEditing: NO animated: YES];
            
        }else
            [tbl_lovers setEditing: YES animated: YES];
    }else{
        [[SXCUtility singleton] alertView:@"You are not aurthorised with SXC." :100 :self];
    }
    
}

#pragma mark
#pragma mark TableView DataSource/Delegate
#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arrData) {
        return [[arrData objectAtIndex:0] count];
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UILabel *lblTitle;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    lblTitle = (UILabel *)[cell.contentView viewWithTag:102];
    if (lblTitle) {
        lblTitle.text = [[[arrData objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"UserName"];
    }
    UIImageView *imgVwPic = (UIImageView *)[cell.contentView viewWithTag:101];
    if (imgVwPic) {
        [imgVwPic sd_setImageWithURL:[NSURL URLWithString:[[[arrData objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"ProfileImage"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
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
    
    SXCUserProfileVC * objUser = VCWithIdentifier(@"SXCUserProfileVC");
    objUser.userID = [[[arrData objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"UserID"];
    [self.navigationController pushViewController:objUser animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove here your data
        
        [self callAddFriendAPI:@"Un Friend" :[[[arrData objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"UserID"]];
    }
}

-(void)loversBtn{
//    UIView * backView = [[[NSBundle mainBundle] loadNibNamed:@"TableBackLoverVw" owner:self options:nil] lastObject];
//    tbl_lovers.backgroundView = backView;
    
    SXCUserProfileVC * objUser = VCWithIdentifier(@"SXCUserProfileVC");
    [self.navigationController pushViewController:objUser animated:YES];
    
}
-(void)fbContactsBtn{
    UIView * backView = [[[NSBundle mainBundle] loadNibNamed:@"SXCBackFBFriends" owner:self options:nil] lastObject];
    tbl_lovers.backgroundView = backView;
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
            
            [tbl_lovers setEditing: NO animated: YES];
            arrData = nil;
            [self callGetFriendsAPI];
            
//            [ApplicationDelegate showAlert:[responseObject valueForKey:@"Response"]];
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

@end
