//
//  SXCMyOpinionVC.m
//  SXC
//
//  Created by Ketan on 08/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

 #import "SXCMyOpinionVC.h"

@interface SXCMyOpinionVC ()

@end

@implementation SXCMyOpinionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)callSaveOpinionAPI{
    [ApplicationDelegate loadingShow];
//      http://www.trigmasolutions.com/SexSkill/api/SaveUserOpion
    
//      Keys:UserID,AbountSex,ImproveSex
    
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc]init];
    
    [dictData setValue:[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"] forKey:@"UserID"];
    [dictData setValue:txtxVw_about.text forKey:@"AbountSex"];
    [dictData setValue:txtVw_improve.text forKey:@"ImproveSex"];

    
    [[SXCUtility singleton] getDataForUrl:SaveOpinion parameters:dictData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject valueForKey:@"Status"] && [[responseObject valueForKey:@"Status"] boolValue] == YES) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Saved Successfully!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 101;
            [alert show];
            
        }else{
            [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ApplicationDelegate loadingDismiss];
        
    }];
    
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.view endEditing:YES];
    if (alertView.tag == 101) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
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

- (IBAction)btnPressed_Save:(id)sender {
    
    [self.view endEditing:YES];
    
    [self callSaveOpinionAPI];
}

- (IBAction)btnPressed_Done:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}



#pragma mark
#pragma mark TextView Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Enter text"]) {
        textView.text = @"";
    }
    
    if (textView == txtVw_improve) {
        self.view.frame = CGRectMake(0, -200, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [textView becomeFirstResponder];
    

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Enter text";
    }
    
    if (textView == txtVw_improve) {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [textView resignFirstResponder];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

@end
