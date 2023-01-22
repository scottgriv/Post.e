//
//  PinManager.h
//  Post.e
//
//  Created by Scott Grivner on 4/20/22.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

//Class
@class PinManager;

//Protocol
@protocol PinManagerDelegate <NSObject>

@property (nonatomic, strong) PinManager * pinManagerDelegate;

- (void)pinClicked:(UIButton *)sender;

@end

@interface PinManager : NSObject <PinManagerDelegate>

//Objects
@property (strong, nonatomic) IBOutlet UITableView *table;                    // Passed Table
@property (strong, nonatomic) IBOutlet UIButton *postPinBtn;                  // Pin Button
@property (strong, nonatomic) IBOutlet UIButton *postPinCountBtn;             // Pin Count Button

//Variables
@property (nonatomic, strong) UIView * view;                                  // Passed Cell View
@property (nonatomic, strong) NSIndexPath * indexPath;                        // Passed Index Path
@property (nonatomic, strong) DataManager * data;                             // Passed Data
@property (nonatomic, strong) NSMutableArray * array;                         // Passed Array
@property (nonatomic, strong) NSMutableDictionary * parametersDictionary;     // Parameters Dictionary
@property (nonatomic, strong) NSString * token;                               // Token
@property (nonatomic, strong) UIViewController * vc;                          // View Controller

@end
