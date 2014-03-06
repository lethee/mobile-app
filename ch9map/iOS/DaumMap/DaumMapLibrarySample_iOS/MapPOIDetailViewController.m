//
//  MapPOIDetailViewController.m
//  MobileMap
//
//  Created by Byung-Wan Lim on 2/15/12.
//  Copyright (c) 2012 Daum Communications. All rights reserved.
//

#import "MapPOIDetailViewController.h"

@implementation MapPOIDetailViewController

- (id)initWithMapPOIItem:(MTMapPOIItem*)poiItem {
    self = [super init];
    if (self) {
		_poiItem = [poiItem retain];
    }
    return self;
}

- (void)dealloc {
	[_poiItem release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)_onCloseTouched {
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
	label.text = [NSString stringWithFormat:@"POI Name : %@", _poiItem.itemName];
	[self.view addSubview:label];
	[label release];
	
	UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	closeButton.frame = CGRectMake(10, 10 + 30 + 10, 60, 30);
	[closeButton setTitle:@"Close" forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(_onCloseTouched) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:closeButton];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIDeviceOrientationPortrait);
}

@end
