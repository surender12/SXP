//
//  SXCFilterTblVW.m
//  SXC
//
//  Created by Ketan on 16/06/15.
//  Copyright (c) 2015 Trigma. All rights reserved.
//

#import "SXCFilterTblVW.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation SXCFilterTblVW
@synthesize blockFilter;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)callSetup{
    
    arrList = [[NSMutableArray alloc]initWithObjects:@"What others say of me",@"Individuals rating", nil];
    arrImages = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"filterTick"],[UIImage imageNamed:@"filterTick"], nil];
    arrFriendUserID = [[NSMutableArray alloc]initWithObjects:@"0",@"0", nil];
    
    [self callListUsersRated];
}

-(void)callListUsersRated {
    [ApplicationDelegate loadingShow];
    
    //      http://www.trigmasolutions.com/SexSkill/api/GetAllRatingUsers
    
    //      Keys:LoggedInUserID
    
    [[SXCUtility singleton] getDataGETForUrl:[NSString stringWithFormat:@"%@%@",GetListUsersRated,[[UserDefaults valueForKey:@"userData"] valueForKey:@"userid"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [ApplicationDelegate loadingDismiss];
        NSLog(@"responseObject---%@",responseObject);
        
        if (responseObject && [responseObject objectAtIndex:0] && [[responseObject objectAtIndex:0] valueForKey:@"Status"] && [[[responseObject objectAtIndex:0] valueForKey:@"Status"] boolValue] == YES) {
            
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [arrList addObject:[[responseObject objectAtIndex:idx] valueForKey:@"UserName"]];
                [arrImages addObject:[[responseObject objectAtIndex:idx] valueForKey:@"UserImage"]];
                [arrFriendUserID addObject:[[responseObject objectAtIndex:idx] valueForKey:@"UserID"]];
                
            }];
            
        }else{
            //             [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        }
        [self setupViewController];
        
        [tbl_Filter reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [ApplicationDelegate showAlert:@"Something went wrong. Try again."];
        [ApplicationDelegate loadingDismiss];
        
    }];
    
}

-(void)reloadTableContentsWithInder:(NSInteger)index isOpen:(BOOL)open{
    
    [self.headers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIImageView * imageView = (UIImageView*)[(UIView*)obj viewWithTag:100+idx];
        if(index == idx && !open){
            imageView.image = [UIImage imageNamed:@"ArrowUp"];
        }else{
            imageView.image = [UIImage imageNamed:@"ArrowDown"];
        }
        
    }];
}

- (void)setupViewController
{
    
    
    self.data = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [arrList count] ; i++)
    {
        NSMutableArray* section = [[NSMutableArray alloc] init];
        if (i == 0) {
            [section addObject:@"(Anonymous feedback - Rate 1 persons to unlock) Shows the average of all ratings you have received."];
        }else if (i == 1) {
            [section addObject:@"(Open feedback - Rate 1 to unlock) Shows the average of those who have chosen to give you open feedback."];
        }else{
            [section addObject:@"Shows individual feedback from this person."];
        }
        
        [self.data addObject:section];
    }
    
    self.headers = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [arrList count] ; i++)
    {
        UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 274, 60)];
        UIImageView * imgDivider = [[UIImageView alloc]initWithFrame:CGRectMake(0, 59, 274, 1)];
        UIImageView * imgPic = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        imgPic.layer.cornerRadius = 20;
        imgPic.clipsToBounds = YES;
        
        if (i == 0 || i == 1) {
            imgPic.contentMode = UIViewContentModeCenter;
            imgPic.image = [arrImages objectAtIndex:i];
        }else{
            imgPic.contentMode = UIViewContentModeScaleAspectFill;
            [imgPic sd_setImageWithURL:[NSURL URLWithString:[arrImages objectAtIndex:i]]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                             }];
        }
        
        
        imgDivider.backgroundColor = [UIColor lightGrayColor];
        header.backgroundColor = [UIColor whiteColor];
        UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, 200, 30)];
        lbl.text = [arrList objectAtIndex:i];
        lbl.font = FontOpenSans(12);
        [header addSubview:lbl];
        [header addSubview:imgPic];
        [header addSubview:imgDivider];
        
        // ADD BUTTON ON HEADER VIEW //
        UIImageView * imageView     = [[UIImageView alloc]initWithFrame:CGRectMake(240, 25, 14, 8)];
        imageView.backgroundColor   = [UIColor clearColor];
        imageView.tag                  = 100+i;
        [imageView setImage:[UIImage imageNamed:@"ArrowDown"]];
        [header addSubview:imageView];
        
        [self.headers addObject:header];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"filterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SXCFilterCell" owner:self options:nil];
        cell = (UITableViewCell *)[nib objectAtIndex:0];
        
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
        [cell setSelectedBackgroundView:bgColorView];
        
    }
    NSString* text = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UILabel * lblTitle = (UILabel*)[cell viewWithTag:1002];
    
    if (lblTitle) {
        lblTitle.text = text;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.data objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.headers objectAtIndex:section];
}


/*
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 return 1;    //count of section
 }
 
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
 return arrList.count;    //count number of row from counting array hear cataGorry is An Array
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView
 cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *MyIdentifier = @"filterCell";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
 
 if (cell == nil)
 {
 NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SXCFilterCell" owner:self options:nil];
 cell = (UITableViewCell *)[nib objectAtIndex:0];
 //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
 //                                       reuseIdentifier:MyIdentifier];
 
 
 UIView *bgColorView = [[UIView alloc] init];
 bgColorView.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
 [cell setSelectedBackgroundView:bgColorView];
 
 }
 
 UIButton * imgVwPic = (UIButton*)[cell viewWithTag:1001];
 UILabel * lblTitle = (UILabel*)[cell viewWithTag:1002];
 if (imgVwPic) {
 if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
 [imgVwPic setImage:[UIImage imageNamed:@"filterTick"] forState:UIControlStateNormal];
 }else
 [imgVwPic setImage:[UIImage imageNamed:@"avatar.png"] forState:UIControlStateNormal];
 }
 if (lblTitle) {
 lblTitle.text = arrList[indexPath.row];
 }
 
 return cell;
 }
 */


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setValue:[arrList objectAtIndex:indexPath.section] forKey:@"title"];
    [dict setValue:[arrImages objectAtIndex:indexPath.section] forKey:@"image"];
    [dict setValue:[arrFriendUserID objectAtIndex:indexPath.section] forKey:@"friendID"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)indexPath.section] forKey:@"indexTapped"];
    self.blockFilter(dict);
    [self removeFromSuperview];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (IBAction)btnPressed_Close:(id)sender {
    
    [self removeFromSuperview];
}
@end
