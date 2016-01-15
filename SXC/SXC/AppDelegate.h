//
//  AppDelegate.h
//  SXC
//
//  Created by Ketan on 05/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXCPresentationVC.h"
#import "SXCRootMenuVC.h"
#import "SXCRegisterVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "TSMessage.h"
//#import "SVProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (strong, nonatomic) SXCPresentationVC *objPresentationVC;
@property (strong, nonatomic) SXCRootMenuVC *objHomeVC;
@property (strong, nonatomic) SXCRegisterVC *objRegisterVC;
// Show AlertView
-(void)showAlert:(NSString *)str;
-(void)showAlertWithTitle:(NSString *)str :(NSString*)title;
// Loading
- (void)loadingShow;
- (void)LoadingShowWithStatus :(NSString*)status;
- (void)loadingDismiss;
@end

