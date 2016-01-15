//
//  AppDelegate.m
//  SXC
//
//  Created by Ketan on 05/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "AppDelegate.h"
#import "SXCMyOpinionVC.h"
#import "IQKeyboardManager.h"
#import "SXCSettingsVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    sleep(2);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setTranslucent:YES];
    
    
    self.mainNavigationController = (UINavigationController *)self.window.rootViewController;
    _objPresentationVC = VCWithIdentifier(@"SXCPresentationVC");
    _objHomeVC = VCWithIdentifier(@"SXCRootMenuVC");
    _objRegisterVC = VCWithIdentifier(@"SXCRegisterVC");
    
    if ([UserDefaults boolForKey:@"HasLaunchedOnce"])
    {
        //        if ([UserDefaults objectForKey:@"userData"]) {
        [self.mainNavigationController setViewControllers:[NSArray arrayWithObjects:_objHomeVC, nil]];
        //        }else{
        
        //        [self.mainNavigationController setViewControllers:[NSArray arrayWithObjects:_objRegisterVC, nil]];
        //        }
    }
    else
    {
        // This is the first launch ever
        [self.mainNavigationController setViewControllers:[NSArray arrayWithObjects:_objPresentationVC, nil]];
    }
    
    
    //Notification
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    //Notification
    if ([launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        
//        NSDictionary *dictPush = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        
//        [self performSelector:@selector(pushActionWithDict:) withObject:dictPush afterDelay:1.0];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    
    // UIToolBar Button title color
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[SXCMyOpinionVC class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[SXCSettingsVC class]];
    
    
    
    [FBSDKLoginButton class];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSString *stringUrl = [url absoluteString];;
    if ([stringUrl rangeOfString:@"bridge/appinvites"].location == NSNotFound) {
        NSLog(@"string does not contain bridge/appinvites");
        
        if ([[FBSDKApplicationDelegate sharedInstance] application:application
                                                           openURL:url
                                                 sourceApplication:sourceApplication
                                                        annotation:annotation]) {
            return YES;
        }
    } else {
        NSLog(@"string contains bridge/appinvites");
        if ([FBAppCall handleOpenURL:url
                   sourceApplication:sourceApplication
                     fallbackHandler:^(FBAppCall *call) {
                         if ([call.dialogData.method isEqualToString:@"appinvites"]) {
                             // handle response
                         }
                     }]) {
                         return YES;
                     }
        
    }
    
    return NO;
}



#pragma mark
#pragma mark Notification
#pragma mark
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    [UserDefaults setValue:dt forKey:@"DToken"];
    [UserDefaults synchronize];
    SXCLog(@"UserDefaults token is: %@", [UserDefaults valueForKey:@"DToken"]);
    SXCLog(@"My token is: %@", dt);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    SXCLog(@"Failed to get token, error: %@", error);
}


-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
    SXCLog(@"My userInfo is: %@", userInfo);
    
    [TSMessage showNotificationWithTitle:@"SXC"
                                subtitle:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] type:TSMessageNotificationTypeSuccess];

    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

#pragma mark
#pragma mark Show UIAlert View
#pragma mark
-(void)showAlert:(NSString *)str
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)showAlertWithTitle:(NSString *)str :(NSString*)title{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark
#pragma mark Loading Indicator
#pragma mark
- (void)loadingShow {
    [SVProgressHUD show];
}

- (void)LoadingShowWithStatus :(NSString*)status {
    [SVProgressHUD showWithStatus:status];
}
#pragma mark - Dismiss Methods Sample

- (void)loadingDismiss {
    [SVProgressHUD dismiss];
}

@end
