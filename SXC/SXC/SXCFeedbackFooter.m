//
//  SXCFeedbackFooter.m
//  SXC
//
//  Created by Ketan on 09/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCFeedbackFooter.h"

@implementation SXCFeedbackFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setupLikesFooter:(NSDictionary*)dictData{
    
    [collVw_likes registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    NSLog(@"dictDatadictData---##--%@",dictData);
    arrLikeStr = [[NSMutableArray alloc]init];
    arrLikeSelected = [[NSMutableArray alloc]init];
     if ([[[SXCUtility singleton].dictChallenges valueForKey:@"ReceiveLikes"] integerValue] == 1) {
         
         collVw_likes.backgroundView = nil;
         
    [[dictData valueForKey:@"liked"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([[[dictData valueForKey:@"liked"] objectAtIndex:idx] integerValue] >= 1) {
            [arrLikeStr addObject:[[dictData valueForKey:@"likeList"] objectAtIndex:idx]];
            [arrLikeSelected addObject:[[dictData valueForKey:@"liked"] objectAtIndex:idx]];
        }
    }];
         
         float height;
         if ([arrLikeStr count] % 2 == 0) {
             height = ([arrLikeStr count]/2)*30;
         }else{
             height = (([arrLikeStr count]+1)/2)*30;
         }
         
         
         [collVw_likes setFrame:CGRectMake(15, 44, 290, height)];
         [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 320, 50 + height)];
     }else{
         [collVw_likes setFrame:CGRectMake(15, 44, 290, 200)];
         [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 320, 250)];
         UIView *viewNoLike= [[UIView alloc]initWithFrame:CGRectMake(0, 15, 290, 150)];
         UILabel *lblNo = [[UILabel alloc]initWithFrame:viewNoLike.frame];
         lblNo.text = @"Accept RECEIVE LIKES Challenge.";
         lblNo.textColor = [UIColor whiteColor];
         lblNo.textAlignment = NSTextAlignmentCenter;
         lblNo.font = FontOpenSans(12);
         [viewNoLike addSubview:lblNo];
         collVw_likes.backgroundView = viewNoLike;
     }
    
    [collVw_likes reloadData];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrLikeStr count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    for (UIView * view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    UIImageView * imgback = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140, 20)];
    imgback.backgroundColor = [UIColor lightGrayColor];
    imgback.alpha = 0.5;
    [cell.contentView addSubview:imgback];
    
    UIImageView * imgStar = [[UIImageView alloc]initWithFrame:CGRectMake(5, 2, 14, 14)];
    imgStar.image = [UIImage imageNamed:@"star_green"];
    [cell.contentView addSubview:imgStar];
    
    UILabel *lblLike = [[UILabel alloc]initWithFrame:CGRectMake(22, 0, 110, 20)];
    if (_isMyFeeback) {
        lblLike.text = [NSString stringWithFormat:@"%@ %@",arrLikeSelected[indexPath.row],arrLikeStr[indexPath.row]];
    }else{
        lblLike.text = [NSString stringWithFormat:@"%@",arrLikeStr[indexPath.row]];
    }
    
    lblLike.textColor = [UIColor whiteColor];
    lblLike.minimumScaleFactor = 0.8;
    lblLike.font = FontOpenSans(10);
    lblLike.adjustsFontSizeToFitWidth = YES;
    [cell.contentView addSubview:lblLike];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    

}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"SETTING SIZE FOR ITEM AT INDEX %ld", (long)indexPath.row);
    CGSize mElementSize = CGSizeMake(140, 25);
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

@end
