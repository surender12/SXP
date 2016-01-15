//
//  SXCUtility.m
//  SXC
//
//  Created by Ketan on 05/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCUtility.h"
#import "SXCRootMenuVC.h"
#import "RXCustomTabBar.h"


@implementation SXCUtility
@synthesize dictRating;
//static SXCUtility * singleton = nil;

+(SXCUtility*)singleton
{
    static SXCUtility *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

+(SXCHomeVC*)masterViewController{
    
    UINavigationController  * navigationControler = ApplicationDelegate.mainNavigationController;
    
    SXCRootMenuVC    * masterViewController = [navigationControler.viewControllers lastObject];
    
    RXCustomTabBar * tabBarController = (RXCustomTabBar*)masterViewController.contentViewController;
    NSLog(@"View Controllers = %@",tabBarController.viewControllers);
    
    [tabBarController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
    }];
    
    return [[[tabBarController.viewControllers objectAtIndex:0] viewControllers]objectAtIndex:0];
}


#pragma mark
#pragma mark TxtFld Method
#pragma mark
+(UILabel *)lblTitleNavBar:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = FontOpenSans(15);
    label.textAlignment = NSTextAlignmentCenter;
    label.text=title;
    label.textColor = [UIColor whiteColor]; // change this color (yellow)
    [label sizeToFit];
    return label;
    
}

#pragma mark
#pragma mark NavigationBar LeftBarButton Method
#pragma mark
+(UIBarButtonItem *)leftbar:(UIImage *)image :(UIViewController*)viewController
{
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btnLeft setImage:image forState:UIControlStateNormal];
    [btnLeft addTarget:viewController action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    return left;
}
+(NSMutableArray *)rightbar:(UIImage *)image :(NSString*)strTitle :(UIViewController*)viewController
{
    NSMutableArray * arrBtn = [[NSMutableArray alloc]init];
    if (strTitle.length > 0) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0,0,50,30)];
        [btnRight setTitle:strTitle forState:UIControlStateNormal];
        btnRight.titleLabel.font = FontOpenSans(12);
        [btnRight addTarget:viewController action:@selector(rightBtnTxt) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        [arrBtn addObject:right];
        
    }
    if(image != nil)
    {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0,0,15,16)];
        [btnRight setBackgroundImage:image forState:UIControlStateNormal];
        [btnRight addTarget:viewController action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        [arrBtn addObject:right];
    }
    
    //    NSArray * btns = [[NSArray alloc] initWithObjects:right1, right2, nil];
    return arrBtn;
}


-(void)leftBtn{
    
}
-(void)rightBtn{
    
}
-(void)rightBtnTxt{
    
}



#pragma mark
#pragma mark Email Validation
#pragma mark
+(void)backGestureDisable:(UIViewController*)viewController
{
    if ([viewController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        viewController.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark
#pragma mark Email Validation
#pragma mark
+(BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark
#pragma mark AFNetworking
#pragma mark
-(void)getDataForUrl:(NSString *)URLString
          parameters:(NSDictionary *)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

-(void)getDataGETForUrl:(NSString *)URLString
             parameters:(NSDictionary *)parameters
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}



#pragma mark
#pragma mark UIAlertView
#pragma mark
-(UIAlertView *)alertView :(NSString *)message :(int)tag :(UIViewController*)viewController
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:message delegate:viewController cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login",@"Register", nil];
    alert.tag = tag;
    [alert show];
    return alert;
}

#pragma mark
#pragma mark Email Validation
#pragma mark
+(BOOL)checkPhoneNumber:(NSString*)phone
{
    NSString *phoneNumber = phone;
    NSString *phoneRegExpression = @"[0-9]{10}";
    NSPredicate *phoneTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegExpression];
    BOOL myStringMatchesRegEx=[phoneTest evaluateWithObject:phoneNumber];
    return myStringMatchesRegEx;
}

#pragma mark
#pragma mark Date Format
#pragma mark
-(NSString *)dateFormat:(NSString *)format :(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *currDate = [dateFormatter stringFromDate:date];
    return currDate;
}

#pragma mark
#pragma mark Image Size Compress Method
-(UIImage *)normalResImage:(UIImage*)image1
{
    // Convert ALAsset to UIImage
    UIImage *image = image1;
    
    // Determine output size
    CGFloat maxSize = 320;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;
    
    // If any side exceeds the maximun size, reduce the greater side to 1200px and proportionately the other one
    if (width > maxSize || height > maxSize) {
        if (width > height) {
            newWidth = maxSize;
            newHeight = (height*maxSize)/width;
        } else {
            newHeight = maxSize;
            newWidth = (width*maxSize)/height;
        }
    }
    
    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Set maximun compression in order to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(newImage, 1.0f);
    UIImage *processedImage = [UIImage imageWithData:imageData];
    
    return processedImage;
}

#pragma mark
#pragma mark Character check
#pragma mark
-(BOOL)checkLetter:(NSString*)str{
    
    NSString *nameRegex = @"[A-Z0-9a-z]*";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [nameTest evaluateWithObject:str];
}

@end
