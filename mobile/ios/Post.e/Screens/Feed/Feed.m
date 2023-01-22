//
//  Feed.m
//  Post.e
//
//  Created by Scott Grivner on 10/3/21.
//

#import "Feed.h"

@interface Feed ()

@end

static NSString *nibIdentifier2 = @"PostCell";
static NSString *nibIdentifier3 = @"LoadMoreCell";
static NSString *nibIdentifier4 = @"UnavailableCell";

@implementation Feed

@synthesize pinManager, pinManagerDelegate;

@synthesize postID, postKey, postType, postProfileID, postProfileUser, postProfilePic, postPost, postDateTime, postAttachmentCount, postPinCount, postReplyCount, postLoveCount, postPinFlag, postReplyFlag, postLoveFlag, postProfileIDRef;

@synthesize profID, profKey, profUser, profName, profPic, profFollowerCount, profFollowingCount, profPostCount, profFollowFlag;

@synthesize attachmentID, attachmentKey, attachmentPostID, attachmentFileName, attachmentFileExtension, attachmentFileSize, attachmentFilePath, attachmentCreated, attachmentModified;

@synthesize feedView, feedTable, postJSON, postHeaderArray, postArray, postAttachmentArray, selectedSegment, postCommand, pullRefreshView, noPostsView, noPostsTitle, noPostsSubtitle, postArrayLimit, postArrayOffset, loadingView, viewLoadingAI, refreshTable, noPostsFlag, endOfLoadingRefreshing, postDictionary, profileID, postHeaderJSON, postAttachmentJSON, token, postBtn, loveManager, cellView, interactionType, postAttachmentPushArray, postingID, feedBtn, newUserFlag, filterApplied;


- (IBAction)Unwind_to_Feed_Submit:(UIStoryboardSegue *)unwindSegue
{
    
    NSLog(@"Unwind to Feed Submit!");
    
    [self resetArrays];
    [self setArray];
    
}

- (IBAction)Unwind_to_Feed_Cancel:(UIStoryboardSegue *)unwindSegue
{
    
    NSLog(@"Unwind to Feed Cancel!");
    
}

//Date Time Format
-(NSString *)dateDiff:(NSString *)origDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *convertedDate = [df dateFromString:origDate];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    //Within a minute
    if (ti < 60) {
        return @"Just Posted!";
        //Minutes
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%dm", diff];
        //Hours
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%dh", diff];
        //Days
    } else if (ti < 604800) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%dd", diff];
        //Weeks
    } else if (ti < 315569434) {
        int diff = round(ti / 60 / 60 / 24 / 7);
        return[NSString stringWithFormat:@"%dw", diff];
        //Beyond a decade
    } else {
        return @"N/A";
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    if (@available(iOS 15.0, *)) {
        [self.feedTable setSectionHeaderTopPadding:0.0f];
    }
    
    postBtn.layer.cornerRadius = CGRectGetWidth(postBtn.frame) / 2.0f;
    [postBtn.layer setMasksToBounds:YES];
    
    //Load Session Token from Keychain
    token = [SSKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier] account:@"token"];
    
    if (profileID == 0) {
        
        profileID = [token intValue];
        
    }
    
    loveManager = [[LoveManager alloc] init];
    pinManager = [[PinManager alloc] init];
    
    NSLog(@"Profile ID: %li, Token: %@", (long)profileID, token);
    
    UINib *nib2 = [UINib nibWithNibName:@"PostCell" bundle:nil];
    [[self feedTable] registerNib:nib2 forCellReuseIdentifier:@"PostCell"];
    
    UINib *nib3 = [UINib nibWithNibName:@"LoadMoreCell" bundle:nil];
    [[self feedTable] registerNib:nib3 forCellReuseIdentifier:@"LoadMoreCell"];
    
    UINib *nib4 = [UINib nibWithNibName:@"UnavailableCell" bundle:nil];
    [[self feedTable] registerNib:nib4 forCellReuseIdentifier:@"UnavailableCell"];
    
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
        
        //is Dark Mode
        self.feedView.backgroundColor = [UIColor blackColor];
        [self loadingOverlay:[UIColor blackColor] overlayFlag:YES];
        [self.feedTable setSeparatorColor:[UIColor whiteColor]];
        
    } else {
        
        //is Light Mode
        self.feedView.backgroundColor = [UIColor whiteColor];
        [self loadingOverlay:[UIColor whiteColor] overlayFlag:YES];
        [self.feedTable setSeparatorColor:[UIColor blackColor]];
        
    }
    
    [self addPullToRefresh];
    
}

-(void)setArray {
    
    //Retrieve First 25 Rows
    postArrayLimit = 25;
    postArrayOffset = 0;
    
    postArray = [[NSMutableArray alloc]init];
    postAttachmentArray = [[NSMutableArray alloc]init];
    postAttachmentPushArray = [[NSMutableArray alloc]init];
    
    postCommand = @"FeedHome";
    self.homeFlag = YES;
    
    [self retrievePosts];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"viewWillAppear!");
    [super viewWillAppear:animated];
    
    if (self.postArray == nil || self.postArray.count == 0) {
        
        [self setArray];
        
    }
    
    if (refreshTable == YES) {
        //Reload table view based on previous load amount
        if (postArray.count == 0) {
            postArrayLimit = 25;
        } else {
            postArrayLimit = [postArray count];
        }
        
        [postArray removeAllObjects];
        [postAttachmentArray removeAllObjects];
        [postAttachmentPushArray removeAllObjects];
        
        postArrayOffset = 0;
        refreshTable = NO;
        
        [self retrievePosts];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataManager * myPost = [postArray objectAtIndex:indexPath.row];
    
    if (myPost.postsProfileID == [token intValue] && !myPost.postsPinFlag) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to Delete this Post?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"User clicked button called %@ or tapped elsewhere",action.title);
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Yes, Remove this Post" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSLog(@"User clicked button called %@",action.title);
            
            [self deletePost:indexPath];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
    }
}

- (void)scrollToTop
{
    
    [self.feedTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

//Height for Header in Section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        NSLog(@"Section 1 Height: section %li", (long)section);
        
        return 31.0;
    }
    
    NSLog(@"Default Height: section %li", (long)section);
    return 0.0;
}

-(void)setupTableViewFooter:(BOOL)endOfTable {
    
    LoadMoreCell *footerCell = [self.feedTable dequeueReusableCellWithIdentifier:nibIdentifier3];
    
    [self.feedTable setContentInset:(UIEdgeInsetsMake(0, 0, 50, 0))];
    
    footerCell.endPic.hidden = YES;
    footerCell.loadMoreAI.hidesWhenStopped = YES;
    [footerCell.loadMoreAI startAnimating];
    endOfLoadingRefreshing = YES;
    
    if (endOfTable) {
        endOfLoadingRefreshing = NO;
        [footerCell.loadMoreAI stopAnimating];
        footerCell.endPic.hidden = NO;
    }
    
    if (noPostsFlag == YES) {
        endOfLoadingRefreshing = NO;
        [footerCell.loadMoreAI stopAnimating];
        footerCell.endPic.hidden = YES;
    }
    
    NSLog(@"BEFORE DELETE: endOfLoadingPic.x: %f, endOfLoadingPic.y: %f, loadMoreView.x: %f, loadMoreView.y: %f", footerCell.endPic.frame.origin.x, footerCell.endPic.frame.origin.y, footerCell.frame.origin.x, footerCell.frame.origin.y);
    
    NSLog(@"BEFORE DELETE: feedTable.height: %f, feedTable.width: %f, feedTable.x: %f, feedTable.y: %f", feedTable.frame.size.height, feedTable.frame.size.width, feedTable.frame.origin.x, feedTable.frame.origin.y);
    
    self.feedTable.tableFooterView = footerCell;
    
}

- (IBAction)feedBtnClicked:(id)sender {
    
    self.filterApplied = YES;
    
    if (self.homeFlag) {
        
        [self.feedBtn setBackgroundImage:[UIImage imageNamed:@"Feed_Home.png"] forState:UIControlStateNormal];
        
        postCommand = @"FeedLatest";
        self.homeFlag = NO;
        
    } else {
        
        [self.feedBtn setBackgroundImage:[UIImage imageNamed:@"Feed_Latest.png"] forState:UIControlStateNormal];
        postCommand = @"FeedHome";
        self.homeFlag = YES;
        
    }
    
    [self resetArrays];
    [self retrievePosts];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

#pragma mark - Amount of Cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"Post Array Count: %lu", (unsigned long)[self.postArray count]);
    
    if (section == 0 && postArray.count >= 1) {
        return [self.postArray count];
    } else {
        return 0;
    }
    
}

//Height for Row at Index
#pragma mark - Size of Cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        return 250;
        
    }
    
    return 0.0;
    
}

#pragma mark - Retrieve Cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"section: %ld, row: %ld", (long)indexPath.section, (long)indexPath.row);
    
    DataManager * myPost = [postArray objectAtIndex:indexPath.row];
    
    //If Section 1
    if (indexPath.section == 0) {
        
#pragma mark Post Base Cell
        
        //Call Cell
        PostCell *postCell = [tableView dequeueReusableCellWithIdentifier:nibIdentifier2 forIndexPath:indexPath];
        if (postCell == nil) {
            postCell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nibIdentifier2];
        }
        
        //Setup Cell
        postCell.accessoryType = UITableViewCellAccessoryNone;
        postCell.selectionStyle = UITableViewCellSelectionStyleNone;
        postCell.layer.borderColor = [UIColor blackColor].CGColor;
        postCell.layer.borderWidth = 0.2;
        
        NSLog(@"Profile ID Cell Ref: %li", myPost.postsProfileIDRef);
        
        //Post ID Label
        postCell.postIDLbl.text = [NSString stringWithFormat:@"%li", (long)myPost.postsID];
        NSString *buildConfiguration = [[NSProcessInfo processInfo] environment][@"BUILD_CONFIGURATION"];
        
        if ([buildConfiguration isEqualToString:@"TEST"]) {
            postCell.postIDLbl.hidden = NO;
        } else {
            postCell.postIDLbl.hidden = YES;
        }
        
        postCell.postLoadingAI.hidden = NO;
        [postCell.postLoadingAI startAnimating];
        
        postCell.postProfPicImgVw.contentMode = UIViewContentModeScaleAspectFill;
        
        //Post Pic Setup
        if (myPost.postsProfilePic == nil || [myPost.postsProfilePic isEqual:[NSNull null]]) {
            
            postCell.postProfPicImgVw.layer.cornerRadius = CGRectGetWidth(postCell.postProfPicImgVw.frame) / 2.0f;
            postCell.postProfPicImgVw.image = [UIImage imageNamed:@"Default_Prof.png"];
            [postCell.postProfPicImgVw.layer setMasksToBounds:YES];
            
            postCell.postLoadingAI.hidden = YES;
            [postCell.postLoadingAI stopAnimating];
            
        } else {
            
            __weak UIImageView *weakImageView = postCell.postProfPicImgVw;
            __weak UITableViewCell *weakCell = postCell;
            
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:
                                          [NSURL URLWithString:myPost.postsProfilePic] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
            [postCell.postProfPicImgVw setImageWithURLRequest:imageRequest
                                             placeholderImage:[UIImage imageNamed:@"Default_Prof.png"]
                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                weakImageView.image = image;
                weakImageView.layer.cornerRadius = CGRectGetWidth(weakImageView.frame) / 2.0f;
                [weakImageView.layer setMasksToBounds:YES];
                [weakCell setNeedsLayout];
            }
                                                      failure:nil];
            
            postCell.postLoadingAI.hidden = YES;
            [postCell.postLoadingAI stopAnimating];
            
        }
        
        //Set Post User Name
        [postCell.postProfUserBtn setTitle:myPost.postsProfileUser forState:UIControlStateNormal];
        [postCell.postProfUserBtn addTarget:self action:@selector(usernameClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //Date Time Setup
        postCell.postDateTimeLbl.text = [self dateDiff:myPost.postsDateTime];
        
        //Post Setup
        postCell.postTxtVw.text = myPost.postsPost;
        postCell.postTxtVw.userInteractionEnabled = NO;
        
        //Set Action for Attachment Button Clicked
        [postCell.postAttachmentBtn addTarget:self action:@selector(attachmentClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //Attachment Count Button Setup
        if (myPost.postsAttachmentCount == 0) {
            [postCell.postAttachmentBtn setBackgroundImage:[UIImage imageNamed:@"Attachment-Unselected.png"] forState:UIControlStateNormal];
            postCell.postAttachmentCountBtn.hidden = YES;
            postCell.postAttachmentCountBtn.enabled = NO;
            postCell.postAttachmentBtn.enabled = NO;
            
        } else {
            [postCell.postAttachmentBtn setBackgroundImage:[UIImage imageNamed:@"Attachment-Selected.png"] forState:UIControlStateNormal];
            postCell.postAttachmentCountBtn.hidden = NO;
            postCell.postAttachmentCountBtn.enabled = YES;
            postCell.postAttachmentBtn.enabled = YES;
            [postCell.postAttachmentCountBtn setTitle: [NSString stringWithFormat:@"%ld", (long)myPost.postsAttachmentCount]forState: UIControlStateNormal];
        }
        
        //Set Action for Attachment Count Button Clicked
        [postCell.postAttachmentCountBtn addTarget:self action:@selector(attachmentClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"Pin Flag: %@", myPost.postsPinFlag ? @"YES" : @"NO");
        
        //Set Cell View
        cellView = postCell.postPinBtn.superview;
        while ((![cellView isKindOfClass:[PostCell class]]) && cellView != nil) {
            cellView = cellView.superview;
        }
        
        //Set Properties of Love Button
        [postCell.postPinBtn.layer setValue:cellView forKey:@"view"];
        [postCell.postPinBtn.layer setValue:feedTable forKey:@"table"];
        [postCell.postPinBtn.layer setValue:indexPath forKey:@"indexPath"];
        [postCell.postPinBtn.layer setValue:myPost forKey:@"data"];
        [postCell.postPinBtn.layer setValue:postArray forKey:@"array"];
        [postCell.postPinBtn.layer setValue:postCell.postPinCountBtn forKey:@"pinCount"];
        [postCell.postPinBtn.layer setValue:self forKey:@"vc"];
        
        //Set Action for Pin Button Clicked
        if (myPost.postsProfileID == [token intValue] && !myPost.postsPinFlag) {
            
            postCell.postPinCountBtn.enabled = NO;
            [postCell.postPinBtn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
            
            [postCell.postPinBtn setBackgroundImage:[UIImage imageNamed:@"Pin-Disabled.png"] forState:UIControlStateNormal];
            [postCell.postPinBtn setNeedsLayout];
            
        } else {
            
            //Pin Button Setup
            if (myPost.postsPinFlag){
                [postCell.postPinBtn setBackgroundImage:[UIImage imageNamed:@"Pin-Selected.png"] forState:UIControlStateNormal];
                [postCell.postPinBtn setNeedsLayout];
            } else {
                [postCell.postPinBtn setBackgroundImage:[UIImage imageNamed:@"Pin-Unselected.png"] forState:UIControlStateNormal];
                [postCell.postPinBtn setNeedsLayout];
            }
            
            postCell.postPinCountBtn.enabled = YES;
            [postCell.postPinBtn addTarget:self action:@selector(pinClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //Pin Count Button Setup
        if (myPost.postsPinCount == 0) {
            
            postCell.postPinCountBtn.hidden = YES;
            postCell.postPinCountBtn.enabled = NO;
            
        } else {
            
            postCell.postPinCountBtn.hidden = NO;
            postCell.postPinCountBtn.enabled = YES;
            [postCell.postPinCountBtn setTitle: [NSString stringWithFormat:@"%ld", (long)myPost.postsPinCount]forState: UIControlStateNormal];
            
        }
        
        //Set Action for Pin Count Button Clicked
        [postCell.postPinCountBtn addTarget:self action:@selector(pinCountClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [postCell.postPinCountBtn.layer setValue:@"PinCountList" forKey:@"interactionType"];
        
        
        //Reply Button Setup
        if (myPost.postsReplyFlag){
            [postCell.postReplyBtn setBackgroundImage:[UIImage imageNamed:@"Reply-Selected.png"] forState:UIControlStateNormal];
            [postCell.postReplyBtn setNeedsLayout];
        } else {
            [postCell.postReplyBtn setBackgroundImage:[UIImage imageNamed:@"Reply-Unselected.png"] forState:UIControlStateNormal];
            [postCell.postReplyBtn setNeedsLayout];
        }
        
        //Set Action for Reply Button Clicked
        [postCell.postReplyBtn addTarget:self action:@selector(replyClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //Reply Count Button Setup
        if (myPost.postsReplyCount == 0) {
            postCell.postReplyCountBtn.hidden = YES;
            postCell.postReplyCountBtn.enabled = NO;
        } else {
            postCell.postReplyCountBtn.hidden = NO;
            postCell.postReplyCountBtn.enabled = YES;
            [postCell.postReplyCountBtn setTitle: [NSString stringWithFormat:@"%ld", (long)myPost.postsReplyCount]forState: UIControlStateNormal];
        }
        
        //Set Action for Reply Count Button Clicked
        [postCell.postReplyCountBtn addTarget:self action:@selector(replyClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //[postCell.postReplyCountBtn.layer setValue:@"ReplyCountList" forKey:@"interactionType"];
        
        NSLog(@"Love Flag: %@", myPost.postsLoveFlag ? @"YES" : @"NO");
        
        //Love Button Setup
        if (myPost.postsLoveFlag){
            [postCell.postLoveBtn setBackgroundImage:[UIImage imageNamed:@"Love-Selected"] forState:UIControlStateNormal];
            [postCell.postLoveBtn setNeedsLayout];
            
        } else {
            [postCell.postLoveBtn setBackgroundImage:[UIImage imageNamed:@"Love-Unselected"] forState:UIControlStateNormal];
            [postCell.postLoveBtn setNeedsLayout];
            
        }
        
        //Set Cell View
        cellView = postCell.postLoveBtn.superview;
        while ((![cellView isKindOfClass:[PostCell class]]) && cellView != nil) {
            cellView = cellView.superview;
        }
        
        //Set Properties of Love Button
        [postCell.postLoveBtn.layer setValue:cellView forKey:@"view"];
        [postCell.postLoveBtn.layer setValue:feedTable forKey:@"table"];
        [postCell.postLoveBtn.layer setValue:indexPath forKey:@"indexPath"];
        [postCell.postLoveBtn.layer setValue:myPost forKey:@"data"];
        [postCell.postLoveBtn.layer setValue:postArray forKey:@"array"];
        [postCell.postLoveBtn.layer setValue:postCell.postLoveCountBtn forKey:@"loveCount"];
        
        //Set Action for Love Button Clicked
        [postCell.postLoveBtn addTarget:self action:@selector(loveClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //Love Count Button Setup
        if (myPost.postsLoveCount == 0) {
            postCell.postLoveCountBtn.hidden = YES;
            postCell.postLoveCountBtn.enabled = NO;
        } else {
            postCell.postLoveCountBtn.hidden = NO;
            postCell.postLoveCountBtn.enabled = YES;
            [postCell.postLoveCountBtn setTitle: [NSString stringWithFormat:@"%ld", (long)myPost.postsLoveCount]forState: UIControlStateNormal];
        }
        
        //Set Action for Love Count Button Clicked
        [postCell.postLoveCountBtn addTarget:self action:@selector(loveCountClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [postCell.postLoveCountBtn.layer setValue:@"LoveCountList" forKey:@"interactionType"];
        
        return postCell;
        
    }
    
    //}
    
    return nil;
}

//This will run everytime a cell is produced
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Index Path.Row = %lu", (long)indexPath.row);
    NSLog(@"Post JSON Array Count  = %lu", (unsigned long)self.postJSON.count);
    NSLog(@"Post Array Count  = %lu", (unsigned long)self.postArray.count);
    
    if ((indexPath.row == self.postArray.count - 1) && (self.postArray.count >= self.postJSON.count) && (self.postArray.count >= self.postArrayOffset + 25) && self.postJSON.count != 0) {
        
        NSLog(@"Load More");
        [self setupTableViewFooter:NO];
        
        self.postArrayOffset = [self.postArray count];
        self.postArrayLimit = 25;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self retrievePosts];
            [self setupTableViewFooter:YES];
            
        });
        
    } else if (indexPath.row == postArray.count - 1) {
        
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
            
            self.feedTable.hidden = YES;
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
        feedTable.hidden = NO;
        
    }
}

- (IBAction)newUserBtnClicked:(id)sender {
    
    newUserFlag = YES;
    [self performSegueWithIdentifier:@"Feed_to_Interaction" sender:self];
    
}

-(void)resetArrays {
    
    [postArray removeAllObjects];
    [postAttachmentArray removeAllObjects];
    [postAttachmentPushArray removeAllObjects];
    
}

-(void)addPullToRefresh {
    
    self.pullRefreshView = [[UIRefreshControl alloc] init];
    [self.pullRefreshView addTarget: self action: @selector(startRefreshing:) forControlEvents: UIControlEventValueChanged];
    [self.feedTable addSubview:self.pullRefreshView];
    
}

-(IBAction)startRefreshing:(UIRefreshControl *)sender {
    
    [postAttachmentArray removeAllObjects];
    [postAttachmentPushArray removeAllObjects];
    
    self.postArrayLimit = 25;
    self.postArrayOffset = 0;
    self.selectedSegment = 0;
    
    [self.feedBtn setBackgroundImage:[UIImage imageNamed:@"Feed_Latest.png"] forState:UIControlStateNormal];
    self.postCommand = @"FeedHome";
    self.homeFlag = YES;
    
    [self.pullRefreshView beginRefreshing];
    
    [self retrievePosts];
    
}

-(void)deletePost:(NSIndexPath*)indexPath {
    
    DataManager * myPost = [postArray objectAtIndex:indexPath.row];
    
    UIProgressView * progressView;
    
    NSMutableDictionary * parametersDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSString stringWithFormat:@"%li", myPost.postsID], @"post_ID",
                                                  @"removePost", @"command",
                                                  nil];
    
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer]
                                     multipartFormRequestWithMethod:@"POST"
                                     URLString:[[[Constants alloc] formatURL:PostURL] absoluteString]
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
            
            BOOL success = [[responseObject valueForKey:@"success"] boolValue];
            
            if (success == 1){
                
                [self.postArray removeObjectAtIndex:indexPath.row];
                
                ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                    style:ALAlertBannerStyleSuccess
                                                                 position:ALAlertBannerPositionUnderNavBar
                                                                    title:@"Successfully Deleted Post!"
                                                                 subtitle:nil];
                
                NSLog(@"%u", banner.state);
                
                [banner show];
                
            } else {
                
                NSString * errorMessage = [responseObject valueForKey:@"error_message"];
                
                ALAlertBanner *banner = [ALAlertBanner alertBannerForView:window
                                                                    style:ALAlertBannerStyleFailure
                                                                 position:ALAlertBannerPositionUnderNavBar
                                                                    title:errorMessage
                                                                 subtitle:nil];
                
                NSLog(@"%u", banner.state);
                
                [banner show];
            }
            
        }
        
    }];
    
    [uploadTask resume];
}

-(void)retrievePosts {
    
    UIProgressView * progressView;
    
    if (!viewLoadingAI.animating && !pullRefreshView.refreshing && !endOfLoadingRefreshing) {
        
        [self loadingOverlay:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.50] overlayFlag:YES];
        
    }
    
    NSDictionary* parametersDictionary;
    NSMutableArray *responseObject=[[NSMutableArray alloc] init];
    responseObject = [postDictionary valueForKey: @"post"];
    responseObject = [postDictionary valueForKey: @"header"];
    
    parametersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%li", (long)profileID], @"profile_ID",
                            [NSString stringWithFormat: @"%ld", (long)postArrayLimit], @"limit",
                            [NSString stringWithFormat: @"%ld", (long)postArrayOffset], @"offset",
                            postCommand, @"command",
                            nil];
    
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer]
                                     multipartFormRequestWithMethod:@"POST"
                                     URLString:[[[Constants alloc] formatURL:FeedURL] absoluteString]
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
            
            NSInteger success = [responseObject[@"success"] integerValue];
            NSString * error_msg;
            
            if (success == 9) {
                
                NSLog(@"Invalid Cookie");
                error_msg = (NSString *)responseObject[@"error_message"];
                
            } else {
                
                self.postJSON = [responseObject valueForKey: @"post"];
                
                if ([self.postJSON isEqual:[NSNull null]] || self.postJSON.count == 0) {
                    
                    NSLog(@"0 POST JSON COUNT");
                    
                    self.feedTable.scrollEnabled = NO;
                    self.noPostsFlag = YES;
                    [self noPostsView:YES];
                    
                } else {
                    
                    self.feedTable.scrollEnabled = YES;
                    self.noPostsFlag = NO;
                    [self noPostsView:NO];
                    
                    if (self.pullRefreshView.isRefreshing) {
                        
                        [self.postArray removeAllObjects];
                        
                    }
                    
                    //Fill Post Cells
                    for (int i = 0; i < self.postJSON.count; i++)
                    {
                        
                        self.postID = [[[self.postJSON objectAtIndex:i] objectForKey:@"post_ID"] integerValue];
                        self.postKey = [[self.postJSON objectAtIndex:i] objectForKey:@"post_key"];
                        self.postType = [[[self.postJSON objectAtIndex:i] objectForKey:@"post_type"] boolValue];
                        self.postProfileID = [[[self.postJSON objectAtIndex:i] objectForKey:@"post_prof_ID"] integerValue];
                        self.postProfileUser = [[self.postJSON objectAtIndex:i] objectForKey:@"post_prof_user"];
                        self.postProfilePic = [[self.postJSON objectAtIndex:i] objectForKey:@"post_prof_pic"];
                        self.postPost = [[self.postJSON objectAtIndex:i] objectForKey:@"post_post"];
                        self.postDateTime = [[self.postJSON objectAtIndex:i] objectForKey:@"post_created"];
                        self.postAttachmentCount = [[[self.postJSON objectAtIndex:i] objectForKey:@"post_attachment_count"] integerValue];
                        self.postPinCount = [[[self.postJSON objectAtIndex:i] objectForKey:@"post_pin_count"] integerValue];
                        self.postReplyCount = [[[self.postJSON objectAtIndex:i] objectForKey:@"post_reply_count"] integerValue];
                        self.postLoveCount = [[[self.postJSON objectAtIndex:i] objectForKey:@"post_love_count"] integerValue];
                        self.postPinFlag = [[[self.postJSON objectAtIndex:i] objectForKey:@"post_pin_flag"] boolValue];
                        self.postReplyFlag = [[[self.postJSON objectAtIndex:i] objectForKey:@"post_reply_flag"] boolValue];
                        self.postLoveFlag = [[[self.postJSON objectAtIndex:i] objectForKey:@"post_love_flag"] boolValue];
                        self.postProfileIDRef = [[[self.postJSON objectAtIndex:i] objectForKey:@"post_prof_ID_ref"] integerValue];
                        
                        DataManager * myPost = [[DataManager alloc]initWithPostsID:self.postID andPostsKey:self.postKey andPostsType:self.postType andPostsProfileID:self.postProfileID andPostsProfileUser:self.postProfileUser andPostsProfilePic:self.postProfilePic andPostsPost:self.postPost andPostsDateTime:self.postDateTime andPostsAttachmentCount:self.postAttachmentCount andPostsPinCount:self.postPinCount andPostsReplyCount:self.postReplyCount andPostsLoveCount:self.postLoveCount andPostsPinFlag:self.postPinFlag andPostsReplyFlag:self.postReplyFlag andPostsLoveFlag:self.postLoveFlag andPostsProfileIDRef:self.postProfileIDRef];
                        
                        NSLog(@"%@", [self.postJSON objectAtIndex:i]);
                        
                        [self.postArray addObject:myPost];
                    }
                    
                    for (int i3 = 0; i3 < self.postJSON.count; i3++)
                    {
                        
                        self.postAttachmentJSON = [[self.postJSON objectAtIndex:i3] objectForKey:@"post_attachment"];
                        
                        for (int i2 = 0; i2 < self.postAttachmentJSON.count; i2++)
                        {
                            
                            self.attachmentID = [[[self.postAttachmentJSON objectAtIndex:i2] objectForKey:@"attachment_ID"] integerValue];
                            self.attachmentKey = [[self.postAttachmentJSON objectAtIndex:i2] objectForKey:@"attachment_key"];
                            self.attachmentPostID = [[[self.postAttachmentJSON objectAtIndex:i2] objectForKey:@"attachment_post_ID"] integerValue];
                            self.attachmentFileName = [[self.postAttachmentJSON objectAtIndex:i2] objectForKey:@"attachment_file_name"];
                            self.attachmentFileExtension = [[self.postAttachmentJSON objectAtIndex:i2] objectForKey:@"attachment_file_extension"];
                            self.attachmentFileSize = [[self.postAttachmentJSON objectAtIndex:i2] objectForKey:@"attachment_file_size"];
                            self.attachmentFilePath = [[self.postAttachmentJSON objectAtIndex:i2] objectForKey:@"attachment_file_path"];
                            self.attachmentCreated = [[self.postAttachmentJSON objectAtIndex:i2] objectForKey:@"attachment_created"];
                            self.attachmentModified = [[self.postAttachmentJSON objectAtIndex:i2] objectForKey:@"attachment_modified"];
                            
                            DataManager * myAttachment = [[DataManager alloc]initWithAttachmentsID:self.attachmentID andAttachmentsKey:self.attachmentKey andAttachmentsPostID:self.attachmentPostID andAttachmentsFileName:self.attachmentFileName andAttachmentsFileExtension:self.attachmentFileExtension andAttachmentsFileSize:self.attachmentFileSize andAttachmentsFilePath:self.attachmentFilePath andAttachmentsCreated:self.attachmentCreated andAttachmentsModified:self.attachmentModified];
                            
                            [self.postAttachmentArray addObject:myAttachment];
                            
                            NSLog(@"%@", [self.postAttachmentJSON objectAtIndex:i2]);
                            
                        }
                        
                    }
                    
                }
                
                [UIView transitionWithView: self.feedTable
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
                    
                    NSLog(@"Post Array Count: %li", self.postArray.count);
                    
                    if (self.postArray.count != 0) {
                        
                        NSLog(@"No Posts");
                        
                        [self.feedTable reloadData];
                        [self.pullRefreshView endRefreshing];
                        
                        if (self.viewLoadingAI.animating) {
                            
                            
                            [self loadingOverlay:nil overlayFlag:NO];
                            
                        }
                        
                        if (self.filterApplied) {
                            
                            NSTimeInterval delayInSeconds = 0.2;
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                NSLog(@"Do some work");
                                [self scrollToTop];
                                self.filterApplied = NO;
                                
                                
                            });
                            
                        }
                        
                    } else {
                        
                        NSLog(@"No Posts");
                        
                        [self.feedTable reloadData];
                        [self.pullRefreshView endRefreshing];
                        
                        if (self.viewLoadingAI.animating) {
                            
                            [self loadingOverlay:nil overlayFlag:NO];
                            
                        }
                    }
                    
                }
                 
                                completion:nil]; /*^(BOOL finished) {
                                                  
                                                  NSLog(@"Task completed ..");
                                                  [self.feedTable reloadData];
                                                  [self.pullRefreshView endRefreshing];
                                                  
                                                  }];*/
                
            }
        }
        
    }];
    
    [uploadTask resume];
    
}

-(void)noPostsView:(BOOL)visible {
    
    if (visible) {
        
        noPostsView = [[[NSBundle mainBundle] loadNibNamed:@"NoPostsView" owner:self options:nil] firstObject];
        noPostsTitle = (UILabel*)[noPostsView viewWithTag:999];
        
        //X, Y, W , H
        noPostsView.frame = CGRectMake(0, -100, feedTable.frame.size.width, feedTable.frame.size.height); //22 Missing?
        
        [self toggleDarkMode];
        
        [noPostsTitle setCenter:self.view.center];
        [feedTable addSubview:noPostsView];
        
        noPostsTitle.text = @"No Posts Here!";
        
    } else {
        
        [noPostsView removeFromSuperview];
        
    }
    
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self toggleDarkMode];
}

-(void)toggleDarkMode {
    
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
        
        //is dark
        noPostsView.backgroundColor = [UIColor blackColor];
        self.feedView.backgroundColor = [UIColor blackColor];
        [self.feedTable setSeparatorColor:[UIColor whiteColor]];
        
    } else {
        
        //is light
        noPostsView.backgroundColor = [UIColor whiteColor];
        self.feedView.backgroundColor = [UIColor whiteColor];
        [self.feedTable setSeparatorColor:[UIColor blackColor]];
        
    }
    
}

- (IBAction)loveClicked:(UIButton *)sender {
    
    [loveManager loveClicked:sender];
    
}

- (IBAction)replyClicked:(UIButton *)sender {
    
    if (![sender isKindOfClass:[UIButton class]]) return;
    UIView *finder = sender.superview;
    while ((![finder isKindOfClass:[UITableViewCell class]]) && finder != nil) {
        finder = finder.superview;
    }
    if (finder == nil) return;
    UITableViewCell *myCell = (UITableViewCell *)finder;
    NSIndexPath *indexPath = [self.feedTable indexPathForCell:myCell];
    
    DataManager *myPost;
    myPost = [self.postArray objectAtIndex:indexPath.row];
    
    postingID = myPost.postsID;
    
    [self performSegueWithIdentifier:@"Feed_to_Reply" sender:self];
    
}

- (IBAction)pinClicked:(UIButton *)sender {
    
    if (![sender isKindOfClass:[UIButton class]]) return;
    UIView *finder = sender.superview;
    while ((![finder isKindOfClass:[UITableViewCell class]]) && finder != nil) {
        finder = finder.superview;
    }
    if (finder == nil) return;
    UITableViewCell *myCell = (UITableViewCell *)finder;
    NSIndexPath *indexPath = [self.feedTable indexPathForCell:myCell];
    
    DataManager *myPosts;
    myPosts = [self.postArray objectAtIndex:indexPath.row];
    
    if (myPosts.postsPinFlag) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to Unpin this Post?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"User clicked button called %@ or tapped elsewhere",action.title);
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Yes, Unpin this Post" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSLog(@"User clicked button called %@",action.title);
            
            [self.pinManager pinClicked:sender];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [pinManager pinClicked:sender];
        
    }
}

- (IBAction)attachmentClicked:(UIButton *)sender {
    
    if (![sender isKindOfClass:[UIButton class]]) return;
    UIView *finder = sender.superview;
    while ((![finder isKindOfClass:[UITableViewCell class]]) && finder != nil) {
        finder = finder.superview;
    }
    if (finder == nil) return;
    UITableViewCell *myCell = (UITableViewCell *)finder;
    NSIndexPath *indexPath = [self.feedTable indexPathForCell:myCell];
    
    DataManager *myPosts;
    myPosts = [self.postArray objectAtIndex:indexPath.row];
    
    for (int i4 = 0; i4 < self.postAttachmentArray.count; i4++)
    {
        DataManager * myAttachments = [self.postAttachmentArray objectAtIndex:i4];
        
        if (myAttachments.attachmentsPostID == myPosts.postsID) {
            
            [self.postAttachmentPushArray addObject:myAttachments];
            
            NSLog(@"%@", [self.postAttachmentArray objectAtIndex:i4]);
            
        }
    }
    
    [self performSegueWithIdentifier:@"Feed_to_Attachment" sender:self];
    
}

- (IBAction)usernameClicked:(UIButton *)button{
    
    if (![button isKindOfClass:[UIButton class]]) return;
    UIView *finder = button.superview;
    while ((![finder isKindOfClass:[UITableViewCell class]]) && finder != nil) {
        finder = finder.superview;
    }
    if (finder == nil) return;
    UITableViewCell *myCell = (UITableViewCell *)finder;
    NSIndexPath *indexPath = [feedTable indexPathForCell:myCell];
    
    DataManager *myPost;
    myPost = [postArray objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    Profile *pf = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
    
    pf.profileID = myPost.postsProfileID;
    
    [self.navigationController pushViewController:pf animated:YES];
    
}

- (IBAction)followersCountBtnClicked:(UIButton *)button{
    
    self.interactionType = [button.layer valueForKey:@"interactionType"];
    [self performSegueWithIdentifier:@"Feed_to_Interaction" sender:self];
    
}

- (IBAction)followingCountBtnClicked:(UIButton *)button{
    
    self.interactionType = [button.layer valueForKey:@"interactionType"];
    [self performSegueWithIdentifier:@"Feed_to_Interaction" sender:self];
    
}

- (IBAction)loveCountClicked:(UIButton *)button{
    
    if (![button isKindOfClass:[UIButton class]]) return;
    UIView *finder = button.superview;
    while ((![finder isKindOfClass:[UITableViewCell class]]) && finder != nil) {
        finder = finder.superview;
    }
    if (finder == nil) return;
    UITableViewCell *myCell = (UITableViewCell *)finder;
    NSIndexPath *indexPath = [feedTable indexPathForCell:myCell];
    
    DataManager *myPost;
    myPost = [postArray objectAtIndex:indexPath.row];
    
    self.postingID = myPost.postsID;
    self.interactionType = [button.layer valueForKey:@"interactionType"];
    [self performSegueWithIdentifier:@"Feed_to_Interaction" sender:self];
    
}

- (IBAction)pinCountClicked:(UIButton *)button{
    
    if (![button isKindOfClass:[UIButton class]]) return;
    UIView *finder = button.superview;
    while ((![finder isKindOfClass:[UITableViewCell class]]) && finder != nil) {
        finder = finder.superview;
    }
    if (finder == nil) return;
    UITableViewCell *myCell = (UITableViewCell *)finder;
    NSIndexPath *indexPath = [feedTable indexPathForCell:myCell];
    
    DataManager *myPost;
    myPost = [postArray objectAtIndex:indexPath.row];
    
    self.postingID = myPost.postsID;
    self.interactionType = [button.layer valueForKey:@"interactionType"];
    [self performSegueWithIdentifier:@"Feed_to_Interaction" sender:self];
    
}

- (IBAction)replyCountClicked:(UIButton *)button{
    
    if (![button isKindOfClass:[UIButton class]]) return;
    UIView *finder = button.superview;
    while ((![finder isKindOfClass:[UITableViewCell class]]) && finder != nil) {
        finder = finder.superview;
    }
    if (finder == nil) return;
    UITableViewCell *myCell = (UITableViewCell *)finder;
    NSIndexPath *indexPath = [feedTable indexPathForCell:myCell];
    
    DataManager *myPost;
    myPost = [postArray objectAtIndex:indexPath.row];
    
    self.postingID = myPost.postsID;
    self.interactionType = [button.layer valueForKey:@"interactionType"];
    [self performSegueWithIdentifier:@"Feed_to_Interaction" sender:self];
    
}

#pragma mark - Segue Setup
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"Feed_to_Post"]) {
        
        Post *ps = (Post*)segue.destinationViewController;
        ps.profileID = profileID;
        ps.previousVC = @"Feed";
        
    } else if ([segue.identifier isEqualToString:@"Feed_to_Attachment"]) {
        
        Attachment * attach = (Attachment*)segue.destinationViewController;
        attach.attachArray = self.postAttachmentPushArray;
        [self.postAttachmentPushArray removeAllObjects];
        
    } else if ([segue.identifier isEqualToString:@"Feed_to_Reply"]) {
        
        refreshTable = YES;
        
        Reply * reply = (Reply*)segue.destinationViewController;
        reply.replyPostID = postingID;
        
    } else if ([segue.identifier isEqualToString:@"Feed_to_Interaction"]) {
        
        Interaction * inter = (Interaction*)segue.destinationViewController;
        
        if (newUserFlag) {
            inter.interactionType = @"NewUserList";
            newUserFlag = NO;
        } else {
            inter.interactionType = interactionType;
        }
        
        inter.profileID = profileID;
        inter.postID = postingID;
        
    }
    
}

@end
