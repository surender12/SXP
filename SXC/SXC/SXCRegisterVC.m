//
//  SXCLoginVC.m
//  SXC
//
//  Created by Ketan on 08/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCRegisterVC.h"
#import "SXCAboutVC.h"
#import "SXCRootMenuVC.h"

@interface SXCRegisterVC ()

@end

@implementation SXCRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IS_IPHONE_4) {
        imgVwBackground.image = [UIImage imageNamed:@"backgroundImg4"];
    }else
        imgVwBackground.image = [UIImage imageNamed:@"backgroundImg"];
    
}

-(void)callRegisterAPI :(NSString*)userType : (NSDictionary *)fbData{
    [ApplicationDelegate loadingShow];
    //        Usertype --->"Facebook","Email","UnVerified"
    //        Keys:Username,Email,PhoneNumber,DeviceType,DeviceToken,Usertype,password(This key will be used for Email,Facebook)
    
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    
    if ([userType isEqualToString:@"Facebook"]) {
        [dictData setValue:[fbData valueForKey:@"name"] forKey:@"Username"];
        if ([fbData valueForKey:@"email"]) {
            [dictData setValue:[fbData valueForKey:@"email"] forKey:@"Email"];
            [dictData setValue:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[fbData valueForKey:@"id"]] forKey:@"FacebookImage"];
        }
        [dictData setValue:@"" forKey:@"PhoneNumber"];
        [dictData setValue:@"" forKey:@"password"];
    }else{
        [dictData setValue:txtFld_username.text forKey:@"Username"];
        [dictData setValue:txtFld_email.text forKey:@"Email"];
        [dictData setValue:txtFld_MobNo.text forKey:@"PhoneNumber"];
        [dictData setValue:txtFld_password.text forKey:@"password"];
    }
    
    [dictData setValue:@"iphone" forKey:@"DeviceType"];
    if ([UserDefaults valueForKey:@"DToken"]) {
        [dictData setValue:[UserDefaults valueForKey:@"DToken"] forKey:@"DeviceToken"];
    }else{
        [dictData setValue:@"wewer89wer9wr789r78t97rtwe89t89ertrtt" forKey:@"DeviceToken"];
    }
    [dictData setValue:userType forKey:@"Usertype"];
    
    
    [[SXCUtility singleton] getDataForUrl:RegistrationLink parameters:dictData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject valueForKey:@"status"] && [[responseObject valueForKey:@"status"] boolValue] == YES) {
            
            NSMutableDictionary *dictData = [[NSMutableDictionary alloc]init];
            if ([responseObject valueForKey:@"Email"] && [responseObject valueForKey:@"UserId"]) {
                [dictData setValue:[responseObject valueForKey:@"Email"] forKey:@"email"];
                [dictData setValue:[responseObject valueForKey:@"UserId"] forKey:@"userid"];
                [dictData setValue:[responseObject valueForKey:@"Username"] forKey:@"UserName"];
                if ([userType isEqualToString:@"Facebook"]) {
                    if ([responseObject valueForKey:@"FacebookImage"]) {
                        [dictData setValue:[responseObject valueForKey:@"FacebookImage"] forKey:@"fbImage"];
                    }
                }
                [UserDefaults setObject:dictData forKey:@"userData"];
                [UserDefaults synchronize];
            }
            [SXCUtility singleton].isLoginRegi = YES;
            [ApplicationDelegate loadingDismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
            //            SXCRootMenuVC * objPre = VCWithIdentifier(@"SXCRootMenuVC");
            //            [self.navigationController pushViewController:objPre animated:YES];
        }else if (responseObject && [[responseObject valueForKey:@"Response"] isEqualToString:@"EmailID is Already Exists"]){
            [ApplicationDelegate showAlert:@"Email id already exists."];
        }
        
        else{
            [ApplicationDelegate showAlert:@"Something went wrong. Please try again."];
        }
        [ApplicationDelegate loadingDismiss];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
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

- (IBAction)btnPressed_LoginWithFB:(id)sender {
    [ApplicationDelegate loadingShow];
    // If the session state is any of the two "open" states when the button is clicked
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email",@"public_profile",@"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error //
            [SVProgressHUD dismiss];
            NSLog(@"Error = %@", [error description]);
            
        } else if (result.isCancelled) {
            // Handle cancellations //
            [SVProgressHUD dismiss];
            NSLog(@"Login with Facebook Cancelled by User");
            
        } else {
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     
                     [self callRegisterAPI:@"Facebook" : result];
                     [SVProgressHUD dismiss];
                     
                 }else{
                     
                     [SVProgressHUD dismiss];
                 }
             }];
        }
    }];
}


- (IBAction)btnPressed_SignUp:(id)sender {
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        
        NSLog(@"response :%@", errorMessage);
    }else if (![btn_Terms isSelected]){
        
        [ApplicationDelegate showAlertWithTitle:@"Please accept terms and conditions before you sign up." :@"You forgot something important."];
    }
    else{
        [self callRegisterAPI:@"Email" :nil];
    }
}

- (IBAction)btnPressed_SignIn:(id)sender {
}

- (IBAction)btnPressed_agreeTerms:(UIButton*)sender {
    if ([sender isSelected]) {
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    
}

- (IBAction)btnPressed_termsAndCondi:(id)sender {
    
    SXCAboutVC * objPre = VCWithIdentifier(@"SXCAboutVC");
    objPre.dictData = [[NSMutableDictionary alloc]init];
    [objPre.dictData setValue:@"Term Of Use" forKey:@"type"];
    [objPre.dictData setValue:TermOfUseText forKey:@"text"];
    [self.navigationController presentViewController:objPre animated:YES completion:nil];
}

- (IBAction)btnPressed_Close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)validateForm {
    NSString *errorMessage;
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    //    if (imageData == nil){
    //        errorMessage = @"Please add profile image";
    //    }
    //    else
    if (!(txtFld_username.text.length >= 1)){
        errorMessage = @"Please enter a username.";
    }
    else if (!(txtFld_email.text.length >= 1)){
        errorMessage = @"Please enter email address.";
    }
    else if (![emailPredicate evaluateWithObject:txtFld_email.text]){
        errorMessage = @"Please enter valid email address.";
    }
    else if ([SXCUtility checkPhoneNumber:txtFld_MobNo.text] == NO)
    {
        errorMessage = @"Invalid Mobile Number.";
    }
    else if (!(txtFld_password.text.length >= 1)){
        errorMessage = @"Please enter password.";
    }
    
    return errorMessage;
}


#pragma mark - TextField Delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
