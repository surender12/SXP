//
//  SXCSubSkillsVC.h
//  SXC
//
//  Created by Ketan on 12/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXCSubSkillsVC : UIViewController{
    
    __weak IBOutlet UITableView *tbl_Skills;
    NSDictionary * dictData;
    NSMutableArray * arrSel;
}
@property (nonatomic, strong) NSString * strTitle;
@end
