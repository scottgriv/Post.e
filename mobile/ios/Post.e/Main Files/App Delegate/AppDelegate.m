//
//  AppDelegate.m
//  Post.e
//
//  Created by Scott Grivner on 10/3/21.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize bannerShowing, disableBanner, token, tokenID, appWindow;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        
        //Welcome Message
        NSLog(@"\n\nWELCOME to Post.e!!! 👋👋👋\n\n✅ First Time Launch!\n");
        
        //Save Flag to Defaults for First Time Launch
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useSampleDirectory"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Create Sample File Directory
        [self createDirForExampleFiles:@"Post.e Sample Files"];
        
    } else {
        
        //Welcome Message
        NSLog(@"\n\nWELCOME BACK to Post.e!!! 👋👋👋\n\n❌ Not First Time Launch!\n");
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Comment below out if not testing:
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useSampleDirectory"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self createDirForExampleFiles:@"Post.e Sample Files"];
        
    }
    
    return true;
}

-(void)createDirForExampleFiles:(NSString *)dirName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //Sample File Folder Name
    NSString *path = [documentsDirectory stringByAppendingPathComponent:dirName];
    NSError *error;
    
    //Does Directory Already Exist?
    if (![fileManager fileExistsAtPath:path]) {
        
        //Create Directory
        if (![fileManager createDirectoryAtPath:path
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error])
        {
            NSLog(@"Create directory error: %@ for path:%@", error, path);
            
        } else {
            
            NSLog(@"Create directory success for path: %@", path);
            
            //Example File Names
            NSString *txtPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", @"txt_Sample"]];
            NSString *pngPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", @"png_Sample"]];
            NSString *jpgPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", @"jpg_Sample"]];
            NSString *pdfPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", @"pdf_Sample"]];
            
            //Copy .txt File from Bundle to Sample File Directory
            if ([fileManager fileExistsAtPath:txtPath] == NO)
            {
                NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"txt_Sample" ofType:@"txt"];
                [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
                if (error) {
                    NSLog(@"Error on copying file: %@\nfrom path: %@\ntoPath: %@", error, resourcePath, txtPath);
                } else {
                    NSLog(@"Success on copying file from path: %@\ntoPath: %@", resourcePath, txtPath);
                }
            } else {
                
                NSLog(@"File Already Exists for Path: %@", txtPath);
                
            }
            
            //Copy .png File from Bundle to Sample File Directory
            if ([fileManager fileExistsAtPath:pngPath] == NO)
            {
                NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"png_Sample" ofType:@"png"];
                [fileManager copyItemAtPath:resourcePath toPath:pngPath error:&error];
                if (error) {
                    NSLog(@"Error on copying file: %@\nfrom path: %@\ntoPath: %@", error, resourcePath, pngPath);
                } else {
                    NSLog(@"Success on copying file from path: %@\ntoPath: %@", resourcePath, pngPath);
                }
            } else {
                
                NSLog(@"File Already Exists for Path: %@", pngPath);
                
            }
            
            //Copy .jpg File from Bundle to Sample File Directory
            if ([fileManager fileExistsAtPath:jpgPath] == NO)
            {
                NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"jpg_Sample" ofType:@"jpg"];
                [fileManager copyItemAtPath:resourcePath toPath:jpgPath error:&error];
                if (error) {
                    NSLog(@"Error on copying file: %@\nfrom path: %@\ntoPath: %@", error, resourcePath, jpgPath);
                } else {
                    NSLog(@"Success on copying file from path: %@\ntoPath: %@", resourcePath, jpgPath);
                }
            } else {
                
                NSLog(@"File Already Exists for Path: %@", jpgPath);
                
            }
            
            //Copy .pdf File from Bundle to Sample File Directory
            if ([fileManager fileExistsAtPath:pdfPath] == NO)
            {
                NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"pdf_Sample" ofType:@"pdf"];
                [fileManager copyItemAtPath:resourcePath toPath:pdfPath error:&error];
                if (error) {
                    NSLog(@"Error on copying file: %@\nfrom path: %@\ntoPath: %@", error, resourcePath, pdfPath);
                } else {
                    NSLog(@"Success on copying file from path: %@\ntoPath: %@", resourcePath, pdfPath);
                }
            } else {
                
                NSLog(@"File Already Exists for Path: %@", pdfPath);
                
            }
        }
        
    } else {
        
        NSLog(@"Directory Already Exists for path: %@", path);
        
    }
    
}

#pragma mark - UISceneSession lifecycle
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
    
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//Check Network Reachability
-(void)checkNetworkReachability {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    bannerShowing = NO;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:appDelegate.window
                                                            style:ALAlertBannerStyleWarning
                                                         position:ALAlertBannerPositionUnderNavBar
                                                            title:@"No Internet Connection"
                                                         subtitle:nil//];
                                                      tappedBlock:^(ALAlertBanner *alertBanner) {
            
            NSLog(@"Banner Tapped!");
            
        }];
        
        banner.secondsToShow = 0;
        
        
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        NSLog(@"%u", banner.state);
        NSLog(self->bannerShowing ? @"Banner Showing? Yes" : @"Banner Showing? No");
        
        // Check the reachability status and show an alert if the internet connection is not available
        switch (status) {
                
            case -1:
                
                // AFNetworkReachabilityStatusUnknown = -1,
                NSLog(@"The reachability status is Unknown");
                
                if (!self.bannerShowing)  {
                    
                    if (!self.disableBanner) {
                        
                        [banner show];
                        self.bannerShowing = YES;
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"Network_Unreachable" object:self];
                        
                    } else {
                        
                        self.disableBanner = NO;
                    }
                    
                }
                
                break;
                
            case 0:
                // AFNetworkReachabilityStatusNotReachable = 0
                NSLog(@"The reachability status is not reachable");
                
                if (!self.bannerShowing)  {
                    
                    if (!self.disableBanner) {
                        
                        [banner show];
                        self.bannerShowing = YES;
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"Network_Unreachable" object:self];
                        
                    } else {
                        
                        self.disableBanner = NO;
                    }
                    
                }
                
                break;
                
            case 1:
                
                //AFNetworkReachabilityStatusReachableViaWAN = 1
                NSLog(@"The reachability status is reachable via WAN");
                
                if (self.bannerShowing)  {
                    
                    [ALAlertBanner hideAlertBannersInView:appDelegate.window];
                    self.bannerShowing = NO;
                    
                    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:appDelegate.window
                                                                        style:ALAlertBannerStyleSuccess
                                                                     position:ALAlertBannerPositionUnderNavBar
                                                                        title:@"Network is Reachable!"
                                                                     subtitle:nil];
                    
                    
                    
                    
                    [banner show];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Network_Reachable" object:self];
                    
                }
                
                break;
            case 2:
                
                // AFNetworkReachabilityStatusReachableViaWiFi = 2
                NSLog(@"The reachability status is reachable via WiFi");
                
                if (self.bannerShowing)  {
                    
                    [ALAlertBanner hideAlertBannersInView:appDelegate.window];
                    self.bannerShowing = NO;
                    
                    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:appDelegate.window
                                                                        style:ALAlertBannerStyleSuccess
                                                                     position:ALAlertBannerPositionUnderNavBar
                                                                        title:@"Network is Reachable!"
                                                                     subtitle:nil];
                    
                    
                    
                    
                    [banner show];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Network_Reachable" object:self];
                    
                }
                
                break;
                
            default:
                break;
        }
        
    }];
    
}

@end
