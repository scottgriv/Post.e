//
//  Constants.h
//  Post.e
//
//  Created by Scott Grivner on 10/3/21.
//

//Include Frameworks
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//External Variables
extern NSString * const baseURL;             //base folder
extern NSString * const LoginURL;            //login
extern NSString * const ProfileURL;          //profile
extern NSString * const FeedURL;             //feed
extern NSString * const PostURL;             //post
extern NSString * const InteractionURL;      //interaction

@interface Constants : NSObject

//Variables
@property (nonatomic, strong) NSString * baseExtension;
@property (nonatomic, strong) NSURL * formattedURL;

//Methods
- (NSURL *)formatURL:(NSString *)passedURL;
+ (UIColor *) lightGray;
+ (UIColor *) darkGray;

@end

NS_ASSUME_NONNULL_END
