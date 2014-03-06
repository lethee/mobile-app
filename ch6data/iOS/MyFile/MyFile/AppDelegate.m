//
//  AppDelegate.m
//  MyFile
//
//  Created by Sean Lee on 13. 11. 5..
//  Copyright (c) 2013년 Sean Lee. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    {
        NSLog(@"Bundle bundlePath  : %@", [[NSBundle mainBundle] bundlePath]);
        NSLog(@"Bundle resourcePath: %@", [[NSBundle mainBundle] resourcePath]);
        
        NSError *resourceError;
        NSString *resourcePath = [[NSBundle mainBundle]
                                  pathForResource:@"Text" ofType:@"txt"];
        NSLog(@"resourceData.path: %@", resourcePath);
        NSLog(@"resourceData: %@", [NSData dataWithContentsOfFile:resourcePath]);
        NSLog(@"resourceData: %@", [NSString stringWithContentsOfFile:resourcePath
                                                             encoding:NSUTF8StringEncoding
                                                                error:&resourceError]);
    }
    
    {
        // Document 디렉토리 및 파일 접근
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES);
        NSString *documentFolderPath = [paths objectAtIndex:0];
        NSLog(@"documentFolderPath: %@", documentFolderPath);
        
        NSError *docResourceError;
        NSString *docResPath = [documentFolderPath
                                stringByAppendingPathComponent:@"Text.txt"];
        
        NSLog(@"docResourceData.path: %@", docResPath);
        
        NSError *resourceError;
        [@"My String Data" writeToFile:docResPath
                            atomically:YES
                              encoding:NSUTF8StringEncoding
                                 error:&docResourceError];
        NSLog(@"docResourceData: %@", [NSString stringWithContentsOfFile:docResPath
                                                                encoding:NSUTF8StringEncoding
                                                                   error:&resourceError]);
        
        // tmp 디렉토리
        
        NSLog(@"Temporary: %@", NSTemporaryDirectory());
        
        // 허용되지 않은 디렉토리 접근
        
        NSString *errPath = [NSHomeDirectory() stringByAppendingPathComponent:@"err.txt"];
        NSError *fileError;
        NSLog(@"Error Path.path: %@" ,errPath);
        [@"Error Path" writeToFile:errPath atomically:YES
                          encoding:NSUTF8StringEncoding error:&fileError];
        if (fileError != nil) {
            NSLog(@"%@", fileError);
        }
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
