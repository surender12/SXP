//
//  SXCMeetVC.m
//  SXC
//
//  Created by Ketan on 09/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCMeetVC.h"

@interface SXCMeetVC ()

@end

@implementation SXCMeetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [SXCUtility lblTitleNavBar:@"Meet"];
    
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

- (IBAction)btnPressed_LetMeKnow:(id)sender {
    
    if ([UserDefaults objectForKey:@"userData"]) {
        UIAlertView* dialog = [[UIAlertView alloc] init];
        [dialog setDelegate:self];
        [dialog setTitle:@"SXC"];
        [dialog setMessage:@"Enter Your Email ID."];
        [dialog addButtonWithTitle:@"Cancel"];
        [dialog addButtonWithTitle:@"Send"];
        dialog.tag = 5;
        dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
        [dialog show];
    }else{
        [[SXCUtility singleton] alertView:@"You are not aurthorised with SXC." :100 :self];
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.view endEditing:YES];
    if (alertView.tag == 5) {
        UITextField *emailField = [alertView textFieldAtIndex:0];
        NSLog(@"emailField--%@",emailField.text);
        if (buttonIndex == 1) {
            if ([SXCUtility validateEmailWithString:emailField.text] == NO)
            {
                [ApplicationDelegate showAlert:@"Invalid Email ID"];
            }
            else
            {
                // Email Subject
                NSString *emailTitle = @"SXC - MEET";
                // Email Content
                NSString *messageBody = @"Let me know when this section will be available.";
                // To address
                NSArray *toRecipents = [NSArray arrayWithObject:@"info@sxc.com"];
                
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                mc.mailComposeDelegate = self;
                [mc setSubject:emailTitle];
                [mc setMessageBody:messageBody isHTML:NO];
                [mc setToRecipients:toRecipents];
                
                // Present mail view controller on screen
                [self presentViewController:mc animated:YES completion:NULL];

            }
        }
        
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
