//
//  Interaction.h
//  Post.e
//
//  Created by Scott Grivner on 1/21/22.
//

#import <UIKit/UIKit.h>

#import "FollowManager.h"
#import "LoadMoreCell.h"
#import "InteractionCell.h"
#import "Profile.h"
#import "Feed.h"

NS_ASSUME_NONNULL_BEGIN

@interface Interaction : UIViewController <UITableViewDelegate, UITableViewDataSource, FollowManagerDelegate>

//Objects
@property (strong, nonatomic) IBOutlet UITableView *interactionTable; //Interaction Table
@property (strong, nonatomic) IBOutlet UIRefreshControl * pullRefreshView;       //Pull Refresh
@property (strong, nonatomic) IBOutlet UIView * loadingView; //Loading View
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * viewLoadingAI; //View Loading

//Variables
@property (nonatomic, strong) NSString * token; //Token
@property (nonatomic, strong) NSString * interactionType; //Interaction Type
@property (readwrite, assign) NSInteger profileID; //Profile ID
@property (readwrite, assign) NSInteger postID; //Post ID
@property (nonatomic, assign) NSInteger interactionArrayLimit; //Post Array Limit
@property (nonatomic, assign) NSInteger interactionArrayOffset; //Post Array Offset
@property (nonatomic, assign) NSInteger segueInterProfID; //Post Array Offset
@property (nonatomic, assign) BOOL endOfLoadingRefreshing; //Refreshing Flag
@property (nonatomic, assign) BOOL noInteractionsFlag; //No Interaction Flag
@property (nonatomic, strong) NSMutableArray * interactionArray; //Post Header JSON Array
@property (nonatomic, strong) NSMutableArray * interactionJSON; //Post Header JSON Array
@property (nonatomic, strong) NSString * postCommand; //Post Command

//Interation Variables
@property (readwrite, assign) NSInteger interProfID;
@property (nonatomic, strong) NSString * interProfUser;
@property (nonatomic, strong) NSString * interProfName;
@property (nonatomic, strong) NSString * interProfPic;
@property (nonatomic, assign) BOOL interProfFollowFlag;

//Protocols
@property (nonatomic, strong) FollowManager * followManager;

@end

NS_ASSUME_NONNULL_END
