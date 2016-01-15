//
//  SXCAboutVC.h
//  SXC
//
//  Created by Ketan on 08/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXCAboutVC : UIViewController
{
    
    __weak IBOutlet UILabel *lbl_Title;
    __weak IBOutlet UITextView *txtVw_Content;
}
- (IBAction)btnPressed_Done:(id)sender;
@property (nonatomic, strong) NSMutableDictionary * dictData;
@end
