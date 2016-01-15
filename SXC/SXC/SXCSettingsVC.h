//
//  SXCSettingsVC.h
//  SXC
//
//  Created by Ketan on 08/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base64.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface SXCSettingsVC : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,FBSDKAppInviteDialogDelegate>
{
    __weak IBOutlet UISwitch *slider_permission;
    __weak IBOutlet UIButton *btnProfilePic;
    __weak IBOutlet UITextField *txtFld_username;
    __weak IBOutlet UITextField *txtFld_email;
    __weak IBOutlet UITextField *txtFld_password;
    __weak IBOutlet UITextField *txtFld_birthday;
    __weak IBOutlet UITextField *txtFld_country;
    __weak IBOutlet UITextField *txtFld_status;
    __weak IBOutlet UITextField *txtFld_sexualOri;
    __weak IBOutlet UITextField *txtFld_Tantra;
    NSString * imgBase64;
    NSArray * arrPickerData;
    BOOL isValPkr;
    BOOL isDatePkr;
    BOOL isFeedback;
    
    __weak IBOutlet UIDatePicker *datePkr_B;
    __weak IBOutlet UIPickerView *pickr_S;
    __weak IBOutlet UIToolbar *toolBar_S;
    __weak IBOutlet UIImageView *imgVw_Profile;
}
- (IBAction)btnPressed_ImportFb:(id)sender;
- (IBAction)btnPressed_Save:(id)sender;
- (IBAction)btnPressed_ToolBarDone:(id)sender;

- (IBAction)btnPressed_Done:(id)sender;
- (IBAction)btnPressed_ProfilePic:(id)sender;
- (IBAction)valueChanges_Switch:(id)sender;
- (IBAction)btnPressed_txtFld:(id)sender;

@end
