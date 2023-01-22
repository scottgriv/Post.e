//
//  Profile.h
//  Post.e
//
//  Created by Scott Grivner on 10/3/21.
//

#import <UIKit/UIKit.h>
#import "Post_e-Swift.h"
#import "UIImageView+AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import "FollowManager.h"
#import "LoveManager.h"
#import "PinManager.h"
#import "ProfileCell.h"
#import "FilterCell.h"
#import "PostCell.h"
#import "LoadMoreCell.h"
#import "Interaction.h"
#import "Reply.h"

NS_ASSUME_NONNULL_BEGIN

@interface Profile : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, FollowManagerDelegate, LoveManagerDelegate, PinManagerDelegate>

//Objects
@property (strong, nonatomic) IBOutlet UIView *profileView;
@property (strong, nonatomic) IBOutlet UITableView * profileTable; //Profile Table
@property (strong, nonatomic) IBOutlet UIView * noPostsView; //No Posts View
@property (strong, nonatomic) IBOutlet UILabel * noPostsTitle; //No Posts Title
@property (strong, nonatomic) IBOutlet UILabel * noPostsSubtitle; //No Posts Subtitle
@property (strong, nonatomic) IBOutlet UIView * loadingView; //Loading View
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * viewLoadingAI; //View Loading Activity Indicator
@property (strong, nonatomic) IBOutlet UIRefreshControl * pullRefreshView;       //Pull Refresh
@property (strong, nonatomic) IBOutlet UIButton *postBtn;
@property (strong, nonatomic) IBOutlet UIButton *settingsBtn;
@property (strong, nonatomic) IBOutlet UIView *cellView; //Cell View
@property (nonatomic, strong) AVAudioPlayer *audioPlayer; // Player

//Variables
@property (nonatomic, strong) NSMutableArray * postHeaderJSON; //Post Header JSON Array
@property (nonatomic, strong) NSMutableArray * postJSON; //Post JSON Array
@property (nonatomic, strong) NSMutableArray * postAttachmentJSON; //Post Attachment JSON Array
@property (nonatomic, strong) NSMutableArray * postArray; //Post Array
@property (nonatomic, strong) NSMutableArray * postHeaderArray; //Post Header Array
@property (nonatomic, strong) NSMutableArray * postAttachmentArray; //Post Attachment Array
@property (nonatomic, strong) NSMutableArray * postAttachmentPushArray; //Post Attachment Array
@property (nonatomic, assign) NSInteger postArrayLimit; //Post Array Limit
@property (nonatomic, assign) NSInteger postArrayOffset; //Post Array Offset
@property (nonatomic, assign) BOOL refreshTable;
@property (nonatomic, assign) BOOL noPostsFlag;
@property (nonatomic, assign) BOOL endOfLoadingRefreshing; //Refreshing Flag
@property (readwrite, assign) NSInteger selectedSegment;
@property (nonatomic, strong) NSString * postCommand;
@property (nonatomic, strong) NSDictionary * postDictionary;
@property (readwrite, assign) NSInteger profileID;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * interactionType;
@property (readwrite, assign) NSInteger postingID;
@property (nonatomic, assign) BOOL filterApplied;

//Post Variables
@property (readwrite, assign) NSInteger postID;
@property (nonatomic, strong) NSString * postKey;
@property (nonatomic, assign) BOOL postType;
@property (readwrite, assign) NSInteger postProfileID;
@property (nonatomic, strong) NSString * postProfileUser;
@property (nonatomic, strong) NSString * postProfilePic;
@property (nonatomic, strong) NSString * postPost;
@property (nonatomic, strong) NSString * postDateTime;
@property (readwrite, assign) NSInteger postAttachmentCount;
@property (readwrite, assign) NSInteger postPinCount;
@property (readwrite, assign) NSInteger postReplyCount;
@property (readwrite, assign) NSInteger postLoveCount;
@property (nonatomic, assign) BOOL postPinFlag;
@property (nonatomic, assign) BOOL postReplyFlag;
@property (nonatomic, assign) BOOL postLoveFlag;
@property (readwrite, assign) NSInteger postProfileIDRef;

//Profile Variables
@property (readwrite, assign) NSInteger profID;
@property (nonatomic, strong) NSString * profKey;
@property (nonatomic, strong) NSString * profUser;
@property (nonatomic, strong) NSString * profName;
@property (nonatomic, strong) NSString * profPic;
@property (readwrite, assign) NSInteger profFollowerCount;
@property (readwrite, assign) NSInteger profFollowingCount;
@property (readwrite, assign) NSInteger profPostCount;
@property (nonatomic, assign) BOOL profFollowFlag;

//Attachment Variables
@property (readwrite, assign) NSInteger attachmentID;
@property (nonatomic, strong) NSString * attachmentKey;
@property (readwrite, assign) NSInteger attachmentPostID;
@property (nonatomic, strong) NSString * attachmentFileName;
@property (nonatomic, strong) NSString * attachmentFileExtension;
@property (nonatomic, strong) NSString * attachmentFileSize;
@property (nonatomic, strong) NSString * attachmentFilePath;
@property (nonatomic, strong) NSString * attachmentCreated;
@property (nonatomic, strong) NSString * attachmentModified;

//Protocols
@property (nonatomic, strong) FollowManager * followManager;
@property (nonatomic, strong) LoveManager * loveManager;
@property (nonatomic, strong) PinManager * pinManager;

//Methods
-(NSString *)dateDiff:(NSString *)origDate;
-(void)setupTableViewHeader;
-(void)scrollToTop;

@end

NS_ASSUME_NONNULL_END
