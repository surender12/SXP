//
//  ViewController.m
//  SXC
//
//  Created by Ketan on 05/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCPresentationVC.h"
#import "SXCRootMenuVC.h"

@interface SXCPresentationVC ()

@end

@implementation SXCPresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
    page_Control.numberOfPages = 3;
    arrMessages = @[@"Discover, learn and enjoy improving your sex life.",@"Are you single or with a partner, hetro-, homo-, trans-, queer, old or young, beginner or experienced?\n\nSXC is for you.",@"In here, you are totally safe. You have full control over your privacy. And, we will not tell anyone about you."];
    if (IS_IPHONE_4) {
        imgVwBackground.image = [UIImage imageNamed:@"backgroundImg4"];
    }else
        imgVwBackground.image = [UIImage imageNamed:@"backgroundImg"];
    
    [UserDefaults setBool:YES forKey:@"HasLaunchedOnce"];
    [UserDefaults synchronize];
}

#pragma mark
#pragma mark scrollView Methods
#pragma mark
-(void)scrollViewDidScroll:(UICollectionView *)collView
{
    NSInteger currentIndex = ceilf((collVW_Presentation.contentOffset.x)/(collVW_Presentation.frame.size.width));
    page_Control.currentPage=currentIndex;
}



#pragma mark Collection View Datasource/Delegates

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return arrMessages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel * lblName = (UILabel *)[cell viewWithTag:1021];
    lblName.text = arrMessages[indexPath.row];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPressed_Next:(id)sender {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         collVW_Presentation.contentOffset = CGPointMake(collVW_Presentation.contentOffset.x+320, 0);
                         //here you may add any othe actions, but notice, that ALL of them will do in SINGLE step. so, we setting ONLY xx coordinate to move it horizantly first.
                     }
                     completion:^(BOOL finished){
                         
                         //here any actions, thet must be done AFTER 1st animation is finished. If you whant to loop animations, call your function here.
                         
                     }];
    
    if (collVW_Presentation.contentOffset.x > 640) {
        SXCRootMenuVC * objHome = VCWithIdentifier(@"SXCRootMenuVC");
        [self.navigationController pushViewController:objHome animated:YES];
    }
}
@end
