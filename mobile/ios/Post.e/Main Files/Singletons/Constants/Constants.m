//
//  Constants.m
//  Post.e
//
//  Created by Scott Grivner on 10/3/21.
//

#import "Constants.h"

@implementation Constants

//Formatted URL for Requests
@synthesize formattedURL, baseExtension;

//Base URL - Hardcoding your Web Server or Localhost IP is permittable here.
#if TARGET_IPHONE_SIMULATOR
NSString * const baseURL = @"http://localhost/Post.e/server";
#else
NSString * const baseURL = @"http://your_server_ip_address/Post.e/server";
//Ex. http://10.0.1.2/Post.e
//Ex. http://192.168.0.2/Post.e
#endif

//Server Files
NSString * const LoginURL = @"login";                   //Login
NSString * const ProfileURL = @"profile";               //Profile
NSString * const FeedURL = @"feed";                     //Feed
NSString * const PostURL = @"post";                     //Post
NSString * const InteractionURL = @"interaction";       //Interaction

//Format URL Function with selected language folder
- (NSURL *)formatURL:(NSString *)passedURL {
    
    baseExtension = [[NSUserDefaults standardUserDefaults] valueForKey:@"language"];
    
    if ([baseExtension isEqual:@""]) {
        
        baseExtension = @"php";
    }
    
    formattedURL = [NSURL URLWithString:
                    [baseURL stringByAppendingString:[@"/languages/" stringByAppendingString:[baseExtension stringByAppendingString:[@"/" stringByAppendingString:[passedURL stringByAppendingString:[@"." stringByAppendingString:baseExtension]]]]]]];
    
    
    NSLog(@"Formatted URL: %@", formattedURL);
    return formattedURL;
    
}

//Dark Gray Constant
//RGB : R:111 G:113 B:121
//Hex : #6F7179
+(UIColor *) darkGray {
    
    return [UIColor colorWithRed:111.0/255.0 green:113.0/255.0 blue:121.0/255.0 alpha:1];
    
}

//Light Gray Constant
//RGB : R:233 G:234 B:240
//Hex : #E9EAF0
+(UIColor *) lightGray {
    
    return [UIColor colorWithRed:233.0/255.0 green:234.0/255.0 blue:240.0/255.0 alpha:1];
    
}

@end
