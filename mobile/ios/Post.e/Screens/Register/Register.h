//
//  Register.h
//  Post.e
//
//  Created by Scott Grivner on 10/3/21.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Register : UIViewController <UITextFieldDelegate>

//Objects
@property (weak, nonatomic) IBOutlet UITextField *fldUsername;                    //Username Field
@property (weak, nonatomic) IBOutlet UITextField *fldPassword;                    //Password Field
@property (weak, nonatomic) IBOutlet UITextField *fldRePassword;                  //Re-enter Password Field
@property (weak, nonatomic) IBOutlet UIButton * registerBtn;                      //Register Button
@property (strong, nonatomic) IBOutlet UIButton *backBtn;                         //Background Button
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * spinner;         //Spinner
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer * backgroundTapped; //Background Tapped

//Variables
@property (nonatomic, strong) NSString * device;                                  //Device
@property (nonatomic, strong) NSString * language;                                //Language

//Methods
- (IBAction)backgroundTap:(id)sender;
- (IBAction)registerClicked:(id)sender;

@end

NS_ASSUME_NONNULL_END
