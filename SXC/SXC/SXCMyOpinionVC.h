//
//  SXCMyOpinionVC.h
//  SXC
//
//  Created by Ketan on 08/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXCMyOpinionVC : UIViewController{
    
    __weak IBOutlet UITextView *txtxVw_about;
    __weak IBOutlet UITextView *txtVw_improve;
}

- (IBAction)btnPressed_Save:(id)sender;
- (IBAction)btnPressed_Done:(id)sender;
@end
