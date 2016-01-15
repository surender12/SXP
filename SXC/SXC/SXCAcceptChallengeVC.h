//
//  SXCAcceptChallengeVC.h
//  SXC
//
//  Created by Ketan on 22/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import "TSMiniWebBrowser.h"

@interface SXCAcceptChallengeVC : UIViewController<UIWebViewDelegate,TSMiniWebBrowserDelegate>{
    
    __weak IBOutlet UICollectionView *collVw_Videos;
    __weak IBOutlet UIScrollView *scrollVw_Container;
    __weak IBOutlet UILabel *lbl_Info;
    __weak IBOutlet UIButton *btn_Videos;
    __weak IBOutlet UIButton *btn_Info;
    NSArray *arrVideoLinks;

    __weak IBOutlet UIButton *btn_Accept;
    
}
- (IBAction)btnPressed_InfoVideoTab:(id)sender;
- (IBAction)btnPressed_Accept:(id)sender;
@property (nonatomic, strong) NSString * strTitle;
@end
