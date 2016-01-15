//
//  SXCLoginVC.m
//  SXC
//
//  Created by Ketan on 17/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCLoginVC.h"
#import "SXCRootMenuVC.h"
#import "Base64.h"
@interface SXCLoginVC ()

@end

@implementation SXCLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IS_IPHONE_4) {
        imgVwBackground.image = [UIImage imageNamed:@"backgroundImg4"];
    }else
        imgVwBackground.image = [UIImage imageNamed:@"backgroundImg"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}


-(void)callSignInAPI{
    [ApplicationDelegate loadingShow];
    //      http://www.trigmasolutions.com/SexSkill/api/LoginCheck
    
    //      Keys: EmailId,Password,DeviceToken,DeviceType
    
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    
    [dictData setValue:txtFld_username.text forKey:@"EmailId"];
    [dictData setValue:@"iphone" forKey:@"DeviceType"];
    if ([UserDefaults valueForKey:@"DToken"]) {
        [dictData setValue:[UserDefaults valueForKey:@"DToken"] forKey:@"DeviceToken"];
    }else{
        [dictData setValue:@"wewer89wer9wr789r78t97rtwe89t89ertrtt" forKey:@"DeviceToken"];
    }
    [dictData setValue:txtFld_password.text forKey:@"Password"];
    
    [[SXCUtility singleton] getDataForUrl:LoginAPI parameters:dictData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject valueForKey:@"Status"] && [[responseObject valueForKey:@"Status"] boolValue] == YES) {
            
            NSMutableDictionary *dictData = [[NSMutableDictionary alloc]init];
            if ([responseObject valueForKey:@"EmailId"] && [responseObject valueForKey:@"UserID"]) {
                [dictData setValue:[responseObject valueForKey:@"EmailId"] forKey:@"email"];
                [dictData setValue:[responseObject valueForKey:@"UserID"] forKey:@"userid"];
                [dictData setValue:[responseObject valueForKey:@"Username"] forKey:@"UserName"];
                
                [UserDefaults setObject:dictData forKey:@"userData"];
                [UserDefaults synchronize];
            }
            [SXCUtility singleton].isLoginRegi = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
            //        SXCRootMenuVC * objPre = VCWithIdentifier(@"SXCRootMenuVC");
            //        [self.navigationController pushViewController:objPre animated:YES];
        }else{
            
            [ApplicationDelegate showAlert:@"Invalid username or password."];
        }
        [ApplicationDelegate loadingDismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}

-(void)callRegisterAPI : (NSDictionary *)fbData{
    [ApplicationDelegate loadingShow];
    //        Usertype --->"Facebook","Email","UnVerified"
    //        Keys:Username,Email,PhoneNumber,DeviceType,DeviceToken,Usertype,password(This key will be used for Email,Facebook)
    
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    
    [dictData setValue:[fbData valueForKey:@"name"] forKey:@"Username"];
    if ([fbData valueForKey:@"email"]) {
        [dictData setValue:[fbData valueForKey:@"email"] forKey:@"Email"];
        [dictData setValue:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[fbData valueForKey:@"id"]] forKey:@"FacebookImage"];
    }
    [dictData setValue:@"" forKey:@"PhoneNumber"];
    [dictData setValue:@"" forKey:@"password"];
    
    [dictData setValue:@"iphone" forKey:@"DeviceType"];
    if ([UserDefaults valueForKey:@"DToken"]) {
        [dictData setValue:[UserDefaults valueForKey:@"DToken"] forKey:@"DeviceToken"];
    }else{
        [dictData setValue:@"wewer89wer9wr789r78t97rtwe89t89ertrtt" forKey:@"DeviceToken"];
    }
    
    [dictData setValue:@"Facebook" forKey:@"Usertype"];
    
    
    [[SXCUtility singleton] getDataForUrl:RegistrationLink parameters:dictData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject---%@",responseObject);
        [ApplicationDelegate loadingDismiss];
        
        if (responseObject && [responseObject valueForKey:@"status"] && [[responseObject valueForKey:@"status"] boolValue] == YES) {
            
            NSMutableDictionary *dictData = [[NSMutableDictionary alloc]init];
            if ([responseObject valueForKey:@"Email"] && [responseObject valueForKey:@"UserId"]) {
                [dictData setValue:[responseObject valueForKey:@"Email"] forKey:@"email"];
                [dictData setValue:[responseObject valueForKey:@"UserId"] forKey:@"userid"];
                [dictData setValue:[responseObject valueForKey:@"Username"] forKey:@"UserName"];
                [dictData setValue:[responseObject valueForKey:@"FacebookImage"] forKey:@"fbImage"];
                
                [UserDefaults setObject:dictData forKey:@"userData"];
                [UserDefaults synchronize];
            }
            [SXCUtility singleton].isLoginRegi = YES;
            //            SXCRootMenuVC * objPre = VCWithIdentifier(@"SXCRootMenuVC");
            //            [self.navigationController pushViewController:objPre animated:YES];
            [ApplicationDelegate loadingDismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [ApplicationDelegate showAlert:@"Something went wrong. Please try again."];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
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

- (IBAction)btnPressed_withFB:(id)sender {
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
                     
                     //                     NSString * userEmailAddress        = [result valueForKey:@"email"];
                     //                     NSString * userFirstName           = [result valueForKey:@"first_name"];
                     //                     NSString * userLastName            = [result valueForKey:@"last_name"];
                     //                     NSString * userName                = [result valueForKey:@"name"];
                     //                     NSString * userId                  = [result valueForKey:@"id"];
                     //
                     //                     NSMutableDictionary * dictDetails = [[NSMutableDictionary alloc]init];
                     //                     [dictDetails setValue:userFirstName forKey:@"first_name"];
                     //                     [dictDetails setValue:userLastName forKey:@"last_name"];
                     //                     [dictDetails setValue:userName forKey:@"name"];
                     //                     [dictDetails setValue:userId forKey:@"id"];
                     //                     [dictDetails setValue:userEmailAddress forKey:@"email"];
                     //
                     //                     NSLog(@"User Details Are : %@",dictDetails);
                     //
                     //                     [[NSUserDefaults standardUserDefaults]setValue:userId forKey:FACEBOOK_ID];
                     //                     [[NSUserDefaults standardUserDefaults] synchronize];
                     //                     [APP_DELEGATE changeRootControllerToRevealController];
                     [self callRegisterAPI: result];
                     
                 }else
                     
                     [SVProgressHUD dismiss];
             }];
        }
    }];
}
/*
 - (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
 {
 if (!error && state == FBSessionStateOpen)
 {
 [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
 NSLog(@"%@",user);
 
 [self callRegisterAPI: user];
 }];
 }
 
 else  if (error){
 
 [ApplicationDelegate loadingDismiss];
 
 if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
 [ApplicationDelegate showAlert:[FBErrorUtility userMessageForError:error]];
 
 }
 else {
 
 if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
 NSLog(@"User cancelled login.");
 }
 else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
 
 [ApplicationDelegate showAlert:@"Your current session is no longer valid. Please log in again."];
 }
 else {
 
 [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
 }
 }
 
 
 }        return ;
 }
 */

- (IBAction)btnPressed_login:(id)sender {
    if (!(txtFld_username.text.length == 0) && !(txtFld_password.text.length == 0)) {
        if ([SXCUtility validateEmailWithString:txtFld_username.text] == NO)
        {
            [ApplicationDelegate showAlert:@"Invalid Email ID"];
        }
        else
        {
            [self callSignInAPI];
        }
    }else
        [ApplicationDelegate showAlert:@"Enter valid email and password."];
    
    
}

- (IBAction)btnPressed_forgotPassword:(id)sender {
    
    UIAlertView* dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:self];
    [dialog setTitle:@"SXC"];
    [dialog setMessage:@"Enter Your Email ID."];
    [dialog addButtonWithTitle:@"Cancel"];
    [dialog addButtonWithTitle:@"Send"];
    dialog.tag = 5;
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [dialog show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.view endEditing:YES];
    if (alertView.tag == 5) {
        UITextField *emailField = [alertView textFieldAtIndex:0];
        NSLog(@"emailField--%@",emailField.text);
        
        if ([SXCUtility validateEmailWithString:emailField.text] == NO)
        {
            [ApplicationDelegate showAlert:@"Invalid Email ID"];
        }
        else
        {
            [self callForgotPasswordAPI:emailField.text];
        }
    }
}

- (IBAction)btnPressed_SignUp:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnPressed_Close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)callForgotPasswordAPI : (NSString *)strEmail{
    [ApplicationDelegate loadingShow];
    //      http://www.trigmasolutions.com/SexSkill/api/ForgotPassword
    
    //      Keys: Email
    
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    [dictData setValue:strEmail forKey:@"Email"];
    
    
    
    [[SXCUtility singleton] getDataForUrl:ForgotPassword parameters:dictData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject---%@",responseObject);
        
        [ApplicationDelegate loadingDismiss];
        if (responseObject && [responseObject valueForKey:@"Status"] && [[responseObject valueForKey:@"Status"] boolValue] == YES) {
            
            [ApplicationDelegate showAlert:@"Email Sent Successfully."];
            
        }else if (responseObject && [responseObject valueForKey:@"Status"] && [[responseObject valueForKey:@"Status"] boolValue] == NO){
            [ApplicationDelegate showAlert:[responseObject valueForKey:@"Response"]];
        }
        else{
            [ApplicationDelegate showAlert:@"Something went wrong. Please try again."];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}


@end
