//
//  SXCLoginVC.h
//  SXC
//
//  Created by Ketan on 17/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXCLoginVC : UIViewController{
    
    __weak IBOutlet UITextField *txtFld_username;
    __weak IBOutlet UITextField *txtFld_password;
    __weak IBOutlet UIImageView *imgVwBackground;

}
- (IBAction)btnPressed_withFB:(id)sender;
- (IBAction)btnPressed_login:(id)sender;
- (IBAction)btnPressed_forgotPassword:(id)sender;
- (IBAction)btnPressed_SignUp:(id)sender;
- (IBAction)btnPressed_Close:(id)sender;

@end
