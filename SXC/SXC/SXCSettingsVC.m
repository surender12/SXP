//
//  SXCSettingsVC.m
//  SXC
//
//  Created by Ketan on 08/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCSettingsVC.h"
#import "Base64.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface SXCSettingsVC ()

@end

@implementation SXCSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self callProfileDetailAPI];
    
    
    datePkr_B.hidden = YES;
    pickr_S.hidden = YES;
    toolBar_S.hidden = YES;
    datePkr_B.maximumDate = [NSDate date];
    datePkr_B.backgroundColor = [UIColor whiteColor];
    pickr_S.backgroundColor = [UIColor whiteColor];
    
    txtFld_username.text = [[UserDefaults valueForKey:@"userData"] valueForKey:@"UserName"];
    txtFld_email.text = [[UserDefaults valueForKey:@"userData"] valueForKey:@"email"];
    
    
}

-(void)callProfileDetailAPI{
    [ApplicationDelegate loadingShow];
    //      http://www.trigmasolutions.com/SexSkill/api/GetUserProfileDet
    
    //      Keys:UserID
    NSLog(@"userid---%@",[UserDefaults valueForKey:@"userData"]);
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    
    [dictData setValue:[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"] forKey:@"UserID"];
    
    [[SXCUtility singleton] getDataGETForUrl:[NSString stringWithFormat:@"%@%@",GetUserProfile,[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [[responseObject objectAtIndex:0] valueForKey:@"Status"] && [[[responseObject objectAtIndex:0] valueForKey:@"Status"] boolValue] == YES) {
            
            txtFld_birthday.text = [[responseObject objectAtIndex:0] valueForKey:@"Birthday"];
            txtFld_country.text = [[responseObject objectAtIndex:0] valueForKey:@"Country"];
            txtFld_status.text = [[responseObject objectAtIndex:0] valueForKey:@"SexStatus"];
            txtFld_Tantra.text = [[responseObject objectAtIndex:0] valueForKey:@"StudyTantra"];
            txtFld_sexualOri.text = [[responseObject objectAtIndex:0] valueForKey:@"SexualOrientation"];
            [imgVw_Profile sd_setImageWithURL:[NSURL URLWithString:[[responseObject objectAtIndex:0] valueForKey:@"ProfileImage"]]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        
                                    }];
            imgBase64 = [Base64 encode:UIImagePNGRepresentation(imgVw_Profile.image)];
            
            if ([[[responseObject objectAtIndex:0] valueForKey:@"Feedbackmode"] integerValue] == 1) {
                isFeedback = YES;
                [slider_permission setOn:YES];
            }else{
                isFeedback = NO;
                [slider_permission setOn:NO];
            }
            
        }else{
            if ([[UserDefaults valueForKey:@"userData"] valueForKey:@"fbImage"]) {
                [imgVw_Profile sd_setImageWithURL:[NSURL URLWithString:[[UserDefaults valueForKey:@"userData"] valueForKey:@"fbImage"]]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                            
                                        }];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([[UserDefaults valueForKey:@"userData"] valueForKey:@"fbImage"]) {
            [imgVw_Profile sd_setImageWithURL:[NSURL URLWithString:[[UserDefaults valueForKey:@"userData"] valueForKey:@"fbImage"]]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        
                                    }];
        }
        
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}

-(void)callCreateProfileAPI{
    [ApplicationDelegate loadingShow];
    //      http://www.trigmasolutions.com/SexSkill/api/CreateUserProfile
    
    //Keys:UserID,Birthday,Country,Status,SexualOrientation,StudyTantra,ProfileImage,UserName
    
    NSLog(@"userid---%@",[UserDefaults valueForKey:@"userData"]);
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    [dictData setValue:[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"] forKey:@"UserID"];
    [dictData setValue:txtFld_birthday.text forKey:@"Birthday"];
    [dictData setValue:txtFld_country.text forKey:@"Country"];
    [dictData setValue:txtFld_status.text forKey:@"Status"];
    [dictData setValue:txtFld_sexualOri.text forKey:@"SexualOrientation"];
    [dictData setValue:txtFld_Tantra.text forKey:@"StudyTantra"];
    [dictData setValue:imgBase64 forKey:@"ProfileImage"];
    [dictData setValue:txtFld_username.text forKey:@"UserName"];
    [dictData setValue:[NSString stringWithFormat:@"%d",isFeedback] forKey:@"Feedbackmode"];
    
    [[SXCUtility singleton] getDataForUrl:CreateProfile parameters:dictData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject valueForKey:@"Status"] && [[responseObject valueForKey:@"Status"] boolValue] == YES) {
            
            [ApplicationDelegate showAlert:@"Profile updated successfully."];
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

- (IBAction)btnPressed_ImportFb:(id)sender {
    
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://fb.me/1460291697605208"];
    //optionally set previewImageURL
    content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://appstore.com/my_invite_image.jpg"];
    
    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    [FBSDKAppInviteDialog showWithContent:content
                                 delegate:self];
    
}


- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
    
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error{
    
}


- (IBAction)btnPressed_Save:(id)sender {
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        
        NSLog(@"response :%@", errorMessage);
    }else{
        [self callCreateProfileAPI];
    }
}

- (IBAction)btnPressed_ToolBarDone:(id)sender {
    datePkr_B.hidden = YES;
    pickr_S.hidden = YES;
    toolBar_S.hidden = YES;
    
    if (isDatePkr) {
        txtFld_birthday.text = [[SXCUtility singleton] dateFormat:@"MM-dd-YYYY" :datePkr_B.date];
        isDatePkr = NO;
    }
    
}

- (IBAction)btnPressed_Done:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)btnPressed_ProfilePic:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Photo from"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera",@"Photo Library", nil];
    
    
    [actionSheet showInView:self.view];
    
}

#pragma mark - Image picker methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self selectPhoto];
            break;
    }
}


- (IBAction)valueChanges_Switch:(UISwitch*)sender {
    if (sender.isOn) {
        
        isFeedback = YES;
        NSLog(@"isFeedback--%@",[NSString stringWithFormat:@"%d",isFeedback]);
    }else{
        isFeedback = NO;
        NSLog(@"isFeedback--%@",[NSString stringWithFormat:@"%d",isFeedback]);
    }
}

- (IBAction)btnPressed_txtFld:(UIButton*)sender {
    [self.view endEditing:YES];
    switch (sender.tag) {
        case 8961:
        {
            isDatePkr = YES;
            datePkr_B.hidden = NO;
            toolBar_S.hidden = NO;
        }
            break;
        case 8962:
        {
            isDatePkr = NO;
            isValPkr = YES;
            arrPickerData = @[@"SINGLE",@"COUPLE",@"POLY"];
            pickr_S.hidden = NO;
            toolBar_S.hidden = NO;
            [pickr_S reloadAllComponents];
        }
            break;
        case 8963:
        {
            isDatePkr = NO;
            isValPkr = NO;
            arrPickerData = @[@"HETEROSEXUALS",@"HOMOSEXUALS",@"BISEXUALS",@"QUEER"];
            pickr_S.hidden = NO;
            toolBar_S.hidden = NO;
            [pickr_S reloadAllComponents];
        }
            break;
            
        default:
            break;
    }
}

-(void)takePhoto{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
-(void)selectPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage =[[SXCUtility singleton] normalResImage:info[UIImagePickerControllerEditedImage]];
    btnProfilePic.layer.cornerRadius = 39.0;
    
    imgBase64 = [Base64 encode:UIImagePNGRepresentation(chosenImage)];
    imgVw_Profile.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark -  UIPicker methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (isValPkr) {
        txtFld_status.text = [arrPickerData objectAtIndex:row];
    }else{
        txtFld_sexualOri.text = [arrPickerData objectAtIndex:row];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *returnStr = [arrPickerData objectAtIndex:row];
    
    return returnStr;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrPickerData count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

#pragma mark - TextField Delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (NSString *)validateForm {
    NSString *errorMessage;
    //    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    //    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (imgBase64 == nil){
        errorMessage = @"Please add profile image.";
    }
    else if (!(txtFld_birthday.text.length >= 1)){
        errorMessage = @"Please select birthday.";
    }
    else if (!(txtFld_country.text.length >= 1)){
        errorMessage = @"Please enter country.";
    }
    else if (!(txtFld_status.text.length >= 1)){
        errorMessage = @"Are you Single, Couple, Poly?";
    }
    else if (!(txtFld_sexualOri.text.length >= 1)){
        errorMessage = @"Please select sexual orientation.";
    }
    else if (!(txtFld_Tantra.text.length >= 1)){
        errorMessage = @"Did you aleady study tantra?";
    }
    
    return errorMessage;
}

@end
