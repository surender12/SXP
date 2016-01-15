//
//  SXCSideMenuVC.h
//  SXC
//
//  Created by Ketan on 08/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface SXCSideMenuVC : UIViewController
{
    __weak IBOutlet UITableView *tbl_Menu;
    NSArray *arrMenuItems;
    NSArray *arrImages;
}
@end
