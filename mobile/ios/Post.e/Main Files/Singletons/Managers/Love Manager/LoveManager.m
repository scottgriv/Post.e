//
//  LoveManager.m
//  Post.e
//
//  Created by Scott Grivner on 1/17/22.
//

#import "LoveManager.h"
#import "Reply.h"

@interface LoveManager ()

@end

@implementation LoveManager

@synthesize loveManager, view, table, indexPath, data, array, vc, postLoveBtn, postLoveCountBtn, parametersDictionary;

- (void)loveClicked:(UIButton *)sender{
    
    view = [sender.layer valueForKey:@"view"];
    table = [sender.layer valueForKey:@"table"];
    indexPath = [sender.layer valueForKey:@"indexPath"];
    data = [sender.layer valueForKey:@"data"];
    array = [sender.layer valueForKey:@"array"];
    postLoveCountBtn = [sender.layer valueForKey:@"loveCount"];
    vc = [sender.layer valueForKey:@"vc"];
    
    NSLog(@"View: %@, Data: %@, Table: %@, Array: %@, IndexPath: %ld", view, data, table, array, (long)indexPath.row);
    NSLog(@"Love Request Flag: %@", data.postsLoveFlag ? @"YES" : @"NO");
    
    UIProgressView * progressView;
    
    self.parametersDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat: @"%ld", data.postsID], @"post_ID",
                                 [NSString stringWithFormat: @"%@", data.postsLoveFlag ? @"Unlove" : @"Love"], @"command",
                                 nil];
    
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
            
            if (success) {
                
                NSLog(@"Love Flag: %@", self.data.postsLoveFlag ? @"YES" : @"NO");
                
                if (self.data.postsLoveFlag) {
                    
                    if (self.data.postsLoveCount == 1)  {
                        self.data.postsLoveCount = 0;
                        self.data.postsLoveFlag = NO;
                    } else {
                        self.data.postsLoveCount = self.data.postsLoveCount - 1;
                        self.data.postsLoveFlag = NO;
                    }
                    
                    [sender setBackgroundImage:[UIImage imageNamed:@"Love-Unselected"] forState:UIControlStateNormal];
                    [sender setNeedsLayout];
                    
                } else {
                    
                    self.data.postsLoveCount = self.data.postsLoveCount + 1;
                    self.data.postsLoveFlag = YES;
                    
                    [sender setBackgroundImage:[UIImage imageNamed:@"Love-Selected"] forState:UIControlStateNormal];
                    [sender setNeedsLayout];
                    
                }
                
                if (self.data.postsLoveCount == 0) {
                    self.postLoveCountBtn.hidden = YES;
                    self.postLoveCountBtn.enabled = NO;
                    
                } else {
                    
                    [self.postLoveCountBtn setTitle: [NSString stringWithFormat:@"%ld", (long)self.data.postsLoveCount] forState: UIControlStateNormal];
                    self.postLoveCountBtn.hidden = NO;
                    self.postLoveCountBtn.enabled = YES;
                    
                }
                
                //Header Cell does not have an Index Path
                if (self.indexPath == nil) {
                    
                    if ([self.vc isKindOfClass:[Reply class]]) {
                        
                        Reply *reply = (Reply *)self.vc;
                        [reply setupTableViewHeader];
                        
                    } else {
                        
                        [self.array replaceObjectAtIndex:0 withObject:self.data];
                        
                    }
                    
                    //Table Cell does have an Index Path
                } else {
                    
                    NSLog(@"Array: %@", self.array);
                    NSLog(@"Data: %@", self.data);
                    NSLog(@"IndexPath.row: %ld", (long)self.indexPath.row);
                    
                    [self.array replaceObjectAtIndex:self.indexPath.row withObject:self.data];
                    
                }
                
                
            } else {
                
                
                UIScene *scene = [[[[UIApplication sharedApplication] connectedScenes] allObjects] firstObject];
                UIWindow *window = [(id <UIWindowSceneDelegate>)scene.delegate window];
                
                ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                    style:ALAlertBannerStyleFailure
                                                                 position:ALAlertBannerPositionUnderNavBar
                                                                    title:[NSString stringWithFormat:@"There was a problem %@ing this post, please try again later.", [NSString stringWithFormat: @"%@", self.data.postsLoveFlag ? @"Loving" : @"Unloving"]]
                                                                 subtitle:nil];
                
                NSLog(@"%u", banner.state);
                
                [banner show];
                
                
            }
            
        }
        
    }];
    
    [uploadTask resume];
    
}

@end
