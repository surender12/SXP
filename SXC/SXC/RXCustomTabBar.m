//
//  RumexCustomTabBar.m
//  
//
//  Created by Oliver Farago on 19/06/2010.
//  Copyright 2010 Rumex IT All rights reserved.
//

#import "RXCustomTabBar.h"

#define numberOfTabs 4
#define btnHeight 44
#define Screen [[UIScreen mainScreen] bounds]

@implementation RXCustomTabBar

@synthesize btn1,btn2,btn3,btn4;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden=TRUE;
    [self hideTabBar];
    btnImage = [UIImage imageNamed:@""];
    btnImageSelected = [UIImage imageNamed:@""];
    [self addCustomElements];

}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.hidden=TRUE;
//    [self hideTabBar];
//    btnImage = [UIImage imageNamed:@""];
//    btnImageSelected = [UIImage imageNamed:@""];
//	[self addCustomElements];
//}

- (void)hideTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

- (void)hideNewTabBar 
{
    self.btn1.hidden = 1;
    self.btn2.hidden = 1;
    self.btn3.hidden = 1;
    self.btn4.hidden = 1;
//    self.btn5.hidden = 1;
}

- (void)showNewTabBar 
{
    self.btn1.hidden = 0;
    self.btn2.hidden = 0;
    self.btn3.hidden = 0;
    self.btn4.hidden = 0;
//    self.btn5.hidden = 0;
}

-(void)addCustomElements
{
	// Initialise our two images
    
    
    btnImage = [UIImage imageNamed:@"skillsTabU"];
    btnImageSelected = [UIImage imageNamed:@"skillsTabS"];
    
	self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
	btn1.frame = CGRectMake(0,Screen.size.height-btnHeight,Screen.size.width/numberOfTabs, btnHeight); // Set the frame (size and position) of the button)
	[btn1 setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
	[btn1 setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
	[btn1 setTag:0]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
	[btn1 setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
	
	// Now we repeat the process for the other buttons
    btnImage = [UIImage imageNamed:@"challengesTabU"];
    btnImageSelected = [UIImage imageNamed:@"challengesTabS"];
	self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
	btn2.frame = CGRectMake(Screen.size.width/numberOfTabs, Screen.size.height-btnHeight, Screen.size.width/numberOfTabs, btnHeight);
	[btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[btn2 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[btn2 setTag:1];
	
    btnImage = [UIImage imageNamed:@"loverTabU"];
    btnImageSelected = [UIImage imageNamed:@"loverTabS"];
	self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
	btn3.frame = CGRectMake((Screen.size.width/numberOfTabs)*2, Screen.size.height-btnHeight, Screen.size.width/numberOfTabs, btnHeight);
	[btn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[btn3 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[btn3 setTag:2];
	
    btnImage = [UIImage imageNamed:@"meetTabU"];
    btnImageSelected = [UIImage imageNamed:@"meetTabS"];
	self.btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
	btn4.frame = CGRectMake((Screen.size.width/numberOfTabs)*3, Screen.size.height-btnHeight, Screen.size.width/numberOfTabs, btnHeight);
	[btn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[btn4 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[btn4 setTag:3];
    
    /*
    btnImage = [UIImage imageNamed:@"about-inactive.png"];
    btnImageSelected = [UIImage imageNamed:@"about-active.png"];
    self.btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake((Screen.size.width/numberOfTabs)*4, Screen.size.height-btnHeight, Screen.size.width/numberOfTabs, btnHeight);
    [btn5 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn5 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn5 setTag:4];
     */
	
	// Add my new buttons to the view
	[self.view addSubview:btn1];
	[self.view addSubview:btn2];
	[self.view addSubview:btn3];
	[self.view addSubview:btn4];
//    [self.view addSubview:btn5];
	
	// Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
	[btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [btn5 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClicked:(id)sender
{
	NSInteger tagNum = [sender tag];
	[self selectTab:(int)tagNum];
}

- (void)selectTab:(int)tabID
{
    
   // if (self.selectedIndex == tabID) {
//        [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
   // }
	switch(tabID)
	{
		case 0:
			[btn1 setSelected:true];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
//            [btn5 setSelected:false];
			break;
		case 1:
			[btn1 setSelected:false];
			[btn2 setSelected:true];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
//            [btn5 setSelected:false];
			break;
		case 2:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:true];
			[btn4 setSelected:false];
//            [btn5 setSelected:false];
			break;
		case 3:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:true];
//            [btn5 setSelected:false];
            break;
            
        case 4:
            [btn1 setSelected:false];
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            [btn4 setSelected:false];
//            [btn5 setSelected:true];
            break;
	}	
	self.selectedIndex = tabID;
//    [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];

}



@end
