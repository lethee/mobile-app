//
//  ViewController.m
//  DaumMapLibrarySample
//
//  Created by Byung-Wan Lim on 2/15/12.
//  Copyright (c) 2012 Daum Communications. All rights reserved.
//

#import "ViewController.h"
#import "DaumMapSampleViewController.h"

@implementation ViewController


#pragma mark - View lifecycle

- (void)_onButtonTouched {
	
	DaumMapSampleViewController* mapSampleViewController = [[DaumMapSampleViewController alloc] init];
	[self presentModalViewController:mapSampleViewController animated:YES];
	[mapSampleViewController release];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(10, 10, 300, 30);
	[button setTitle:@"Present DaumMapSampleViewController" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(_onButtonTouched) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:button];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIDeviceOrientationPortrait);
}

#pragma -

@end