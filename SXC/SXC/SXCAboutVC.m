//
//  SXCAboutVC.m
//  SXC
//
//  Created by Ketan on 08/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCAboutVC.h"

@interface SXCAboutVC ()

@end

@implementation SXCAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    lbl_Title.text = [_dictData valueForKey:@"type"];
    txtVw_Content.text = [_dictData valueForKey:@"text"];
    txtVw_Content.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnPressed_Done:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
