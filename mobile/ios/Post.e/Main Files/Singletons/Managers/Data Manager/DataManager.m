//
//  DataManager.m
//  Post.e
//
//  Created by Scott Grivner on 11/19/21.
//

#import "DataManager.h"

@implementation DataManager

@synthesize profileID, profileKey, profileUser, profileName, profilePic, profileFollowerCount, profileFollowingCount, profilePostCount, profileFollowFlag;

@synthesize postsID, postsKey, postsType, postsProfileID, postsProfileUser, postsProfilePic, postsPost, postsDateTime, postsAttachmentCount, postsPinCount, postsReplyCount, postsLoveCount, postsPinFlag, postsReplyFlag, postsLoveFlag, postsProfileIDRef;

@synthesize attachmentsID, attachmentsKey, attachmentsPostID, attachmentsFileName, attachmentsFileExtension, attachmentsFileSize, attachmentsFilePath, attachmentsCreated, attachmentsModified;

@synthesize interactionProfileID, interactionProfileUser, interactionProfileName, interactionProfilePic, interactionProfileFollowFlag;

@synthesize postAttachmentType, postAttachmentFile, postAttachmentFilePath, postAttachmentFileName, postAttachmentFileExtension, postAttachmentFileSize, postAttachmentCreationDate, postAttachmentModificationDate, postAttachmentThumbnail;

#pragma mark - Profile Objects
- (id) initWithProfileID: (NSInteger) profID andProfileKey: (NSString *) profKey andProfileUser: (NSString *) profUser andProfileName: (NSString *) profName andProfilePic: (NSString *) profPic andProfileFollowerCount: (NSInteger) profFollowerCount andProfileFollowingCount: (NSInteger) profFollowingCount andProfilePostCount: (NSInteger) profPostCount andProfileFollowFlag: (BOOL) profFollowFlag;

{
    self = [super init];
    if (self)
    {
        profileID = profID;
        profileKey = profKey;
        profileUser = profUser;
        profileName = profName;
        profilePic = profPic;
        profileFollowerCount = profFollowerCount;
        profileFollowingCount = profFollowingCount;
        profilePostCount = profPostCount;
        profileFollowFlag = profFollowFlag;
        
    }
    
    return self;
}

#pragma mark - Post Objects
- (id) initWithPostsID: (NSInteger) postID andPostsKey: (NSString *) postKey andPostsType: (BOOL) postType andPostsProfileID: (NSInteger) postProfileID andPostsProfileUser: (NSString *) postProfileUser andPostsProfilePic: (NSString *) postProfilePic andPostsPost: (NSString *) postPost andPostsDateTime: (NSString *) postDateTime andPostsAttachmentCount: (NSInteger) postAttachmentCount andPostsPinCount: (NSInteger) postPinCount andPostsReplyCount: (NSInteger) postReplyCount andPostsLoveCount: (NSInteger) postLoveCount andPostsPinFlag: (BOOL) postPinFlag andPostsReplyFlag: (BOOL) postReplyFlag andPostsLoveFlag: (BOOL) postLoveFlag andPostsProfileIDRef: (NSInteger) postProfileIDRef;

{
    self = [super init];
    if (self)
    {
        postsID = postID;
        postsKey = postKey;
        postsType = postType;
        postsProfileID = postProfileID;
        postsProfileUser = postProfileUser;
        postsProfilePic = postProfilePic;
        postsPost = postPost;
        postsDateTime = postDateTime;
        postsAttachmentCount = postAttachmentCount;
        postsPinCount = postPinCount;
        postsReplyCount = postReplyCount;
        postsLoveCount = postLoveCount;
        postsPinFlag = postPinFlag;
        postsReplyFlag = postReplyFlag;
        postsLoveFlag = postLoveFlag;
        postsProfileIDRef = postProfileIDRef;
        
    }
    
    return self;
}

#pragma mark - Attachment Objects
- (id) initWithAttachmentsID: (NSInteger) attachmentID andAttachmentsKey: (NSString *) attachmentKey andAttachmentsPostID: (NSInteger) attachmentPostID andAttachmentsFileName: (NSString *) attachmentFileName andAttachmentsFileExtension: (NSString *) attachmentFileExtension andAttachmentsFileSize: (NSString *) attachmentFileSize andAttachmentsFilePath: (NSString *) attachmentFilePath andAttachmentsCreated: (NSString *) attachmentCreated andAttachmentsModified: (NSString *) attachmentModified;

{
    self = [super init];
    if (self)
    {
        attachmentsID = attachmentID;
        attachmentsKey = attachmentKey;
        attachmentsPostID = attachmentPostID;
        attachmentsFileName = attachmentFileName;
        attachmentsFileExtension = attachmentFileExtension;
        attachmentsFileSize = attachmentFileSize;
        attachmentsFilePath = attachmentFilePath;
        attachmentsCreated = attachmentCreated;
        attachmentsModified = attachmentModified;
    }
    
    return self;
}

#pragma mark - Interaction Objects
- (id) initWithInteractionProfileID: (NSInteger) interProfID andInteractionProfileUser: (NSString *) interProfUser andInteractionProfileName: (NSString *) interProfName andInteractionProfilePic: (NSString *) interProfPic andInteractionProfileFollowFlag: (BOOL) interProfFollowFlag;

{
    
    self = [super init];
    if (self)
    {
        interactionProfileID = interProfID;
        interactionProfileUser = interProfUser;
        interactionProfileName = interProfName;
        interactionProfilePic = interProfPic;
        interactionProfileFollowFlag = interProfFollowFlag;
    }
    
    return self;
    
}

#pragma mark - Post Attachment Objects
- (id) initWithPostAttachmentType: (NSString*) postAttachType andPostAttachmentFile: (NSData*) postAttachFile andPostAttachmentFilePath: (NSURL*) postAttachFilePath andPostAttachmentFileName: (NSString *) postAttachFileName andPostAttachmentFileExtension: (NSString *) postAttachFileExtension andPostAttachmentFileSize: (NSString *) postAttachFileSize andPostAttachmentCreationDate: (NSString *) postAttachCreationDate andPostAttachmentModificationDate: (NSString *) postAttachModificationDate andPostAttachmentThumbnail: (UIImage *) postAttachThumbnail {
    
    self = [super init];
    if (self)
    {
        postAttachmentType = postAttachType;
        postAttachmentFile = postAttachFile;
        postAttachmentFilePath = postAttachFilePath;
        postAttachmentFileName = postAttachFileName;
        postAttachmentFileExtension = postAttachFileExtension;
        postAttachmentFileSize = postAttachFileSize;
        postAttachmentCreationDate = postAttachCreationDate;
        postAttachmentModificationDate = postAttachModificationDate;
        postAttachmentThumbnail = postAttachThumbnail;
        
    }
    
    return self;
    
}

@end
