//
//  LoadMoreCell.h
//  Post.e
//
//  Created by Scott Grivner on 12/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadMoreCell : UITableViewCell

//Objects
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * loadMoreAI; //Load More AI
@property (weak, nonatomic) IBOutlet UIImageView * endPic; //End of Loading Picture

@end

NS_ASSUME_NONNULL_END
