//
//  Register.m
//  Post.e
//
//  Created by Scott Grivner on 10/3/21.
//

#import "Register.h"

@interface Register ()

@end

@implementation Register

@synthesize fldUsername, fldPassword, fldRePassword, registerBtn, backBtn, spinner, language;

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.fldUsername.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fldRePassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.fldUsername.layer.cornerRadius = 10;
    self.fldPassword.layer.cornerRadius = 10;
    self.fldRePassword.layer.cornerRadius = 10;
    self.registerBtn.layer.cornerRadius = 10;
    self.backBtn.layer.cornerRadius = 10;
    
    if (@available(iOS 13.0, *)) {
        self.fldUsername.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        self.fldPassword.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        self.fldRePassword.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    self.spinner.hidden = YES;
    [self.registerBtn setEnabled:NO];
    
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
    [self.fldRePassword resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    
}


-(void)viewDidDisappear:(BOOL)animated {
    
    self.fldUsername.text = nil;
    self.fldPassword.text = nil;
    self.fldRePassword.text = nil;
    
    [self stopSpinner];
    [self.registerBtn setTitle:@"Register" forState:UIControlStateNormal];
}

- (IBAction)enableRegisterBtn {
    
    if ([self.fldUsername.text length] != 0 && [self.fldPassword.text length] != 0 && [self.fldRePassword.text length] != 0) {
        
        [self.registerBtn setEnabled:YES];
    }
    else {
        [self.registerBtn setEnabled:NO];
    }
}

-(void)startSpinner {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.spinner.center = self.registerBtn.center;
        self.spinner.hidesWhenStopped = YES;
        self.spinner.hidden = NO;
        [self.spinner startAnimating];
        
    });
    
}

-(void)stopSpinner {
    
    [self.spinner stopAnimating];
    [self.registerBtn setTitle:@"Register" forState:UIControlStateNormal];
}

//Register Button Clicked -> Check Database
- (IBAction)registerClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    self.registerBtn.enabled = false;
    
    [self.registerBtn setTitle:@"" forState:UIControlStateNormal];
    [NSThread detachNewThreadSelector:@selector(startSpinner) toTarget:self withObject:nil];
    
    //Username AND Password AND Re-enter Password fields must contain characters
    if([[self.fldUsername text] isEqualToString:@""] && [[self.fldPassword text] isEqualToString:@""] && [[self.fldRePassword text] isEqualToString:@""]) {
        
        [NSThread detachNewThreadSelector:@selector(stopSpinner) toTarget:self withObject:nil];
        [self.registerBtn setTitle:@"Register" forState:UIControlStateNormal];
        
        UIScene *scene = [[[[UIApplication sharedApplication] connectedScenes] allObjects] firstObject];
        UIWindow *window = [(id <UIWindowSceneDelegate>)scene.delegate window];
        
        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                            style:ALAlertBannerStyleNotify
                                                         position:ALAlertBannerPositionUnderNavBar
                                                            title:@"Warning!"
                                                         subtitle:@"All fields must be filled in!"];
        
        NSLog(@"%u", banner.state);
        
        [banner show];
        [self stopSpinner];
        self.registerBtn.enabled = true;
        
        
    } else {
        
        [self beginRegistration];
        
    }
    
}

-(void)beginRegistration {
    
    UIProgressView * progressView;
    
    NSMutableDictionary * parametersDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSString stringWithFormat: @"%@", [self.fldUsername text]], @"username",
                                                  [NSString stringWithFormat: @"%@", [self.fldPassword text]], @"password",
                                                  [NSString stringWithFormat: @"%@", [self.fldRePassword text]], @"repassword",
                                                  @"Register", @"command",
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
                                                                title:@"An error has occured!"
                                                             subtitle:nil];
            
            NSLog(@"%u", banner.state);
            
            [banner show];
            [self stopSpinner];
            self.registerBtn.enabled = true;
            
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
                                                                    title:@"Registration Successs!"
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
                [self performSegueWithIdentifier:@"Register_to_Tab" sender:self];
                
            } else if (success == 0) {
                
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
                self.registerBtn.enabled = true;
                
                
            } else {
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                    style:ALAlertBannerStyleFailure
                                                                 position:ALAlertBannerPositionUnderNavBar
                                                                    title:@"An Error Occured!"
                                                                 subtitle:@"Please Check your Network Connection and Settings."];
                
                NSLog(@"%u", banner.state);
                
                [banner show];
                [self stopSpinner];
                self.registerBtn.enabled = true;
                
            }
            
        }
        
    }];
    
    [uploadTask resume];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"Register_to_Tab"]) {
        
        TabBarController *tc = (TabBarController*)segue.destinationViewController;
        NSLog(@"Tab View Controller: %@", tc);
        
    }
    
}

//hide keyboard when background is tapped
- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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

@end
