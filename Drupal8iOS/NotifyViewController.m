//
//  NotifyViewController.m
//  Drupal8iOS
//
//  Created by Michael Smith on 11/16/15.
//  Copyright © 2015 PikLips. All rights reserved.
//

#import "NotifyViewController.h"
#import "Developer.h"

@interface NotifyViewController () <UITextFieldDelegate>

// Maintains a reference to the alert action that should be toggled when the text field changes (for the secure text entry alert example and its derivatives).
@property (nonatomic, weak) UIAlertAction *secureTextAlertAction;

@end

@implementation NotifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - D8iOS specific notifications

/** @function noURLNotify
 *  @param N/A
 *  @abstract This alerts the user that the URL submitted was empty.
 *  @seealso drupal-ios-sdk, AFNetworking
 *  @discussion
 *  @return cancel action
 *  @throws N/A
 *  @updated
 */
+(UIAlertController *)noURLNotify {
    NSString *title = NSLocalizedString(@"Nothing entered", nil);
    NSString *message = NSLocalizedString(@"Please enter the URL for your Drupal 8 host", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        D8D(@"noURLNotufy: The alert's cancel action occured.");
    }];
    
    // Add the action.
    [alertController addAction:cancelAction];
    return alertController;
}

/** @function invalidURLNotify
 *  @param N/A
 *  @abstract This alerts the user that the URL submitted was not properly formed.
 *  @seealso drupal-ios-sdk, AFNetworking
 *  @discussion
 *  @return cancel action
 *  @throws N/A
 *  @updated
 */
+(UIAlertController *)invalidURLNotify {
    NSString *title = NSLocalizedString(@"URL Naming Problem", nil);
    NSString *message = NSLocalizedString(@"Please check the URL for your Drupal 8 host", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        D8D(@"invalidURLNotify: The alert's cancel action occured.");
    }];
    
    // Add the action.
    [alertController addAction:cancelAction];
    return alertController;
    //[self presentViewController:alertController animated:YES completion:nil];
}

/** @function alreadySignedInURLNotify
 *  @param N/A
 *  @abstract This alerts the user that the he was already connected to a host.
 *  @seealso drupal-ios-sdk, AFNetworking
 *  @discussion  needs to logout
 *  @return cancel action
 *  @throws N/A
 *  @updated
 */
+(UIAlertController *)alreadySignedInNotifyError:(NSString *)errmsg {
    NSString *title = NSLocalizedString(@"Already Signed In", nil);
    NSString *message = NSLocalizedString(@"It appears you are already signed into a host. See ", nil);
    message = [message stringByAppendingString:errmsg];
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        D8D(@"alreadySignedInNotifyError: The alert's cancel action occured.");
    }];
    
    // Add the action.
    [alertController addAction:cancelAction];
    return alertController;
    //[self presentViewController:alertController animated:YES completion:nil];
}

/** @function notherURLNotifyError
 *  @param N/A
 *  @abstract This alerts the user that the URL submitted was not available.
 *  @seealso drupal-ios-sdk, AFNetworking
 *  @discussion includes the NSError message
 *  @return cancel action
 *  @throws N/A
 *  @updated
 */
+(UIAlertController *)otherURLNotifyError:(NSString *)errmsg {
    NSString *title = NSLocalizedString(@"URL Error", nil);
    NSString *message = NSLocalizedString(@"There was a problem connecting to this host. ", nil);
    message = [message stringByAppendingString:errmsg];
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        D8D(@"otherURLNotifyError: The alert's cancel action occured.");
    }];
    
    // Add the action.
    [alertController addAction:cancelAction];
    return alertController;
    // [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Example UIAlertControllerStyleAlert Style Alerts (templates: not actually used)

// Show an alert with an "Okay" button.
+(void)showSimpleAlert {
    NSString *title = NSLocalizedString(@"A Short Title Is Best", nil);
    NSString *message = NSLocalizedString(@"A message should be a short, complete sentence.", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The simple alert's cancel action occured.");
    }];
    
    // Add the action.
    [alertController addAction:cancelAction];
    
    // [self presentViewController:alertController animated:YES completion:nil];
}

// Show an alert with an "Okay" and "Cancel" button.
+(void)showOkayCancelAlert {
    NSString *title = NSLocalizedString(@"A Short Title Is Best", nil);
    NSString *message = NSLocalizedString(@"A message should be a short, complete sentence.", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        D8D(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        D8D(@"The \"Okay/Cancel\" alert's other action occured.");
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    // [self presentViewController:alertController animated:YES completion:nil];
}

// Show an alert with two custom buttons.
+(void)showOtherAlert {
    NSString *title = NSLocalizedString(@"A Short Title Is Best", nil);
    NSString *message = NSLocalizedString(@"A message should be a short, complete sentence.", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *otherButtonTitleOne = NSLocalizedString(@"Choice One", nil);
    NSString *otherButtonTitleTwo = NSLocalizedString(@"Choice Two", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        D8D(@"The \"Other\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherButtonOneAction = [UIAlertAction actionWithTitle:otherButtonTitleOne style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        D8D(@"The \"Other\" alert's other button one action occured.");
    }];
    
    UIAlertAction *otherButtonTwoAction = [UIAlertAction actionWithTitle:otherButtonTitleTwo style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        D8D(@"The \"Other\" alert's other button two action occured.");
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherButtonOneAction];
    [alertController addAction:otherButtonTwoAction];
    
    // [self presentViewController:alertController animated:YES completion:nil];
}

// Show a text entry alert with two custom buttons.
+(void)showTextEntryAlert {
    NSString *title = NSLocalizedString(@"A Short Title Is Best", nil);
    NSString *message = NSLocalizedString(@"A message should be a short, complete sentence.", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Add the text field for text entry.
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // If you need to customize the text field, you can do so here.
    }];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        D8D(@"The \"Text Entry\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        D8D(@"The \"Text Entry\" alert's other action occured.");
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    // used in calling view controller -- presentViewController:[[NotifyViewController showTextEntryAlert] animated:YES completion:nil];
}

// Show a secure text entry alert with two custom buttons.
- (void)showSecureTextEntryAlert {
    NSString *title = NSLocalizedString(@"A Short Title Is Best", nil);
    NSString *message = NSLocalizedString(@"A message should be a short, complete sentence.", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Add the text field for the secure text entry.
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        /*
         Listen for changes to the text field's text so that we can toggle the current
         action's enabled property based on whether the user has entered a sufficiently
         secure entry.
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
        
        textField.secureTextEntry = YES;
    }];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        D8D(@"The \"Secure Text Entry\" alert's cancel action occured.");
        
        // Stop listening for text changed notifications.
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        D8D(@"The \"Secure Text Entry\" alert's other action occured.");
        
        // Stop listening for text changed notifications.
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
    }];
    
    // The text field initially has no text in the text field, so we'll disable it.
    otherAction.enabled = NO;
    
    // Hold onto the secure text alert action to toggle the enabled/disabled state when the text changed.
    self.secureTextAlertAction = otherAction;
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    // used in calling view controller -- presentViewController:[[NotifyViewController showSecureTextEntryAlert] animated:YES completion:nil];
}

#pragma mark - UITextFieldTextDidChangeNotification (used for showSecureTextEntryAlert)

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    
    // Example: enforce a minimum length of >= 5 characters for secure text alerts.
    self.secureTextAlertAction.enabled = textField.text.length >= 5;
}

@end
