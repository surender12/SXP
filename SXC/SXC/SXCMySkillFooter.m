//
//  SXCMySkillFooter.m
//  SXC
//
//  Created by Ketan on 09/07/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCMySkillFooter.h"

@implementation SXCMySkillFooter
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setUpCalendarView :(NSString*)count{
    
    lbl_orgasm.text = [NSString stringWithFormat:@"DAYS SINCE LAST PEAK ORGASM: %@",count];
}

- (IBAction)btnPressed_calendar:(id)sender {
    
    id<SkillsFooterDelegate> strongDelegate = self.delegate;
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    
    if ([strongDelegate respondsToSelector:@selector(calendarTapped)]) {
        
        [strongDelegate calendarTapped];
    }

}
@end
