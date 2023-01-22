//
//  Configuration.h
//  Post.e
//
//  Created by Scott Grivner on 10/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Configuration : UIViewController

//Objects
@property (strong, nonatomic) IBOutlet UISwitch *phpSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *pythonSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *nodeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *rubySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *goSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *rustSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *perlSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *javaSwitch;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

@end

NS_ASSUME_NONNULL_END
