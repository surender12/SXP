//
//  SXCProfileHeader.m
//  SXC
//
//  Created by Ketan on 23/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCProfileHeader.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation SXCProfileHeader

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)getData:(NSArray*)dict{
    if ([[dict objectAtIndex:0]  valueForKey:@"ProfileImage"]) {
        [imgVw_Profile sd_setImageWithURL:[NSURL URLWithString:[[dict objectAtIndex:0]  valueForKey:@"ProfileImage"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        [imgVw_cover sd_setImageWithURL:[NSURL URLWithString:[[dict objectAtIndex:0]  valueForKey:@"ProfileImage"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }else{
        [imgVw_Profile sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        [imgVw_cover sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
    
    lnl_Name.text = [[dict objectAtIndex:0]  valueForKey:@"UserName"];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:@"LIKE"];
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:@(NSUnderlineStyleSingle)
                             range:NSMakeRange(0, 4)];
    [attributedString addAttribute:NSFontAttributeName value:FontOpenSans(12) range:NSMakeRange(0, 4)];
    btnLike.titleLabel.attributedText = attributedString;
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]
                                                    initWithString:@"RATE"];
    [attributedString1 addAttribute:NSUnderlineStyleAttributeName
                              value:@(NSUnderlineStyleSingle)
                              range:NSMakeRange(0, 4)];
    [attributedString1 addAttribute:NSFontAttributeName value:FontOpenSans(12) range:NSMakeRange(0, 4)];
    btnRate.titleLabel.attributedText = attributedString1;
    
    btnLike.alpha = 0.5;
}

- (IBAction)valueChanged_Switch:(id)sender {
}

- (IBAction)btnPressed_Like:(id)sender {
    
    btnRate.alpha = 0.5;
    btnLike.alpha = 1.0;
    
    id<ProfileDelegate> strongDelegate = self.delegate;
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    
    if ([strongDelegate respondsToSelector:@selector(profileType:)]) {
        
        [strongDelegate profileType:@"like"];
    }
}

- (IBAction)btnPressed_Rate:(id)sender {
    
    btnRate.alpha = 1.0;
    btnLike.alpha = 0.5;
    
    id<ProfileDelegate> strongDelegate = self.delegate;
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    
    if ([strongDelegate respondsToSelector:@selector(profileType:)]) {
        
        [strongDelegate profileType:@"rate"];
    }
}
@end
