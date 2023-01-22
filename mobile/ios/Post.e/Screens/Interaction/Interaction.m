//
//  Interaction.m
//  Post.e
//
//  Created by Scott Grivner on 1/21/22.
//

#import "Interaction.h"

@interface Interaction ()

@end

static NSString *nibIdentifier0 = @"InteractionCell";
static NSString *nibIdentifier1 = @"LoadMoreCell";

@implementation Interaction

@synthesize followManager, followManagerDelegate;

@synthesize profileID, interactionJSON, interactionArray, interactionArrayLimit, interactionArrayOffset, endOfLoadingRefreshing, noInteractionsFlag, interactionTable, loadingView, viewLoadingAI, pullRefreshView, postCommand, interactionType, segueInterProfID, token, postID;

@synthesize interProfID, interProfUser, interProfName, interProfPic, interProfFollowFlag;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.token = [SSKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier] account:@"token"];
    
    followManager = [[FollowManager alloc] init];
    
    UINib *nib1 = [UINib nibWithNibName:@"LoadMoreCell" bundle:nil];
    [[self interactionTable] registerNib:nib1 forCellReuseIdentifier:@"LoadMoreCell"];
    
    NSLog(@"Profile ID: %li", (long)profileID);
    [self addPullToRefresh];
    
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
        
        //is Dark Mode
        //self.view.backgroundColor = [UIColor blackColor];
        [self loadingOverlay:[UIColor blackColor] overlayFlag:YES];
        
    } else {
        
        //is Light Mode
        //self.view.backgroundColor = [UIColor whiteColor];
        [self loadingOverlay:[UIColor whiteColor] overlayFlag:YES];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"viewWillAppear!");
    [super viewWillAppear:animated];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    //Retrieve First 25 Rows
    interactionArrayLimit = 25;
    interactionArrayOffset = 0;
    interactionArray = [[NSMutableArray alloc]init];
    
    [self retrieveInteractions];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)addPullToRefresh{
    
    self.pullRefreshView = [[UIRefreshControl alloc] init];
    [self.pullRefreshView addTarget: self action: @selector(startRefreshing:) forControlEvents: UIControlEventValueChanged];
    [self.interactionTable addSubview:self.pullRefreshView];
    
}

-(IBAction)startRefreshing:(UIRefreshControl *)sender {
    
    self.interactionArrayLimit = 25;
    self.interactionArrayOffset = 0;
    [self.interactionArray removeAllObjects];
    
    [self.pullRefreshView beginRefreshing];
    
    [self retrieveInteractions];
    
}

- (void)setupTableViewFooter:(BOOL)endOfTable {
    
    LoadMoreCell *footerCell = [self.interactionTable dequeueReusableCellWithIdentifier:nibIdentifier1];
    
    [self.interactionTable setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    [self.interactionTable setContentInset:(UIEdgeInsetsMake(0, 0, 50, 0))];
    
    footerCell.endPic.hidden = YES;
    footerCell.loadMoreAI.hidesWhenStopped = YES;
    [footerCell.loadMoreAI startAnimating];
    endOfLoadingRefreshing = YES;
    
    if (endOfTable) {
        endOfLoadingRefreshing = NO;
        [footerCell.loadMoreAI stopAnimating];
        footerCell.endPic.hidden = NO;
    }
    
    if (noInteractionsFlag == YES) {
        endOfLoadingRefreshing = NO;
        [footerCell.loadMoreAI stopAnimating];
        footerCell.endPic.hidden = YES;
    }
    
    NSLog(@"BEFORE DELETE: endOfLoadingPic.x: %f, endOfLoadingPic.y: %f, loadMoreView.x: %f, loadMoreView.y: %f", footerCell.endPic.frame.origin.x, footerCell.endPic.frame.origin.y, footerCell.frame.origin.x, footerCell.frame.origin.y);
    
    NSLog(@"BEFORE DELETE: interactionTable.height: %f, interactionTable.width: %f, interactionTable.x: %f, interactionTable.y: %f", interactionTable.frame.size.height, interactionTable.frame.size.width, interactionTable.frame.origin.x, interactionTable.frame.origin.y);
    
    self.interactionTable.tableFooterView = footerCell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - Amount of Cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"Post Array Count: %lu", (unsigned long)[self.interactionArray count]);
    
    if (section == 0 && interactionArray.count >= 1) {
        return [self.interactionArray count];
    } else {
        return 0;
    }
    
}

//Height for Row at Index
#pragma mark - Size of Cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        return 70;
        
    }
    
    return 0.0;
    
}

#pragma mark - Retrieve Cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.pullRefreshView.isRefreshing) {
        
        NSLog(@"section: %ld, row: %ld", (long)indexPath.section, (long)indexPath.row);
        
        //Get Interaction Data
        DataManager * myInteraction = [interactionArray objectAtIndex:indexPath.row];
        
        //If Section 1
        if (indexPath.section == 0) {
            
#pragma mark Post Base Cell
            
            //Call Cell
            InteractionCell *interactionCell = [tableView dequeueReusableCellWithIdentifier:nibIdentifier0 forIndexPath:indexPath];
            if (interactionCell == nil) {
                interactionCell = [[InteractionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nibIdentifier0];
            }
            
            //Setup Cell
            interactionCell.accessoryType = UITableViewCellAccessoryNone;
            interactionCell.selectionStyle = UITableViewCellSelectionStyleNone;
            interactionCell.layer.borderColor = [UIColor blackColor].CGColor;
            interactionCell.layer.borderWidth = 0.2;
            
            interactionCell.interProfLoadingAI.hidden = NO;
            [interactionCell.interProfLoadingAI startAnimating];
            
            interactionCell.interProfPicImgVw.contentMode = UIViewContentModeScaleAspectFill;
            
            //Interaction Profile Pic
            if (myInteraction.interactionProfilePic == nil || [myInteraction.interactionProfilePic isEqual:[NSNull null]]) {
                
                interactionCell.interProfPicImgVw.layer.cornerRadius = CGRectGetWidth(interactionCell.interProfPicImgVw.frame) / 2.0f;
                interactionCell.interProfPicImgVw.image = [UIImage imageNamed:@"Default_Prof.png"];
                [interactionCell.interProfPicImgVw.layer setMasksToBounds:YES];
                
                [interactionCell.interProfLoadingAI stopAnimating];
                interactionCell.interProfLoadingAI.hidden = YES;
                
            } else {
                
                __weak UIImageView *weakImageView = interactionCell.interProfPicImgVw;
                NSURLRequest *imageRequest = [NSURLRequest requestWithURL:
                                              [NSURL URLWithString:myInteraction.interactionProfilePic] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
                [interactionCell.interProfPicImgVw setImageWithURLRequest:imageRequest
                                                         placeholderImage:[UIImage imageNamed:@"Default_Prof.png"]
                                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    weakImageView.image = image;
                    weakImageView.layer.cornerRadius = CGRectGetWidth(weakImageView.frame) / 2.0f;
                    [weakImageView.layer setMasksToBounds:YES];
                }
                                                                  failure:nil];
                
                [interactionCell.interProfLoadingAI stopAnimating];
                interactionCell.interProfLoadingAI.hidden = YES;
                
            }
            
            //Interaction Profile User
            [interactionCell.interProfUserBtn setTitle:myInteraction.interactionProfileUser forState:UIControlStateNormal];
            [interactionCell.interProfUserBtn addTarget:self action:@selector(usernameClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            //Interaction Profile Name
            if ([myInteraction.interactionProfileName isEqual:[NSNull null]]) {
                interactionCell.interProfNameLbl.text = @"";
            } else {
                interactionCell.interProfNameLbl.text = myInteraction.interactionProfileName;
            }
            
            //Own Profile
            
            NSLog(@"Profile ID: %ld, Interaction Profile ID: %ld", profileID, myInteraction.interactionProfileID);
            
            if ([self.token intValue] == myInteraction.interactionProfileID) {
                
                interactionCell.interProfFollowBtn.hidden = YES;
                
            } else {
                
                interactionCell.interProfFollowBtn.hidden = NO;
                
                //Following
                if (myInteraction.interactionProfileFollowFlag) {
                    
                    [interactionCell.interProfFollowBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"PROFILE_FOLLOWING", @"Following")] forState:UIControlStateNormal];
                    interactionCell.interProfFollowBtn.backgroundColor = [UIColor greenColor];
                    
                    
                    //Follow
                } else {
                    
                    [interactionCell.interProfFollowBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"PROFILE_FOLLOW", @"Follow")] forState:UIControlStateNormal];
                    interactionCell.interProfFollowBtn.backgroundColor = [UIColor blueColor];
                    
                }
                
                __weak Interaction *vc = self;
                [followManager followSetup:myInteraction.interactionProfileFollowFlag dataManager:myInteraction tableViewCell:interactionCell viewController:vc];
                
                interactionCell.interProfFollowBtn.layer.cornerRadius = 10;
                interactionCell.interProfFollowBtn.clipsToBounds = TRUE;
                
            }
            
            return interactionCell;
            
        }
        
    }
    
    return nil;
}

//This will run everytime a cell is produced
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Save offset to return user to previous screen position
    NSLog(@"Index Path.Row = %lu", (long)indexPath.row);
    NSLog(@"Interaction Array Count  = %lu", (unsigned long)self.interactionArray.count);
    NSLog(@"Interaction JSON Array Count  = %lu", (unsigned long)self.interactionJSON.count);
    
    if ((indexPath.row == self.interactionArray.count - 1) && (self.interactionArray.count >= self.interactionJSON.count) && (self.interactionArray.count >= self.interactionArrayOffset + 25) && self.interactionJSON.count != 0) {
        
        NSLog(@"Load More");
        [self setupTableViewFooter:NO];
        
        self.interactionArrayOffset = [self.interactionArray count];
        self.interactionArrayLimit = 25;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self retrieveInteractions];
            [self setupTableViewFooter:YES];
            
        });
        
    } else if (indexPath.row == interactionArray.count - 1) {
        
        NSLog(@"End of Loading");
        
        [self setupTableViewFooter:YES];
        
    }
    
}

-(void)loadingOverlay:(UIColor *)backgroundColor overlayFlag:(BOOL)showOverlay  {
    
    if (showOverlay) {
        
        
        if (backgroundColor == [UIColor whiteColor] || backgroundColor == [UIColor blackColor]) {
            
            
            CGRect windowFrame = CGRectMake(0,
                                            0,
                                            self.view.bounds.size.width,
                                            self.view.bounds.size.height);
            
            self.loadingView = [[UIView alloc] initWithFrame:windowFrame];
            self.loadingView.backgroundColor = backgroundColor;
            
            self.viewLoadingAI = [[UIActivityIndicatorView alloc]
                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
            
            viewLoadingAI.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
            
            self.interactionTable.hidden = YES;
            [self.viewLoadingAI startAnimating];
            [self.loadingView addSubview:self.viewLoadingAI];
            [self.view addSubview:self.loadingView];
            [self.view bringSubviewToFront:self.loadingView];
            
            viewLoadingAI.center = self.loadingView.center;
            
        } else {
            
            CGRect windowFrame = CGRectMake(0,
                                            0,
                                            [UIScreen mainScreen].bounds.size.width,
                                            [UIScreen mainScreen].bounds.size.height);
            
            
            self.loadingView = [[UIView alloc] initWithFrame:windowFrame];
            self.loadingView.backgroundColor = backgroundColor;
            
            [self.viewLoadingAI startAnimating];
            
            self.viewLoadingAI.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
            
            self.viewLoadingAI.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
            
            self.viewLoadingAI.center = self.loadingView.center;
            
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                
                [self.loadingView addSubview:self.viewLoadingAI];
                
                UIScene *scene = [[[[UIApplication sharedApplication] connectedScenes] allObjects] firstObject];
                UIWindow *window = [(id <UIWindowSceneDelegate>)scene.delegate window];
                
                [window addSubview:self.loadingView];
                
            }
             
                             completion:^(BOOL finished){
                
            }];
            
        }
        
    } else {
        
        [loadingView removeFromSuperview];
        [viewLoadingAI stopAnimating];
        [viewLoadingAI removeFromSuperview];
        interactionTable.hidden = NO;
        
    }
    
}

-(void)resetArrays {
    
    interactionArrayLimit = 25;
    interactionArrayOffset = 0;
    
    [interactionArray removeAllObjects];
    
}

#pragma mark Refresh Control
-(void)pullToRefresh
{
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self retrieveInteractions];
        });
        
    } else {
        
        [pullRefreshView endRefreshing];
        [pullRefreshView removeFromSuperview];
        pullRefreshView = nil;
        
    }
    
}

-(void)retrieveInteractions {
    
    UIProgressView * progressView;
    
    if (!viewLoadingAI.animating && !pullRefreshView.refreshing && !endOfLoadingRefreshing) {
        
        [self loadingOverlay:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.50] overlayFlag:YES];
        
    }
    
    NSDictionary* parametersDictionary;
    
    NSLog(@"%@",[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2]);
    
    parametersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%li", (long)profileID], @"profile_ID",
                            [NSString stringWithFormat:@"%li", (long)postID], @"post_ID",
                            [NSString stringWithFormat: @"%ld", (long)interactionArrayLimit], @"limit",
                            [NSString stringWithFormat: @"%ld", (long)interactionArrayOffset], @"offset",
                            [NSString stringWithFormat:@"%@", interactionType], @"command",
                            nil];
    
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer]
                                     multipartFormRequestWithMethod:@"POST"
                                     URLString:[[[Constants alloc] formatURL:InteractionURL] absoluteString]
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
            
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                style:ALAlertBannerStyleFailure
                                                             position:ALAlertBannerPositionUnderNavBar
                                                                title:@"An error has occured!"
                                                             subtitle:nil];
            
            NSLog(@"%u", banner.state);
            
            [banner show];
            
        } else {
            
            NSLog(@"%@ %@", response, responseObject);
            
            self.interactionArray = [[NSMutableArray alloc]init];
            self.interactionJSON = responseObject;
            
            if (self.interactionJSON.count == 0) {
                
                [self.interactionTable reloadData];
                [self.pullRefreshView endRefreshing];
                
            } else {
                
                //Fill Post Cells
                for (int i = 0; i < self.interactionJSON.count; i++)
                {
                    
                    self.interProfID = [[[self.interactionJSON objectAtIndex:i] objectForKey:@"inter_prof_id"] integerValue];
                    self.interProfUser = [[self.interactionJSON objectAtIndex:i] objectForKey:@"inter_prof_user"];
                    self.interProfName = [[self.interactionJSON objectAtIndex:i] objectForKey:@"inter_prof_name"];
                    self.interProfPic = [[self.interactionJSON objectAtIndex:i] objectForKey:@"inter_prof_pic"];
                    self.interProfFollowFlag = [[[self.interactionJSON objectAtIndex:i] objectForKey:@"inter_prof_fol_flag"] boolValue];
                    
                    DataManager * myInteraction = [[DataManager alloc]initWithInteractionProfileID:self.interProfID andInteractionProfileUser:self.interProfUser andInteractionProfileName:self.interProfName andInteractionProfilePic:self.interProfPic
                                                                   andInteractionProfileFollowFlag:self.interProfFollowFlag];
                    
                    NSLog(@"%@", [self.interactionJSON objectAtIndex:i]);
                    
                    [self.interactionArray addObject:myInteraction];
                }
                
            }
            
        }
        
        [UIView transitionWithView: self.interactionTable
                          duration: 0.35f
                           options: UIViewAnimationOptionTransitionCrossDissolve
         //options: UIViewAnimationOptionTransitionNone
         //options: UIViewAnimationOptionTransitionFlipFromLeft
         //options: UIViewAnimationOptionTransitionFlipFromRight
         //options: UIViewAnimationOptionTransitionFlipFromBottom
         //options: UIViewAnimationOptionTransitionFlipFromTop
         //options: UIViewAnimationOptionTransitionCurlUp
         //options: UIViewAnimationOptionTransitionCurlDown
                        animations: ^(void)
         {
            
            NSLog(@"Post Array Count: %li", self.interactionArray.count);
            
            if (self.interactionArray.count != 0) {
                
                [self.interactionTable reloadData];
                [self.pullRefreshView endRefreshing];
                
                if (self.viewLoadingAI.animating) {
                    
                    [self loadingOverlay:nil overlayFlag:NO];
                    
                }
                
            } else {
                
                NSLog(@"No Posts");
                
                [self.interactionTable reloadData];
                
                if (self.viewLoadingAI.animating) {
                    
                    [self loadingOverlay:nil overlayFlag:NO];
                    
                }
            }
            
        }
         
         
         
         
                        completion: nil];
        
    }];
    
    [uploadTask resume];
    
}

- (IBAction)usernameClicked:(UIButton *)sender {
    
    if (![sender isKindOfClass:[UIButton class]]) return;
    UIView *finder = sender.superview;
    while ((![finder isKindOfClass:[UITableViewCell class]]) && finder != nil) {
        finder = finder.superview;
    }
    if (finder == nil) return;
    UITableViewCell *myCell = (UITableViewCell *)finder;
    NSIndexPath *indexPath = [interactionTable indexPathForCell:myCell];
    
    DataManager *myInteraction;
    myInteraction = [interactionArray objectAtIndex:indexPath.row];
    segueInterProfID = myInteraction.interactionProfileID; //FIX
    
    [self performSegueWithIdentifier:@"Inter_to_Prof" sender:self];
    
}

#pragma mark - Segue Setup
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"Inter_to_Prof"]) {
        
        Profile *pf = (Profile*)segue.destinationViewController;
        pf.profileID = segueInterProfID;
        
    }
    
}

- (void)followSetup:(BOOL)followFlag dataManager:(DataManager *)data tableViewCell:(UITableViewCell *)cell viewController:(UIViewController *)vc {
    
}

@end
