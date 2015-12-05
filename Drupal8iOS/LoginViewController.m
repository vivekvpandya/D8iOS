//
//  LoginViewController.m
//  Drupal8iOS
//
//  Created by Michael Smith on 7/12/15.
//  Copyright (c) 2015 PikLips. All rights reserved.
//
/* MAS: This signs in a registered user
 */

#import "LoginViewController.h"
#import "Developer.h"  // MAS: for development only, see which
#import "D8iOSHelper.h"
#import "SGKeychain.h"
#import "User.h"
#import <AFNetworking/AFNetworking.h>
#import "DIOSSession.h"
#import "DIOSView.h"
#import "D8iOS.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UILabel *username_status;
@property (weak, nonatomic) IBOutlet UILabel *roles_status;

@end

@implementation LoginViewController
-(IBAction)loginUser:(id)sender {
    // MAS: this code validates the user name and password and logs in the user
    
    [self.userName resignFirstResponder];
    [self.userPassword resignFirstResponder];
    
    //[self.activityIndicator startAnimating];
    
    NSString *username = self.userName.text;
    NSString *password = self.userPassword.text;
    
    [self loginWithUsername:username andPassword:password];
  
}
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password {
    [D8iOS loginwithUserName:username
                    password:password
                    withView:self.view
                  completion:^(NSMutableDictionary *userDetails) {
                      if (userDetails != nil) {
                          User *user = [User sharedInstance];
                          [user fillUserWithUserJSONObject:userDetails];
                          [self.username_status setText:user.name];
                          NSString * rolesString = [[user.roles valueForKey:@"description"] componentsJoinedByString:@" "];
                          [self.roles_status setText:rolesString];

                      }
                      else{
                          User *user = [User sharedInstance];
                          [user clearUserDetails];
                          [self.username_status setText:@"..."];
                          [self.roles_status setText:@"..."];

                      }
        
    }];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    User *user  = [User sharedInstance];
    if(user.name != nil){
        [self.username_status setText:user.name];
        NSString * rolesString = [[user.roles valueForKey:@"description"] componentsJoinedByString:@" "];
        
        [self.roles_status setText:rolesString];

    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
