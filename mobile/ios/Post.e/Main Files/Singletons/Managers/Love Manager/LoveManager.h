//
//  LoveManager.h
//  Post.e
//
//  Created by Scott Grivner on 1/17/22.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

//Class
@class LoveManager;

//Protocol
@protocol LoveManagerDelegate <NSObject>

@property (nonatomic, strong) LoveManager * loveManager;

- (void)loveClicked:(UIButton *)sender;

@end

@interface LoveManager : NSObject <LoveManagerDelegate>

//Objects
@property (strong, nonatomic) IBOutlet UITableView *table;                  // Passed Table
@property (strong, nonatomic) IBOutlet UIButton *postLoveBtn;               // Love Button
@property (strong, nonatomic) IBOutlet UIButton *postLoveCountBtn;          // Love Count Button

//Variables
@property (nonatomic, strong) UIView * view;                                // Passed Cell View
@property (nonatomic, strong) NSIndexPath * indexPath;                      // Passed Index Path
@property (nonatomic, strong) DataManager * data;                           // Passed Data
@property (nonatomic, strong) NSMutableArray * array;                       // Passed Array
@property (nonatomic, strong) NSMutableDictionary * parametersDictionary;   // Parameters Dictionary
@property (nonatomic, weak) UIViewController *vc;                           // View Controller
    
@end
