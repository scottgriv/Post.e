//
//  PostCell.h
//  Post.e
//
//  Created by Scott Grivner on 11/22/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

//Objects
@property (strong, nonatomic) IBOutlet UIImageView *postProfPicImgVw;
@property (strong, nonatomic) IBOutlet UIButton *postProfUserBtn;
@property (strong, nonatomic) IBOutlet UILabel *postDateTimeLbl;
@property (strong, nonatomic) IBOutlet UITextView *postTxtVw;
@property (strong, nonatomic) IBOutlet UIButton *postAttachmentBtn;
@property (strong, nonatomic) IBOutlet UIButton *postAttachmentCountBtn;
@property (strong, nonatomic) IBOutlet UIButton *postPinBtn;
@property (strong, nonatomic) IBOutlet UIButton *postPinCountBtn;
@property (strong, nonatomic) IBOutlet UIButton *postReplyBtn;
@property (strong, nonatomic) IBOutlet UIButton *postReplyCountBtn;
@property (strong, nonatomic) IBOutlet UIButton *postLoveBtn;
@property (strong, nonatomic) IBOutlet UIButton *postLoveCountBtn;
@property (strong, nonatomic) IBOutlet UILabel *postIDLbl;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *postLoadingAI;

@end

NS_ASSUME_NONNULL_END
