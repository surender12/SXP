//
//  SXCFeedbackFooter.h
//  SXC
//
//  Created by Ketan on 09/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXCFeedbackFooter : UIView{
    
    __weak IBOutlet UICollectionView *collVw_likes;
    NSMutableArray * arrLikeStr;
    NSMutableArray * arrLikeSelected;
}
-(void)setupLikesFooter:(NSDictionary*)dictData;
@property (nonatomic, assign) BOOL isMyFeeback;
@end
