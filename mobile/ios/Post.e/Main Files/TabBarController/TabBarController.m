//
//  TabBarController.m
//  Post.e
//
//  Created by Scott Grivner on 10/3/21.
//

#import "TabBarController.h"
#import "Profile.h"

@interface TabBarController ()

@property (nonatomic, weak) UIViewController *rootViewController;

@end

@implementation TabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.delegate = self;
    self.tabBarController.delegate = self;
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if (viewController == [tabBarController.viewControllers objectAtIndex:0]) {
        
        
        static UIViewController *previousController;
        previousController = previousController ?: viewController;
        if (previousController == viewController) {
            if ([viewController isKindOfClass:UINavigationController.class]) {
                UINavigationController *navigationController = (UINavigationController *)viewController;
                if (navigationController.viewControllers.count == 1) {
                    UIViewController *rootViewController = navigationController.viewControllers.firstObject;
                    if ([rootViewController respondsToSelector:@selector(scrollToTop)]) {
                        
                         if ([rootViewController isKindOfClass:[Feed class]]) {
                            
                            Feed *ft = (Feed*)rootViewController;
                                                          
                             if (ft.postArray.count > 0) {
                                
                                [ft scrollToTop];
                                
                            }
                            
                        }
                    }
                }
            }
        }
        
        return YES;
        
    } else if (viewController == [tabBarController.viewControllers objectAtIndex:1]) {
        
        static UIViewController *previousController;
        previousController = previousController ?: viewController;
        if (previousController == viewController) {
            if ([viewController isKindOfClass:UINavigationController.class]) {
                UINavigationController *navigationController = (UINavigationController *)viewController;
                if (navigationController.viewControllers.count == 1) {
                    UIViewController *rootViewController = navigationController.viewControllers.firstObject;
                    if ([rootViewController respondsToSelector:@selector(scrollToTop)]) {
                        
                        if ([rootViewController isKindOfClass:[Profile class]]) {
                            
                            Profile *pt = (Profile*)rootViewController;
                            
                            if (pt.postArray.count > 0) {

                                [pt scrollToTop];
                            }
                            
                        }
                    }
                }
            }
        }
        
        return YES;
        
    } else {
        
        return YES;
    }
    
    return NO;
    
}

@end
