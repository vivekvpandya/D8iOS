//
//  SetupDrupalAccountViewController.m
//  Drupal8iOS
//
//  Created by Michael Smith on 7/11/15.
//  Copyright (c) 2015 PikLips. All rights reserved.
//
/* MAS:
 *  This allows anonymous visitors to get a Drupal account.  On the webpage
 *  interface, anonymous visitors can be permitted to automatically create an
 *  account, create an account after verifying with an email, or create an
 *  account after admin approval.
 */

/*  Vivek: This code creates POST on /user/entity. So it probably does not follow any permision settings
 *  enforced by Drupal's REGISTRATION AND CANCELLATION section.
 *  It directly follows it from ~/admin/people/permissions and just says that who can make POST on request
 *  on /user/entity. There is a work going on and almost done. Refer to https://www.drupal.org/node/2291055.
 *  The mentioned feature request covers many other issues related to user reqistration. After this works
 *  in upstream permissions on user sign up via REST, this will follow REGISTRAION AND CANCELLATION settings.
 *  Once done, then case-by-case details sent by client to the server will differ. For example most preferred
 *  case would be <#Visitors, but administrator approval is required#>. For that matter, the app will not send
 *  <#"status": [{"value": "1"}]#> in the JSON request becuase the created account will be unblocked by the
 *  administrator only. So, the traditional webpage user reponse may not apply.
 */


#import "SetupDrupalAccountViewController.h"
#import "Developer.h"  // MAS: for development only, see which
#import "NJOPasswordStrengthEvaluator.h"
#import "User.h"
#import "DIOSSession.h"
#import "DIOSUser.h"
#import "D8iOS.h"

@interface SetupDrupalAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *drupalUserName;
@property (weak, nonatomic) IBOutlet UITextField *drupalUserEmail;
@property (weak, nonatomic) IBOutlet UITextField *drupalUserPassword;
@property (weak, nonatomic) IBOutlet UILabel *passwordStrengthLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *passwordStrengthProgressView;
@property (weak, nonatomic) IBOutlet UITextView *validationsTextView;
@property (weak, nonatomic) IBOutlet UIButton *addAccBtn;
@property (nonatomic, strong) NJOPasswordValidator *strictValidator;
@property (weak, nonatomic) IBOutlet UITextView *emailValidationTextView;
@property (weak, nonatomic) IBOutlet UITextView *userNameValidationTextView;

@end

@implementation SetupDrupalAccountViewController

bool userNameStatus = NO;
bool passwordStatus = NO;
bool emailStatus = NO;

-(NJOPasswordValidator *)strictValidator {
    if (!_strictValidator) {
        _strictValidator = [NJOPasswordValidator validatorWithRules:@[[NJOLengthRule ruleWithRange:NSMakeRange(8, 64)], [NJORequiredCharacterRule lowercaseCharacterRequiredRule], [NJORequiredCharacterRule uppercaseCharacterRequiredRule], [NJORequiredCharacterRule symbolCharacterRequiredRule]]];
    }
    return _strictValidator;
}

-(IBAction)createUserAccount:(id)sender {
    
    [D8iOS createUserAccountwithUserName:self.drupalUserName.text
                                password:self.drupalUserPassword.text
                                andEmail:self.drupalUserEmail.text
                                withView:self.view];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Add notification center observer to observe change in password filed
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification
                                                      object:self.drupalUserPassword
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self updatePasswordStrength:note.object];
                                                  }];
    
    // Add notification center observer to observe change in email filed
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification
                                                      object:self.drupalUserEmail
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * __nonnull note) {
                                                      [self updateEmailValidation:note.object];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification
                                                      object:self.drupalUserName
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * __nonnull note) {
                                                      [self updateUserNameValidation:note.object];
                                                  }];
    
    [self updatePasswordStrength:self];
    [self updateEmailValidation:self];
    [self updateUserNameValidation:self];
    [self changeAddAccBtnStatus];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)validateUserName:(NSString *) userName {
    // Spaces are allowed; punctuation is not allowed except for periods, hyphens, apostrophes, and underscores.
    // For regExp refer http://www.raywenderlich.com/30288/nsregularexpression-tutorial-and-cheat-sheet
    
    NSString *regExPattern = @"^[A-Za-z0-9-'_.][A-Za-z0-9-'_.\\s]*";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExPattern];
    
    if ([myTest evaluateWithObject: userName]){
        
        D8D(@"User Name validation succeed");
        userNameStatus = YES;
        return YES;
        
    }
    else {
        
        D8D(@"Username validation failed");
        userNameStatus = NO;
        return NO;
        
    }
}

-(BOOL)validateEmail:(NSString*) emailString
{
    // Please refer to http://www.regular-expressions.info/email.html for more information on Regular Expression for email validation
    
    NSString *regExPattern = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExPattern];
    
    if ( [myTest evaluateWithObject: emailString] ) {
        
        emailStatus = YES;
        return YES;
    }
    else {
        
        emailStatus = NO;
        return NO;
        
    }
}

-(void)updateEmailValidation:(id)sender{
    NSString *email  = self.drupalUserEmail.text;
    
    if ( [email length] == 0 ) {
        
        self.emailValidationTextView.text = nil;
        emailStatus = NO;
        
    }
    else {
        
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
        
        if ( [self validateEmail:email] ) {
            
            [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc]
                                                             initWithString:@"It's a valid email."
                                                             attributes:@{NSForegroundColorAttributeName: [UIColor greenColor]}]];
            
            self.emailValidationTextView.attributedText = mutableAttributedString;
            
        }
        else {
            
            [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc]
                                                             initWithString:@"Please enter a valid email."
                                                             attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}]];
            
            self.emailValidationTextView.attributedText = mutableAttributedString;
            
        }
    }
    [self changeAddAccBtnStatus];
}

-(void)updateUserNameValidation:(id)sender{
    NSString *userName  = self.drupalUserName.text;
    
    if ( [userName length] == 0 ){
        self.userNameValidationTextView.text = nil;
        userNameStatus = NO;
    }
    else {
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
        
        if ( ![self validateUserName:userName] ) {
            
            [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc]
                                                             initWithString:@"Spaces are allowed; punctuation is not allowed except for ., -, ', and _ ."
                                                             attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}]];
            
            self.userNameValidationTextView.attributedText = mutableAttributedString;
            
        }
        else {
            
            self.userNameValidationTextView.text = nil;
            
        }
    }
    [self changeAddAccBtnStatus];
}

- (void)updatePasswordStrength:(id)sender {
    NSString *password = self.drupalUserPassword.text;
    
    if ( [password length] == 0 ) {
        self.validationsTextView.text = nil;
        self.passwordStrengthProgressView.progress = 0.0f;
        self.passwordStrengthLabel.text = nil;
        passwordStatus = NO;
    } else {
        NJOPasswordStrength strength = [NJOPasswordStrengthEvaluator strengthOfPassword:password];
        
        NSArray *failingRules = nil;
        if ( [self.strictValidator validatePassword:password failingRules:&failingRules] ) {
            self.passwordStrengthLabel.text = [NJOPasswordStrengthEvaluator localizedStringForPasswordStrength:strength];
            switch ( strength ) {
                case NJOVeryWeakPasswordStrength:
                    self.passwordStrengthProgressView.progress = 0.05f;
                    self.passwordStrengthProgressView.tintColor = [UIColor redColor];
                    break;
                case NJOWeakPasswordStrength:
                    self.passwordStrengthProgressView.progress = 0.25f;
                    self.passwordStrengthProgressView.tintColor = [UIColor orangeColor];
                    break;
                case NJOReasonablePasswordStrength:
                    self.passwordStrengthProgressView.progress = 0.5f;
                    self.passwordStrengthProgressView.tintColor = [UIColor yellowColor];
                    break;
                case NJOStrongPasswordStrength:
                    self.passwordStrengthProgressView.progress = 0.75f;
                    self.passwordStrengthProgressView.tintColor = [UIColor greenColor];
                    break;
                case NJOVeryStrongPasswordStrength:
                    self.passwordStrengthProgressView.progress = 1.0f;
                    self.passwordStrengthProgressView.tintColor = [UIColor cyanColor];
                    break;
            }
            
            self.validationsTextView.text = nil;
            passwordStatus = YES;
            
        } else {
            self.passwordStrengthLabel.text = NSLocalizedString(@"Invalid Password", nil);
            self.passwordStrengthProgressView.progress = 0.0f;
            self.passwordStrengthProgressView.tintColor = [UIColor redColor];
            
            NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
            for (id <NJOPasswordRule> rule in failingRules) {
                [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc]
                                                                 initWithString:[NSString stringWithFormat:@"• %@\n", [rule localizedErrorDescription]]
                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}]];
            }
            
            self.validationsTextView.attributedText = mutableAttributedString;
            passwordStatus = NO;
        }
    }
    [self changeAddAccBtnStatus];
}

-(void)changeAddAccBtnStatus{
    
    self.addAccBtn.enabled = emailStatus && userNameStatus && passwordStatus;
}

@end
