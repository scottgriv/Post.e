//
//  Login.h
//  Post.e
//
//  Created by Scott Grivner on 10/3/21.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface Login : UIViewController <WCSessionDelegate>

//Objects
@property (weak, nonatomic) IBOutlet UITextField *fldUsername;            //Username Field
@property (weak, nonatomic) IBOutlet UITextField *fldPassword;            //Password Field
@property (weak, nonatomic) IBOutlet UIButton * loginBtn;                 //Login Button
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;             //Register Button
@property (strong, nonatomic) IBOutlet UIButton *configureBtn;            //Configure Button
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * spinner; //Activity Indicator

//Variables
@property (nonatomic, strong) NSString * language;                        //Language

@end

NS_ASSUME_NONNULL_END
