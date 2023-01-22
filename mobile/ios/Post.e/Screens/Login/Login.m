//
//  Login.m
//  Post.e
//
//  Created by Scott Grivner on 10/3/21.
//

#import "Login.h"

@interface Login ()

@end

@implementation Login

@synthesize fldUsername, fldPassword, loginBtn, registerBtn, configureBtn, spinner, language;

- (IBAction)Unwind_to_Login:(UIStoryboardSegue *)unwindSegue
{
    
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.fldUsername.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.fldUsername.layer.cornerRadius = 10;
    self.fldPassword.layer.cornerRadius = 10;
    self.loginBtn.layer.cornerRadius = 10;
    self.registerBtn.layer.cornerRadius = 10;
    self.configureBtn.layer.cornerRadius = 10;
    
    if (@available(iOS 13.0, *)) {
        self.fldUsername.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        self.fldPassword.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    self.spinner.hidden = YES;
    [self.loginBtn setEnabled:NO];
    
    if ([WCSession isSupported]){
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    self.language = [[NSUserDefaults standardUserDefaults] valueForKey:@"language"];
    
    if ([self.language isEqualToString:@""]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"php" forKey:@"language"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
}

-(void)dismissKeyboard {
    
    [self.fldUsername resignFirstResponder];
    [self.fldPassword resignFirstResponder];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    
    self.fldUsername.text = nil;
    self.fldPassword.text = nil;
    
    [self stopSpinner];
    [self.loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    
}

-(void)startSpinner {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.spinner.center = self.loginBtn.center;
        self.spinner.hidesWhenStopped = YES;
        self.spinner.hidden = NO;
        [self.spinner startAnimating];
        
    });
    
}

-(void)stopSpinner {
    
    [self.spinner stopAnimating];
    [self.loginBtn setTitle:@"Login" forState:UIControlStateNormal];
}

- (IBAction)enableLoginBtn {
    
    if ([self.fldUsername.text length] != 0 && [self.fldPassword.text length] != 0) {
        
        [self.loginBtn setEnabled:YES];
    }
    else {
        [self.loginBtn setEnabled:NO];
    }
    
}

- (IBAction)loginClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    self.loginBtn.enabled = false;
    
    [self.loginBtn setTitle:@"" forState:UIControlStateNormal];
    [NSThread detachNewThreadSelector:@selector(startSpinner) toTarget:self withObject:nil];
    
    //Username AND Password AND Re-enter Password fields must contain characters
    if([[self.fldUsername text] isEqualToString:@""] || [[self.fldPassword text] isEqualToString:@""]) {
        
        [NSThread detachNewThreadSelector:@selector(stopSpinner) toTarget:self withObject:nil];
        [self.loginBtn setTitle:@"Login" forState:UIControlStateNormal];
        
        self.loginBtn.enabled = true;
        
        
    } else {
        
        [self beginLogin];
        
    }
}

-(void)beginLogin {
    
    UIProgressView * progressView;
    
    NSMutableDictionary * parametersDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSString stringWithFormat: @"%@", [self.fldUsername text]], @"username",
                                                  [NSString stringWithFormat: @"%@", [self.fldPassword text]], @"password",
                                                  @"Login", @"command",
                                                  nil];
    
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer]
                                     multipartFormRequestWithMethod:@"POST"
                                     URLString:[[[Constants alloc] formatURL:LoginURL] absoluteString]
                                     parameters:parametersDictionary
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
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                style:ALAlertBannerStyleFailure
                                                             position:ALAlertBannerPositionUnderNavBar
                                                                title:@"Please try checking your connection and try again!"
                                                             subtitle:nil];
            
            NSLog(@"%u", banner.state);
            
            [banner show];
            [self stopSpinner];
            self.loginBtn.enabled = true;
            
            
        } else {
            
            NSLog(@"%@ %@", response, responseObject);
            
            NSInteger success = [[responseObject valueForKey:@"success"] integerValue];
            
            if (success == 1){
                
                NSInteger newToken = [[responseObject valueForKey:@"token"] integerValue];
                NSString * newTokenID = [responseObject valueForKey:@"tokenID"];
                
                [SSKeychain setPassword:[NSString stringWithFormat: @"%ld", newToken] forService:[[NSBundle mainBundle] bundleIdentifier] account:@"token"];
                [SSKeychain setPassword:newTokenID forService:[[NSBundle mainBundle] bundleIdentifier] account:@"tokenID"];
                
                ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                    style:ALAlertBannerStyleSuccess
                                                                 position:ALAlertBannerPositionUnderNavBar
                                                                    title:@"Login Successs!"
                                                                 subtitle:nil];
                
                NSLog(@"%u", banner.state);
                
                [banner show];
                
                if ([[WCSession defaultSession] isReachable]) {
                    
                    NSLog(@"Valid Watch Session!");
                    
                    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     [NSString stringWithFormat: @"%ld", newToken], @"token",
                                                     self.language, @"language",
                                                     nil];
                    
                    [[WCSession defaultSession] sendMessage:applicationData
                                               replyHandler:^(NSDictionary *reply) {
                        //handle reply from iPhone app here
                    }
                                               errorHandler:^(NSError *error) {
                        //catch any errors here
                    }
                    ];
                    
                } else {
                    
                    NSLog(@"Invalid Watch Session!");
                }
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                [self performSegueWithIdentifier:@"Login_to_Tab" sender:self];
                
            } else {
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                NSString * errorMessage = [responseObject valueForKey:@"error_message"];
                
                ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                    style:ALAlertBannerStyleFailure
                                                                 position:ALAlertBannerPositionUnderNavBar
                                                                    title:errorMessage
                                                                 subtitle:nil];
                
                NSLog(@"%u", banner.state);
                
                [banner show];
                [self stopSpinner];
                self.loginBtn.enabled = true;
                
            }
            
        }
        
    }];
    
    [uploadTask resume];
    
}
//Hide keyboard when background is tapped
- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

//Hide keyboard when Return is selected
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"Login_to_Tab"]) {
        
        TabBarController *tc = (TabBarController*)segue.destinationViewController;
        NSLog(@"View: %@", tc.view);
        
    }
    
}

- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {
    
    // In this case, the message content being sent from the app is a simple begin message. This tells the app to wake up and begin sending location information to the watch.
    NSLog(@"Reached IOS APP");
}
-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message{
    NSLog(@"Reached IOS APP");
}

- (void)session:(nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
    
}


- (void)sessionDidBecomeInactive:(nonnull WCSession *)session {
    
}


- (void)sessionDidDeactivate:(nonnull WCSession *)session {
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
