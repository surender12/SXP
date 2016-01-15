//
//  SXCGraphView.m
//  SXC
//
//  Created by Ketan on 08/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCGraphView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation SXCGraphView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)viewSelected :(BOOL)feedback :(NSString*)imgLink{
    
    
    if (feedback) {
       vw_ratingPic.hidden = NO;
        if ([[[SXCUtility singleton].dictChallenges valueForKey:@"ReceiveRatings"] integerValue] == 1) {
            imgVwLock.hidden = YES;
        }else{
            imgVwLock.hidden = NO;
        }
        
        if (imgLink) {
            imgVw_PicRating.hidden = NO;
            [imgVw_PicRating sd_setImageWithURL:[NSURL URLWithString:imgLink]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   
                               }];
        }else
             imgVw_PicRating.hidden = YES;
    }else{
        vw_ratingPic.hidden = YES;
        imgVwLock.hidden = YES;
    }
}


-(void)setupGraph{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:@"FEEDBACK"];
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:@(NSUnderlineStyleSingle)
                             range:NSMakeRange(0, 8)];
    [attributedString addAttribute:NSFontAttributeName value:FontOpenSans(12) range:NSMakeRange(0, 8)];
    btn_Feedback.titleLabel.attributedText = attributedString;
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]
                                                   initWithString:@"MY SKILLS"];
    [attributedString1 addAttribute:NSUnderlineStyleAttributeName
                             value:@(NSUnderlineStyleSingle)
                             range:NSMakeRange(0, 9)];
    [attributedString1 addAttribute:NSFontAttributeName value:FontOpenSans(12) range:NSMakeRange(0, 9)];
    btn_MySkills.titleLabel.attributedText = attributedString1;
    
    btn_Feedback.alpha = 0.5;
    
    NSMutableDictionary *valueDictionary = [[NSMutableDictionary alloc]init];
    [valueDictionary setValue:@"0" forKey:@"PLAYFULLNESS"];
    [valueDictionary setValue:@"0" forKey:@"SEXTALK"];
    [valueDictionary setValue:@"0" forKey:@"PRESENCE"];
    [valueDictionary setValue:@"0" forKey:@"LEADING"];
    [valueDictionary setValue:@"0" forKey:@"DEEP ORGASMS"];
    [valueDictionary setValue:@"0" forKey:@"FOLLOWING"];
    [valueDictionary setValue:@"0" forKey:@"EMPATHY"];
    [valueDictionary setValue:@"0" forKey:@"PEAK CONTROL"];
    
    [SXCUtility singleton].dictRating = [valueDictionary mutableCopy];
        
    //initiate a view with the value
    _spiderView = [[BTSpiderPlotterView alloc] initWithFrame:CGRectMake(0, 30, 320, 450) valueDictionary:valueDictionary];
    __weak typeof(self) weakSelf = self;
    
    _spiderView.blockFilter = ^(NSString*strTitle){
        
        id<SkillsDelegate> strongDelegate = weakSelf.delegate;
        // Our delegate method is optional, so we should
        // check that the delegate implements it

        if ([strongDelegate respondsToSelector:@selector(skillType:)]) {

            [strongDelegate skillType:strTitle];
        }

        
    };
    [_spiderView setMaxValue:10];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(34, 5, 100, 20)];
    [label setText:@"MY SKILLS"];
    label.font = FontOpenSans(12);
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor whiteColor]];
//    [_spiderView addSubview:label];
    
    UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 449, 320, 1)];
    line.image = [UIImage imageNamed:@"divider"];
    //    [_spiderView addSubview:line];
    
    _spiderView.plotColor = [UIColor colorWithRed:240.0f/255.0f green:52.0f/255.0f blue:4.0f/255.0f alpha:0.7f];
//     _spiderView.plotColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"graphColor"]];
    _spiderView.drawboardColor = [UIColor whiteColor];
    
    [self addSubview:_spiderView];
    [self bringSubviewToFront:btn_MySkills];
    [self bringSubviewToFront:btn_Feedback];
    
    imgVwLock = [[UIImageView alloc]initWithFrame:CGRectMake(128, 223, 65, 65)];
    imgVwLock.image = [UIImage imageNamed:@"lockedB"];
    [self addSubview:imgVwLock];
    imgVwLock.hidden = YES;
    
}

-(void)graphReload :(BOOL)isVal{
    if (isVal) {
        [_spiderView animateWithDuration:.2 valueDictionary:[SXCUtility singleton].dictRating];
    }else{
        NSMutableDictionary *valueDictionary = [[NSMutableDictionary alloc]init];
        [valueDictionary setValue:@"0" forKey:@"PLAYFULLNESS"];
        [valueDictionary setValue:@"0" forKey:@"SEXTALK"];
        [valueDictionary setValue:@"0" forKey:@"PRESENCE"];
        [valueDictionary setValue:@"0" forKey:@"LEADING"];
        [valueDictionary setValue:@"0" forKey:@"DEEP ORGASMS"];
        [valueDictionary setValue:@"0" forKey:@"FOLLOWING"];
        [valueDictionary setValue:@"0" forKey:@"EMPATHY"];
        [valueDictionary setValue:@"0" forKey:@"PEAK CONTROL"];
        [_spiderView animateWithDuration:.2 valueDictionary:valueDictionary];
    }
    
}

- (IBAction)btnPressed_MySkills:(id)sender {
    btn_MySkills.alpha = 1.0;
    btn_Feedback.alpha = 0.5;
    
    id<SkillsDelegate> strongDelegate = self.delegate;
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    
    if ([strongDelegate respondsToSelector:@selector(mySkillsPressed:)]) {
        
        [strongDelegate mySkillsPressed:@""];
    }
}

- (IBAction)btnPressed_Feedback:(id)sender {
    
    btn_MySkills.alpha = 0.5;
    btn_Feedback.alpha = 1.0;
    
    id<SkillsDelegate> strongDelegate = self.delegate;
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    
    if ([strongDelegate respondsToSelector:@selector(feedbackPressed:)]) {
        
        [strongDelegate feedbackPressed:@""];
    }
}

@end
