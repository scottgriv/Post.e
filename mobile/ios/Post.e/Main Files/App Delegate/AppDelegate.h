//
//  AppDelegate.h
//  Post.e
//
//  Created by Scott Grivner on 10/3/21.
//

#import <UIKit/UIKit.h>
#import "TabBarController.h"
#import "Login.h"
#import "Constants.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//Variables
@property (strong, nonatomic) UIWindow * appWindow;
@property (readwrite, assign) NSInteger token;
@property (nonatomic, strong) NSString * tokenID;
@property (nonatomic, assign) BOOL bannerShowing;
@property (nonatomic, assign) BOOL disableBanner;

//Methods
- (NSURL *)applicationDocumentsDirectory;

@end

