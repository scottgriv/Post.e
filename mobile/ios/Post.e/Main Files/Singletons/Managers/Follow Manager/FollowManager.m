//
//  FollowManager.m
//  Post.e
//
//  Created by Scott Grivner on 1/12/22.
//

#import "FollowManager.h"
#import "Profile.h"
#import "ProfileCell.h"
#import "Interaction.h"
#import "InteractionCell.h"

@interface FollowManager ()

@end

@implementation FollowManager

@synthesize followManagerDelegate, unfollowMessage, followFlagCheck, parametersDictionary;

- (void)followSetup:(BOOL)followFlag dataManager:(DataManager *)data tableViewCell:(UITableViewCell *)cell viewController:(UIViewController *)vc {
    
    if ([vc isKindOfClass:[Profile class]]) {
        
        Profile *profile = (Profile *)vc;
        ProfileCell *profileCell = (ProfileCell *)cell;
        
        [profileCell.profFollowBtn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [profileCell.profFollowBtn.layer setValue:profile forKey:@"vc"];
        [profileCell.profFollowBtn.layer setValue:data forKey:@"data"];
        [profileCell.profFollowBtn.layer setValue:cell forKey:@"cell"];
        
        followFlagCheck = followFlag;
        
        /// 1 - Following
        if (followFlag) {
            
            //Setup Follow Button
            [profileCell.profFollowBtn setTitle: [NSString stringWithFormat:NSLocalizedString(@"PROFILE_FOLLOWING", @"Following")] forState: UIControlStateNormal];
            [profileCell.profFollowBtn addTarget:self action:@selector(unfollowBtnClicked:)forControlEvents:UIControlEventTouchUpInside];
            profileCell.profFollowBtn.layer.backgroundColor = [[UIColor greenColor] CGColor];
            profileCell.profFollowBtn.backgroundColor = [UIColor greenColor];
            [profileCell.profFollowBtn.layer setValue:@"Unfollow" forKey:@"followStatus"];
            profileCell.profFollowBtn.backgroundColor = [UIColor greenColor];
            
            /// 0 - Not Following
            ///
        } else {
            
            //Setup Follow Button
            [profileCell.profFollowBtn setTitle: [NSString stringWithFormat:NSLocalizedString(@"PROFILE_FOLLOW", @"Follow")] forState: UIControlStateNormal];
            [profileCell.profFollowBtn addTarget:self action:@selector(followBtnClicked:)forControlEvents:UIControlEventTouchUpInside];
            profileCell.profFollowBtn.backgroundColor = [UIColor blueColor];
            [profileCell.profFollowBtn.layer setValue:@"Follow" forKey:@"followStatus"];
            
        }
        
    } else if ([vc isKindOfClass:[Interaction class]]) {
        
        Interaction *interaction = (Interaction *)vc;
        InteractionCell *interactionCell = (InteractionCell *)cell;
        
        [interactionCell.interProfFollowBtn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [interactionCell.interProfFollowBtn.layer setValue:interaction forKey:@"vc"];
        [interactionCell.interProfFollowBtn.layer setValue:data forKey:@"data"];
        [interactionCell.interProfFollowBtn.layer setValue:cell forKey:@"cell"];
        
        followFlagCheck = followFlag;
        
        /// 1 - Following
        if (followFlag) {
            
            //Setup Follow Button
            [interactionCell.interProfFollowBtn setTitle: [NSString stringWithFormat:NSLocalizedString(@"PROFILE_FOLLOWING", @"Following")] forState: UIControlStateNormal];
            [interactionCell.interProfFollowBtn addTarget:self action:@selector(unfollowBtnClicked:)forControlEvents:UIControlEventTouchUpInside];
            interactionCell.interProfFollowBtn.layer.backgroundColor = [[UIColor greenColor] CGColor];
            interactionCell.interProfFollowBtn.backgroundColor = [UIColor greenColor];
            [interactionCell.interProfFollowBtn.layer setValue:@"Unfollow" forKey:@"followStatus"];
            interactionCell.interProfFollowBtn.backgroundColor = [UIColor greenColor];
            
            /// 0 - Not Following
            ///
        } else {
            
            //Setup Follow Button
            [interactionCell.interProfFollowBtn setTitle: [NSString stringWithFormat:NSLocalizedString(@"PROFILE_FOLLOW", @"Follow")] forState: UIControlStateNormal];
            [interactionCell.interProfFollowBtn addTarget:self action:@selector(followBtnClicked:)forControlEvents:UIControlEventTouchUpInside];
            interactionCell.interProfFollowBtn.backgroundColor = [UIColor blueColor];
            [interactionCell.interProfFollowBtn.layer setValue:@"Follow" forKey:@"followStatus"];
            
        }
        
    }
    
}

- (void)followBtnClicked:(UIButton*)sender {
    
    NSString * followStatus = [sender.layer valueForKey:@"followStatus"];
    UIViewController * vc = [sender.layer valueForKey:@"vc"];
    UITableViewCell * cell = [sender.layer valueForKey:@"cell"];
    DataManager * data = [sender.layer valueForKey:@"data"];
    
    [self followRequest:followStatus dataManager:data tableViewCell:cell viewController:vc];
    
}


- (void)unfollowBtnClicked:(UIButton*)sender {
    
    NSString * followStatus = [sender.layer valueForKey:@"followStatus"];
    UIViewController * vc = [sender.layer valueForKey:@"vc"];
    UITableViewCell * cell = [sender.layer valueForKey:@"cell"];
    DataManager * data = [sender.layer valueForKey:@"data"];
    
    if ([vc isKindOfClass:[Profile class]]) {
        
        unfollowMessage = [NSString stringWithFormat:@"%@ %@?", followStatus, data.profileUser];
        
    } else if ([vc isKindOfClass:[Interaction class]]) {
        
        unfollowMessage = [NSString stringWithFormat:@"%@ %@?", followStatus, data.interactionProfileUser];
        
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:unfollowMessage preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"User clicked button called %@ or tapped elsewhere",action.title);
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", followStatus] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"User clicked button called %@",action.title);
        
        [self followRequest:followStatus dataManager:data tableViewCell:cell viewController:vc];
        
    }]];
    
    if ([vc isKindOfClass:[Profile class]]) {
        
        Profile *profile = (Profile *)vc;
        [profile presentViewController:alertController animated:YES completion:nil];
        
    } else if ([vc isKindOfClass:[Interaction class]]) {
        
        Interaction *interaction = (Interaction *)vc;
        [interaction presentViewController:alertController animated:YES completion:nil];
    }
    
}


-(void)followRequest:(NSString*)followStatus dataManager:(DataManager *)data tableViewCell:(UITableViewCell *)cell viewController:(UIViewController *)vc {
    
    UIProgressView * progressView;
    
    if ([vc isKindOfClass:[Profile class]]) {
        
        self.parametersDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSString stringWithFormat: @"%ld", data.profileID], @"profile_ID",
                                     [NSString stringWithFormat: @"%@", followStatus], @"command",
                                     nil];
        
        
    } else if ([vc isKindOfClass:[Interaction class]]) {
        
        self.parametersDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSString stringWithFormat: @"%ld", data.interactionProfileID], @"profile_ID",
                                     [NSString stringWithFormat: @"%@", followStatus], @"command",
                                     nil];
    }
    
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer]
                                     multipartFormRequestWithMethod:@"POST"
                                     URLString:[[[Constants alloc] formatURL:InteractionURL] absoluteString]
                                     parameters:self.parametersDictionary
                                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
        // This is not called back on the main queue.
        // You are responsible for dispatching to the main queue for UI updates
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update the progress view
            [progressView setProgress:uploadProgress.fractionCompleted];
        });
    }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        
        UIScene *scene = [[[[UIApplication sharedApplication] connectedScenes] allObjects] firstObject];
        UIWindow *window = [(id <UIWindowSceneDelegate>)scene.delegate window];
        
        if (error) {
            
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                style:ALAlertBannerStyleFailure
                                                             position:ALAlertBannerPositionUnderNavBar
                                                                title:@"An error has occured!"
                                                             subtitle:nil];
            
            NSLog(@"%u", banner.state);
            
            [banner show];
            
        } else {
            
            BOOL success = [[responseObject valueForKey:@"success"] boolValue];
            BOOL newFlag = [[responseObject valueForKey:@"new_flag"] boolValue];
            NSInteger newFollowCount = [[responseObject valueForKey:@"new_follow_count"] integerValue];
            
            if (success) {
                
                NSLog(@"success!");
                
                if ([vc isKindOfClass:[Profile class]]) {
                    
                    Profile *profile = (Profile *)vc;
                    ProfileCell * profileCell = (ProfileCell *)cell;
                    data.profileFollowFlag = newFlag;
                    
                    data.profileFollowerCount = newFollowCount;
                    [profile.postHeaderArray replaceObjectAtIndex:0 withObject:data];
                    [profileCell.profFollowBtn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
                    
                    [profile setupTableViewHeader];
                    
                } else if ([vc isKindOfClass:[Interaction class]]) {
                    
                    Interaction *interaction = (Interaction *)vc;
                    InteractionCell * interactionCell = (InteractionCell *)cell;
                    NSIndexPath *indexPath = [interaction.interactionTable indexPathForCell:interactionCell];
                    data.interactionProfileFollowFlag = newFlag;
                    [interaction.interactionArray replaceObjectAtIndex:indexPath.row withObject:data];
                    [interactionCell.interProfFollowBtn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
                    
                    [interaction.interactionTable reloadData];
                }
                
            } else {
                
                UIScene *scene = [[[[UIApplication sharedApplication] connectedScenes] allObjects] firstObject];
                UIWindow *window = [(id <UIWindowSceneDelegate>)scene.delegate window];
                
                if ([vc isKindOfClass:[Profile class]]) {
                    
                    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                        style:ALAlertBannerStyleFailure
                                                                     position:ALAlertBannerPositionUnderNavBar
                                                                        title:[NSString stringWithFormat:@"There was a problem %@ing %@, please try again later.", followStatus,  data.profileUser]
                                                                     subtitle:nil];
                    
                    NSLog(@"%u", banner.state);
                    
                    [banner show];
                    
                } else if ([vc isKindOfClass:[Interaction class]]) {
                    
                    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                        style:ALAlertBannerStyleFailure
                                                                     position:ALAlertBannerPositionUnderNavBar
                                                                        title:[NSString stringWithFormat:@"There was a problem %@ing %@, please try again later.", followStatus,  data.interactionProfileUser]
                                                                     subtitle:nil];
                    
                    NSLog(@"%u", banner.state);
                    
                    [banner show];
                }
                
            }
            
        }
        
    }];
    
    [uploadTask resume];
    
}

@end
