//
//  PinManager.m
//  Post.e
//
//  Created by Scott Grivner on 4/20/22.
//

#import "PinManager.h"
#import "Profile.h"

@interface PinManager ()

@end

@implementation PinManager

@synthesize pinManagerDelegate, view, table, indexPath, data, array, postPinBtn, postPinCountBtn, parametersDictionary, token, vc;

- (void)pinClicked:(UIButton *)sender{
    
    self.token = [SSKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier] account:@"token"];
    
    view = [sender.layer valueForKey:@"view"];
    table = [sender.layer valueForKey:@"table"];
    indexPath = [sender.layer valueForKey:@"indexPath"];
    data = [sender.layer valueForKey:@"data"];
    array = [sender.layer valueForKey:@"array"];
    postPinCountBtn = [sender.layer valueForKey:@"pinCount"];
    vc = [sender.layer valueForKey:@"vc"];
    
    UIScene *scene = [[[[UIApplication sharedApplication] connectedScenes] allObjects] firstObject];
    UIWindow *window = [(id <UIWindowSceneDelegate>)scene.delegate window];
    
    NSLog(@"View: %@, Data: %@, Table: %@, Array: %@, IndexPath: %ld", view, data, table, array, (long)indexPath.row);
    NSLog(@"Pin Request Flag: %@", data.postsPinFlag ? @"YES" : @"NO");
    
    UIProgressView * progressView;
    
    if (data.postsPinFlag) {
        
        self.parametersDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSString stringWithFormat: @"%ld", data.postsID], @"post_ID",
                                     [NSString stringWithFormat: @"%@", data.postsPinFlag ? @"Unpin" : @"Unpin"], @"command",
                                     nil];
        
    } else {
        
        self.parametersDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSString stringWithFormat: @"%ld", data.postsID], @"post_ID",
                                     [NSString stringWithFormat: @"%@", data.postsPinFlag ? @"Pin" : @"Pin"], @"command",
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
            
            if (success) {
                
                NSLog(@"Pin Flag: %@", self.data.postsPinFlag ? @"YES" : @"NO");
                
                if ([self.vc isKindOfClass:[Profile class]]) {
                    //Setup Header Count
                    if (self.data.postsPinFlag && self.data.postsProfileID == [self.token intValue]) {
                        
                        [self.array removeObjectAtIndex:self.indexPath.row];
                        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [self.table reloadData];
                        
                        Profile *pt = (Profile*)self.vc;
                        [pt setupTableViewHeader];
                        
                        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                            style:ALAlertBannerStyleSuccess
                                                                         position:ALAlertBannerPositionUnderNavBar
                                                                            title:@"Post successfully Unpinned!"
                                                                         subtitle:nil];
                        
                        NSLog(@"%u", banner.state);
                        
                        [banner show];
                        
                    } else if (self.data.postsPinFlag && self.data.postsProfileID != [self.token intValue]) {
                        
                        if (self.data.postsPinCount == 1)  {
                            self.data.postsPinCount = 0;
                            self.data.postsPinFlag = NO;
                        } else {
                            self.data.postsPinCount = self.data.postsPinCount - 1;
                            self.data.postsPinFlag = NO;
                        }
                        
                        [sender setBackgroundImage:[UIImage imageNamed:@"Pin-Unselected"] forState:UIControlStateNormal];
                        [sender setNeedsLayout];
                        
                        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                            style:ALAlertBannerStyleSuccess
                                                                         position:ALAlertBannerPositionUnderNavBar
                                                                            title:@"Post successfully Unpinned!"
                                                                         subtitle:nil];
                        
                        NSLog(@"%u", banner.state);
                        
                        [banner show];
                        
                    } else {
                        
                        self.data.postsPinCount = self.data.postsPinCount + 1;
                        self.data.postsPinFlag = YES;
                        
                        [sender setBackgroundImage:[UIImage imageNamed:@"Pin-Selected"] forState:UIControlStateNormal];
                        [sender setNeedsLayout];
                        
                        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                            style:ALAlertBannerStyleSuccess
                                                                         position:ALAlertBannerPositionUnderNavBar
                                                                            title:@"Post successfully Pinned!"
                                                                         subtitle:nil];
                        
                        NSLog(@"%u", banner.state);
                        
                        [banner show];
                        
                        
                    }
                    
                } else if ([self.vc isKindOfClass:[Reply class]]) {
                    
                    if (self.data.postsPinFlag) {
                        
                        if (self.data.postsPinCount == 1)  {
                            self.data.postsPinCount = 0;
                            self.data.postsPinFlag = NO;
                        } else {
                            self.data.postsPinCount = self.data.postsPinCount - 1;
                            self.data.postsPinFlag = NO;
                        }
                        
                        [sender setBackgroundImage:[UIImage imageNamed:@"Pin-Unselected"] forState:UIControlStateNormal];
                        [sender setNeedsLayout];
                        
                        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                            style:ALAlertBannerStyleSuccess
                                                                         position:ALAlertBannerPositionUnderNavBar
                                                                            title:@"Post successfully Unpinned!"
                                                                         subtitle:nil];
                        
                        NSLog(@"%u", banner.state);
                        
                        [banner show];
                        
                    } else {
                        
                        self.data.postsPinCount = self.data.postsPinCount + 1;
                        self.data.postsPinFlag = YES;
                        
                        [sender setBackgroundImage:[UIImage imageNamed:@"Pin-Selected"] forState:UIControlStateNormal];
                        [sender setNeedsLayout];
                        
                        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                            style:ALAlertBannerStyleSuccess
                                                                         position:ALAlertBannerPositionUnderNavBar
                                                                            title:@"Post successfully Pinned!"
                                                                         subtitle:nil];
                        
                        NSLog(@"%u", banner.state);
                        
                        [banner show];
                        
                    }
                    
                    
                } else if ([self.vc isKindOfClass:[Feed class]]) {
                    //Setup Header Count
                    if (self.data.postsPinFlag && self.data.postsProfileID == [self.token intValue])
                    {
                        
                        //Feed *fd = (Feed*)self.vc;
                        //[Feed setupTableViewHeader];
                        
                        [self.array removeObjectAtIndex:self.indexPath.row];
                        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [self.table reloadData];
                        
                        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                            style:ALAlertBannerStyleSuccess
                                                                         position:ALAlertBannerPositionUnderNavBar
                                                                            title:@"Post successfully Unpinned!"
                                                                         subtitle:nil];
                        
                        NSLog(@"%u", banner.state);
                        
                        [banner show];
                        
                    } else if (self.data.postsPinFlag && self.data.postsProfileID != [self.token intValue]) {
                        
                        if (self.data.postsPinCount == 1)  {
                            self.data.postsPinCount = 0;
                            self.data.postsPinFlag = NO;
                        } else {
                            self.data.postsPinCount = self.data.postsPinCount - 1;
                            self.data.postsPinFlag = NO;
                        }
                        
                        [sender setBackgroundImage:[UIImage imageNamed:@"Pin-Unselected"] forState:UIControlStateNormal];
                        [sender setNeedsLayout];
                        
                        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                            style:ALAlertBannerStyleSuccess
                                                                         position:ALAlertBannerPositionUnderNavBar
                                                                            title:@"Post successfully Unpinned!"
                                                                         subtitle:nil];
                        
                        NSLog(@"%u", banner.state);
                        
                        [banner show];
                        
                    } else {
                        
                        self.data.postsPinCount = self.data.postsPinCount + 1;
                        self.data.postsPinFlag = YES;
                        
                        [sender setBackgroundImage:[UIImage imageNamed:@"Pin-Selected"] forState:UIControlStateNormal];
                        [sender setNeedsLayout];
                        
                        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                            style:ALAlertBannerStyleSuccess
                                                                         position:ALAlertBannerPositionUnderNavBar
                                                                            title:@"Post successfully Pinned!"
                                                                         subtitle:nil];
                        
                        NSLog(@"%u", banner.state);
                        
                        [banner show];
                        
                        
                    }
                    
                }
                
                if (self.data.postsPinCount == 0) {
                    self.postPinCountBtn.hidden = YES;
                    self.postPinCountBtn.enabled = NO;
                    
                } else {
                    
                    [self.postPinCountBtn setTitle: [NSString stringWithFormat:@"%ld", (long)self.data.postsPinCount] forState: UIControlStateNormal];
                    self.postPinCountBtn.hidden = NO;
                    self.postPinCountBtn.enabled = YES;
                    
                }
                
            } else {
                
                ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                    style:ALAlertBannerStyleFailure
                                                                 position:ALAlertBannerPositionUnderNavBar
                                                                    title:[NSString stringWithFormat:@"There was a problem %@ing this post, please try again later.", [NSString stringWithFormat: @"%@", self.data.postsPinFlag ? @"Pinning" : @"Unpinning"]]
                                                                 subtitle:nil];
                
                NSLog(@"%u", banner.state);
                
                [banner show];
                
            }
            
        }
        
    }];
    
    [uploadTask resume];
    
}

@end
