//
//  DataManager.h
//  Post.e
//
//  Created by Scott Grivner on 11/19/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

#pragma mark - Profile Variables
@property (readwrite, assign) NSInteger profileID;
@property (nonatomic, strong) NSString * profileKey;
@property (nonatomic, strong) NSString * profileUser;
@property (nonatomic, strong) NSString * profileName;
@property (nonatomic, strong) NSString * profilePic;
@property (readwrite, assign) NSInteger profileFollowerCount;
@property (readwrite, assign) NSInteger profileFollowingCount;
@property (readwrite, assign) NSInteger profilePostCount;
@property (nonatomic, assign) BOOL profileFollowFlag;

#pragma mark - Post Variables
@property (readwrite, assign) NSInteger postsID;
@property (nonatomic, strong) NSString * postsKey;
@property (nonatomic, assign) BOOL postsType;
@property (readwrite, assign) NSInteger postsProfileID;
@property (nonatomic, strong) NSString * postsProfileUser;
@property (nonatomic, strong) NSString * postsProfilePic;
@property (nonatomic, strong) NSString * postsPost;
@property (nonatomic, strong) NSString * postsDateTime;
@property (readwrite, assign) NSInteger postsAttachmentCount;
@property (readwrite, assign) NSInteger postsPinCount;
@property (readwrite, assign) NSInteger postsReplyCount;
@property (readwrite, assign) NSInteger postsLoveCount;
@property (nonatomic, assign) BOOL postsPinFlag;
@property (nonatomic, assign) BOOL postsReplyFlag;
@property (nonatomic, assign) BOOL postsLoveFlag;
@property (readwrite, assign) NSInteger postsProfileIDRef;

#pragma mark - Attachment Variables
@property (readwrite, assign) NSInteger attachmentsID;
@property (nonatomic, strong) NSString * attachmentsKey;
@property (readwrite, assign) NSInteger attachmentsPostID;
@property (nonatomic, strong) NSString * attachmentsFileName;
@property (nonatomic, strong) NSString * attachmentsFileExtension;
@property (nonatomic, strong) NSString * attachmentsFileSize;
@property (nonatomic, strong) NSString * attachmentsFilePath;
@property (nonatomic, strong) NSString * attachmentsCreated;
@property (nonatomic, strong) NSString * attachmentsModified;

#pragma mark - Interaction Variables
@property (readwrite, assign) NSInteger interactionProfileID;
@property (nonatomic, strong) NSString * interactionProfileUser;
@property (nonatomic, strong) NSString * interactionProfileName;
@property (nonatomic, strong) NSString * interactionProfilePic;
@property (nonatomic, assign) BOOL interactionProfileFollowFlag;

#pragma mark - Post Attachment Variables
@property (nonatomic, strong) NSString * postAttachmentType;
@property (nonatomic, strong) NSData * postAttachmentFile;
@property (nonatomic, strong) NSURL * postAttachmentFilePath;
@property (nonatomic, strong) NSString * postAttachmentFileName;
@property (nonatomic, strong) NSString * postAttachmentFileExtension;
@property (nonatomic, strong) NSString * postAttachmentFileSize;
@property (nonatomic, strong) NSString * postAttachmentCreationDate;
@property (nonatomic, strong) NSString * postAttachmentModificationDate;
@property (nonatomic, strong) UIImage * postAttachmentThumbnail;

#pragma mark - Profile Objects
- (id) initWithProfileID: (NSInteger) profID andProfileKey: (NSString *) profKey andProfileUser: (NSString *) profUser andProfileName: (NSString *) profName andProfilePic: (NSString *) profPic andProfileFollowerCount: (NSInteger) profFollowerCount andProfileFollowingCount: (NSInteger) profFollowingCount andProfilePostCount: (NSInteger) profPostCount andProfileFollowFlag: (BOOL) profFollowFlag;

#pragma mark - Post Objects
- (id) initWithPostsID: (NSInteger) postID andPostsKey: (NSString *) postKey andPostsType: (BOOL) postType andPostsProfileID: (NSInteger) postProfileID andPostsProfileUser: (NSString *) postProfileUser andPostsProfilePic: (NSString *) postProfilePic andPostsPost: (NSString *) postPost andPostsDateTime: (NSString *) postDateTime andPostsAttachmentCount: (NSInteger) postAttachmentCount andPostsPinCount: (NSInteger) postPinCount andPostsReplyCount: (NSInteger) postReplyCount andPostsLoveCount: (NSInteger) postLoveCount andPostsPinFlag: (BOOL) postPinFlag andPostsReplyFlag: (BOOL) postReplyFlag andPostsLoveFlag: (BOOL) postLoveFlag andPostsProfileIDRef: (NSInteger) postProfileIDRef;
   
#pragma mark - Attachment Objects
- (id) initWithAttachmentsID: (NSInteger) attachmentID andAttachmentsKey: (NSString *) attachmentKey andAttachmentsPostID: (NSInteger) attachmentPostID andAttachmentsFileName: (NSString *) attachmentFileName andAttachmentsFileExtension: (NSString *) attachmentFileExtension andAttachmentsFileSize: (NSString *) attachmentFileSize andAttachmentsFilePath: (NSString *) attachmentFilePath andAttachmentsCreated: (NSString *) attachmentCreated andAttachmentsModified: (NSString *) attachmentModified;

#pragma mark - Interaction Objects
- (id) initWithInteractionProfileID: (NSInteger) interProfID andInteractionProfileUser: (NSString *) interProfUser andInteractionProfileName: (NSString *) interProfName andInteractionProfilePic: (NSString *) interProfPic andInteractionProfileFollowFlag: (BOOL) interProfFollowFlag;

#pragma mark - Post Attachment Objects
- (id) initWithPostAttachmentType: (NSString*) postAttachType andPostAttachmentFile: (NSData*) postAttachFile andPostAttachmentFilePath: (NSURL*) postAttachFilePath andPostAttachmentFileName: (NSString *) postAttachFileName andPostAttachmentFileExtension: (NSString *) postAttachFileExtension andPostAttachmentFileSize: (NSString *) postAttachFileSize andPostAttachmentCreationDate: (NSString *) postAttachCreationDate andPostAttachmentModificationDate: (NSString *) postAttachModificationDate andPostAttachmentThumbnail: (UIImage *) postAttachThumbnail;

@end

NS_ASSUME_NONNULL_END
