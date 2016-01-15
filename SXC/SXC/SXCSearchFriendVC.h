//
//  SXCSearchFriendVC.h
//  SXC
//
//  Created by Ketan on 02/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXCSearchFriendVC : UIViewController{
    
    __weak IBOutlet UISearchBar *searchBar_search;
    __weak IBOutlet UITableView *tbl_searchUser;
    NSMutableArray * arrData;
    NSMutableArray * arrIsFriend;
    
}
- (IBAction)btnPressed_AddUser:(id)sender;

@end
