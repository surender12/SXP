//
//  SXCUtility.h
//  SXC
//
//  Created by Ketan on 05/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "SXCHomeVC.h"

@interface SXCUtility : NSObject
{
    
}
+(SXCUtility*)singleton;
+(SXCHomeVC*)masterViewController;
+(UILabel *)lblTitleNavBar:(NSString *)title;
+(UIBarButtonItem *)leftbar:(UIImage *)image :(UIViewController*)viewController;
+(NSMutableArray*)rightbar:(UIImage *)image :(NSString*)strTitle :(UIViewController*)viewController;
+(void)backGestureDisable:(UIViewController*)viewController;
+(BOOL)validateEmailWithString:(NSString*)email;
-(void)getDataForUrl:(NSString *)URLString
          parameters:(NSDictionary *)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)getDataGETForUrl:(NSString *)URLString
             parameters:(NSDictionary *)parameters
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(UIAlertView *)alertView :(NSString *)message :(int)tag :(UIViewController*)viewController;

-(NSString *)dateFormat:(NSString *)format :(NSDate *)date;
-(UIImage *)normalResImage:(UIImage*)image1;
-(BOOL)checkLetter:(NSString*)str;
+(BOOL)checkPhoneNumber:(NSString*)phone;

@property (nonatomic, strong) NSMutableDictionary * dictRating;
@property (nonatomic, strong) NSMutableDictionary * dictChallenges;
@property(nonatomic, assign) BOOL isLoginRegi;
@end
