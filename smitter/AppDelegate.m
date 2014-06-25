//
//  AppDelegate.m
//  smitter
//
//  Created by Guy Morita on 6/21/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainTableViewController.h"
#import "TwitterClient.h"

@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dictionary setObject:val forKey:key];
    }
    
    return dictionary;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    TwitterClient *client = [TwitterClient instance];
    BDBOAuthToken *token = [client.requestSerializer accessToken];
    NSArray *vcs = @[[[LoginViewController alloc] init], [[MainTableViewController alloc] init]];
    NSInteger vcToStart = 0;
    if (token) {
        vcToStart = 1;
    }
    
    self.appNavController = [[UINavigationController alloc] initWithRootViewController:vcs[vcToStart]];
    self.appNavController.navigationBar.barTintColor = [UIColor colorWithRed:80.0f/255.0f green:172.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    
    self.appNavController.navigationBar.opaque = YES;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.appNavController.navigationBar setTitleTextAttributes:attributes];
    self.appNavController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    self.window.rootViewController = self.appNavController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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

// this is what will get called everytime my app is opened from a URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"cpsmitter"])
    {
        if ([url.host isEqualToString:@"oauth"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                TwitterClient *client = [TwitterClient instance];
                [client fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    NSLog(@"Got Access Token");
                    [client.requestSerializer saveAccessToken:accessToken];
                    [self.appNavController popViewControllerAnimated:YES];
                    MainTableViewController *mainVC = [[MainTableViewController alloc] init];
                    [self.appNavController pushViewController:mainVC animated:YES];
                    
                } failure:^(NSError *error) {
                    NSLog(@"Didn't get Access Token");
                }];
            }
            
        }
        return YES;
    }
    return NO;
}

@end
