//
//  SXCLoginVC.h
//  SXC
//
//  Created by Ketan on 08/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXCRegisterVC : UIViewController{
    
    __weak IBOutlet UIImageView *imgVwBackground;
    __weak IBOutlet UITextField *txtFld_username;
    __weak IBOutlet UITextField *txtFld_email;
    __weak IBOutlet UITextField *txtFld_password;
    __weak IBOutlet UITextField *txtFld_MobNo;
    __weak IBOutlet UIButton *btn_Terms;
}
- (IBAction)btnPressed_LoginWithFB:(id)sender;
- (IBAction)btnPressed_SignUp:(id)sender;
- (IBAction)btnPressed_SignIn:(id)sender;
- (IBAction)btnPressed_agreeTerms:(id)sender;
- (IBAction)btnPressed_termsAndCondi:(id)sender;
- (IBAction)btnPressed_Close:(id)sender;

@end
