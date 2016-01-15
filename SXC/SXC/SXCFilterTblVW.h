//
//  SXCFilterTblVW.h
//  SXC
//
//  Created by Ketan on 16/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCollapseTableView.h"

typedef void(^filterSelection)(NSMutableDictionary *dictData);

@interface SXCFilterTblVW : UIView{
    
    __weak IBOutlet STCollapseTableView *tbl_Filter;
    NSMutableArray * arrList;
    NSMutableArray * arrImages;
    NSMutableArray * arrFriendUserID;
    filterSelection blockFilter;
    
}

@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic, strong) NSMutableArray* headers;
-(void)reloadTableContentsWithInder:(NSInteger)index isOpen:(BOOL)open;
- (IBAction)btnPressed_Close:(id)sender;
-(void)callSetup;
@property (nonatomic, copy) filterSelection blockFilter;
@end
