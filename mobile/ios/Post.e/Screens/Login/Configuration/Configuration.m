//
//  Configuration.m
//  Post.e
//
//  Created by Scott Grivner on 10/4/21.
//

#import "Configuration.h"

@interface Configuration ()

@end

@implementation Configuration

@synthesize backBtn, phpSwitch, pythonSwitch, nodeSwitch, rubySwitch, goSwitch, rustSwitch, perlSwitch, javaSwitch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backBtn.layer.cornerRadius = 10;
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    NSString * language;
    
    language = [[NSUserDefaults standardUserDefaults] valueForKey:@"language"];

    phpSwitch.enabled = NO;
    pythonSwitch.enabled = NO;
    nodeSwitch.enabled = NO;
    rubySwitch.enabled = NO;
    goSwitch.enabled = NO;
    rustSwitch.enabled = NO;
    perlSwitch.enabled = NO;
    javaSwitch.enabled = NO;

    if ([language isEqualToString:@"php"]) {
        
        [phpSwitch setOn:YES animated:NO];
        [pythonSwitch setOn:NO animated:NO];
        [nodeSwitch setOn:NO animated:NO];
        [rubySwitch setOn:NO animated:NO];
        [goSwitch setOn:NO animated:NO];
        [rustSwitch setOn:NO animated:NO];
        [perlSwitch setOn:NO animated:NO];
        [javaSwitch setOn:NO animated:NO];
        
    } else if ([language isEqualToString:@"py"]) {
        
        [phpSwitch setOn:NO animated:NO];
        [pythonSwitch setOn:YES animated:NO];
        [nodeSwitch setOn:NO animated:NO];
        [rubySwitch setOn:NO animated:NO];
        [goSwitch setOn:NO animated:NO];
        [rustSwitch setOn:NO animated:NO];
        [perlSwitch setOn:NO animated:NO];
        [javaSwitch setOn:NO animated:NO];
        
    } else if ([language isEqualToString:@"js"]) {
        
        [phpSwitch setOn:NO animated:NO];
        [pythonSwitch setOn:NO animated:NO];
        [nodeSwitch setOn:YES animated:NO];
        [rubySwitch setOn:NO animated:NO];
        [goSwitch setOn:NO animated:NO];
        [rustSwitch setOn:NO animated:NO];
        [perlSwitch setOn:NO animated:NO];
        [javaSwitch setOn:NO animated:NO];
        
    } else if ([language isEqualToString:@"rb"]) {
        
        [phpSwitch setOn:NO animated:NO];
        [pythonSwitch setOn:NO animated:NO];
        [nodeSwitch setOn:NO animated:NO];
        [rubySwitch setOn:YES animated:NO];
        [goSwitch setOn:NO animated:NO];
        [rustSwitch setOn:NO animated:NO];
        [perlSwitch setOn:NO animated:NO];
        [javaSwitch setOn:NO animated:NO];
        
    } else if ([language isEqualToString:@"go"]) {
        
        [phpSwitch setOn:NO animated:NO];
        [pythonSwitch setOn:NO animated:NO];
        [nodeSwitch setOn:NO animated:NO];
        [rubySwitch setOn:NO animated:NO];
        [goSwitch setOn:YES animated:NO];
        [rustSwitch setOn:NO animated:NO];
        [perlSwitch setOn:NO animated:NO];
        [javaSwitch setOn:NO animated:NO];
        
    } else if ([language isEqualToString:@"rs"]) {
        
        [phpSwitch setOn:NO animated:NO];
        [pythonSwitch setOn:NO animated:NO];
        [nodeSwitch setOn:NO animated:NO];
        [rubySwitch setOn:NO animated:NO];
        [goSwitch setOn:NO animated:NO];
        [rustSwitch setOn:YES animated:NO];
        [perlSwitch setOn:NO animated:NO];
        [javaSwitch setOn:NO animated:NO];
        
        
    } else if ([language isEqualToString:@"pl"]) {
        
        [phpSwitch setOn:NO animated:NO];
        [pythonSwitch setOn:NO animated:NO];
        [nodeSwitch setOn:NO animated:NO];
        [rubySwitch setOn:NO animated:NO];
        [goSwitch setOn:NO animated:NO];
        [rustSwitch setOn:NO animated:NO];
        [perlSwitch setOn:YES animated:NO];
        [javaSwitch setOn:NO animated:NO];
        
    } else if ([language isEqualToString:@"java"]) {
        
        [phpSwitch setOn:NO animated:NO];
        [pythonSwitch setOn:NO animated:NO];
        [nodeSwitch setOn:NO animated:NO];
        [rubySwitch setOn:NO animated:NO];
        [goSwitch setOn:NO animated:NO];
        [rustSwitch setOn:NO animated:NO];
        [perlSwitch setOn:NO animated:NO];
        [javaSwitch setOn:YES animated:NO];
        
    } else {
        
        [phpSwitch setOn:NO animated:NO];
        [pythonSwitch setOn:NO animated:NO];
        [nodeSwitch setOn:NO animated:NO];
        [rubySwitch setOn:NO animated:NO];
        [goSwitch setOn:NO animated:NO];
        [rustSwitch setOn:NO animated:NO];
        [perlSwitch setOn:NO animated:NO];
        [javaSwitch setOn:NO animated:NO];
    }
    
}

- (IBAction)phpSwitchToggled:(id)sender {
    
    [phpSwitch setOn:YES animated:YES];
    [pythonSwitch setOn:NO animated:YES];
    [nodeSwitch setOn:NO animated:YES];
    [rubySwitch setOn:NO animated:YES];
    [goSwitch setOn:NO animated:YES];
    [rustSwitch setOn:NO animated:YES];
    [perlSwitch setOn:NO animated:YES];
    [javaSwitch setOn:NO animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"php" forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)pythonSwitchToggled:(id)sender {
    
    [phpSwitch setOn:NO animated:YES];
    [pythonSwitch setOn:YES animated:YES];
    [nodeSwitch setOn:NO animated:YES];
    [rubySwitch setOn:NO animated:YES];
    [goSwitch setOn:NO animated:YES];
    [rustSwitch setOn:NO animated:YES];
    [perlSwitch setOn:NO animated:YES];
    [javaSwitch setOn:NO animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"py" forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)nodeSwitchToggled:(id)sender {
    
    [phpSwitch setOn:NO animated:YES];
    [pythonSwitch setOn:NO animated:YES];
    [nodeSwitch setOn:YES animated:YES];
    [rubySwitch setOn:NO animated:YES];
    [goSwitch setOn:NO animated:YES];
    [rustSwitch setOn:NO animated:YES];
    [perlSwitch setOn:NO animated:YES];
    [javaSwitch setOn:NO animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"js" forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)rubySwitchToggled:(id)sender {
    
    [phpSwitch setOn:NO animated:YES];
    [pythonSwitch setOn:NO animated:YES];
    [nodeSwitch setOn:NO animated:YES];
    [rubySwitch setOn:YES animated:YES];
    [goSwitch setOn:NO animated:YES];
    [rustSwitch setOn:NO animated:YES];
    [perlSwitch setOn:NO animated:YES];
    [javaSwitch setOn:NO animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"rb" forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)goSwitchToggled:(id)sender {
    
    [phpSwitch setOn:NO animated:YES];
    [pythonSwitch setOn:NO animated:YES];
    [nodeSwitch setOn:NO animated:YES];
    [rubySwitch setOn:NO animated:YES];
    [goSwitch setOn:YES animated:YES];
    [rustSwitch setOn:NO animated:YES];
    [perlSwitch setOn:NO animated:YES];
    [javaSwitch setOn:NO animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"go" forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)rustSwitchToggled:(id)sender {
    
    [phpSwitch setOn:NO animated:YES];
    [pythonSwitch setOn:NO animated:YES];
    [nodeSwitch setOn:NO animated:YES];
    [rubySwitch setOn:NO animated:YES];
    [goSwitch setOn:YES animated:YES];
    [rustSwitch setOn:YES animated:YES];
    [perlSwitch setOn:NO animated:YES];
    [javaSwitch setOn:NO animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"rs" forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)perlSwitchToggled:(id)sender {
    
    [phpSwitch setOn:NO animated:YES];
    [pythonSwitch setOn:NO animated:YES];
    [nodeSwitch setOn:NO animated:YES];
    [rubySwitch setOn:NO animated:YES];
    [goSwitch setOn:NO animated:YES];
    [rustSwitch setOn:NO animated:YES];
    [perlSwitch setOn:YES animated:YES];
    [javaSwitch setOn:NO animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"pl" forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (IBAction)javaSwitchToggled:(id)sender {
    
    [phpSwitch setOn:YES animated:YES];
    [pythonSwitch setOn:NO animated:YES];
    [nodeSwitch setOn:NO animated:YES];
    [rubySwitch setOn:NO animated:YES];
    [goSwitch setOn:NO animated:YES];
    [rustSwitch setOn:NO animated:YES];
    [perlSwitch setOn:NO animated:YES];
    [javaSwitch setOn:YES animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"java" forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
