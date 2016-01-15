//
//  SXCProfileLikes.h
//  SXC
//
//  Created by Ketan on 13/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LikeDelegate;
@interface SXCProfileLikes : UIView{
    
    __weak IBOutlet UICollectionView *collVw_Likes;
    NSMutableArray * arrLikeStr;
}
- (IBAction)btnPressed_AddLikes:(id)sender;
-(void)setupLikesFooter:(NSDictionary*)dictData;
@property (nonatomic, weak) id<LikeDelegate> delegate;
@end

@protocol LikeDelegate <NSObject>
- (void)likePressed;
@end
