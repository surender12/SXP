//
//  SXCMySkillFooter.h
//  SXC
//
//  Created by Ketan on 09/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SkillsFooterDelegate;

@interface SXCMySkillFooter : UIView{

    __weak IBOutlet UILabel *lbl_orgasm;
}
- (IBAction)btnPressed_calendar:(id)sender;
@property (nonatomic, weak) id<SkillsFooterDelegate> delegate;
-(void)setUpCalendarView :(NSString*)count;
@end

@protocol SkillsFooterDelegate <NSObject>
- (void)calendarTapped;
@end
