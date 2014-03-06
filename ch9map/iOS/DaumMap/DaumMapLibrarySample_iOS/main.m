//
//  main.m
//  DaumMapLibrarySample
//
//  Created by Lim Byung-Wan on 2/15/12.
//  Copyright (c) 2011 Daum Communications. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int ret = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    [pool release];
	return ret;
}
