//
//  ProfileCell.h
//  Post.e
//
//  Created by Scott Grivner on 12/18/17.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell

//Objects
@property (strong, nonatomic) IBOutlet UIImageView *profPicImgVw;
@property (strong, nonatomic) IBOutlet UIButton *profFollowBtn;
@property (strong, nonatomic) IBOutlet UILabel *profUserLbl;
@property (strong, nonatomic) IBOutlet UILabel *profNameLbl;
@property (strong, nonatomic) IBOutlet UIButton *profFollowerBtn;
@property (strong, nonatomic) IBOutlet UILabel *profFollowerLbl;
@property (strong, nonatomic) IBOutlet UIButton *profPostBtn;
@property (strong, nonatomic) IBOutlet UILabel *profPostLbl;
@property (strong, nonatomic) IBOutlet UIButton *profFollowingBtn;
@property (strong, nonatomic) IBOutlet UILabel *profFollowingLbl;
@property (strong, nonatomic) IBOutlet UILabel *profIDLbl;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *profLoadingAI;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *profFolLoadingAI;

@end
