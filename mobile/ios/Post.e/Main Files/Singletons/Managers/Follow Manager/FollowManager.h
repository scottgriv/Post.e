//
//  FollowManager.h
//  Post.e
//
//  Created by Scott Grivner on 1/12/22.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

//Class
@class FollowManager;

//Protocol
@protocol FollowManagerDelegate <NSObject>

@property (nonatomic, strong) FollowManager * followManagerDelegate;

- (void)followSetup:(BOOL)followFlag dataManager:(DataManager *)data tableViewCell:(UITableViewCell *)cell viewController:(UIViewController *)vc;

@end

@interface FollowManager : NSObject <FollowManagerDelegate, UIActionSheetDelegate>

//Variables
@property (nonatomic, strong) NSString * unfollowMessage;
@property (nonatomic, assign) BOOL followFlagCheck;
@property (nonatomic, strong) NSMutableDictionary * parametersDictionary;

@end
