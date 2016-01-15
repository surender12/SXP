//
//  ViewController.h
//  SXC
//
//  Created by Ketan on 05/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXCPresentationVC : UIViewController
{
    __weak IBOutlet UICollectionView *collVW_Presentation;
    __weak IBOutlet UIPageControl *page_Control;
    NSArray * arrMessages;
    
    __weak IBOutlet UIImageView *imgVwBackground;
}
- (IBAction)btnPressed_Next:(id)sender;


@end

