//
//  InteractionCell.h
//  Post.e
//
//  Created by Scott Grivner on 1/23/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InteractionCell : UITableViewCell

//Objects
@property (strong, nonatomic) IBOutlet UIImageView *interProfPicImgVw;
@property (strong, nonatomic) IBOutlet UIButton *interProfUserBtn;
@property (strong, nonatomic) IBOutlet UILabel *interProfNameLbl;
@property (strong, nonatomic) IBOutlet UIButton *interProfFollowBtn;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *interProfLoadingAI;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *interFolLoadingAI;

@end

NS_ASSUME_NONNULL_END
