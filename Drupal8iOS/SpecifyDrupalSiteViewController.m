//
//  SpecifyDrupalSiteViewController.m
//  Drupal8iOS
//
//  Created by Michael Smith on 7/11/15.
//  Copyright (c) 2015 PikLips. All rights reserved.
//
/** MAS: 
 *  This provides a way for the user to specify the URL of the Drupal 8
 *  website that will act as this apps back-end.  See below.
 */

#import "SpecifyDrupalSiteViewController.h"
#import "Developer.h"// MAS: for development only, see which
#import "DIOSSession.h"
#import "DIOSView.h"
#import "D8iOS.h"
#import "NotifyViewController.h"

@interface NSString (ValidURLTest)
- (BOOL)isValidURL;
@end

@implementation NSString (ValidURLTest)

/** This comes from Anthony via StackOverflow - http://stackoverflow.com/users/169737/anthony
 *  @uses NSString category validates a URL string.  "I have been using a category on
 *  NSString that uses NSDataDetector to test for the presence of a link within a string. 
 *  If the range of the link found by NSDataDetector equals the length of the entire string, 
 *  then it is a valid URL."
 */
- (BOOL)isValidURL {
    NSUInteger length = [self length];
    // Empty strings should return NO
    if (length > 0) {
        NSError *error = nil;
        NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
        if (dataDetector && !error) {
            NSRange range = NSMakeRange(0, length);
            NSRange notFoundRange = (NSRange){NSNotFound, 0};
            NSRange linkRange = [dataDetector rangeOfFirstMatchInString:self options:0 range:range];
            if (!NSEqualRanges(notFoundRange, linkRange) && NSEqualRanges(range, linkRange)) {
                return YES;
            }
        }
        else {
            D8E(@"Could not create link data detector: %@ %@", [error localizedDescription], [error userInfo]);
        }
    }
    return NO;
}
@end

@interface SpecifyDrupalSiteViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userSiteRequest; // MAS: user input that require local format validation and remote confirmation
@property (weak, nonatomic) IBOutlet UILabel *connectionStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusInfoLabel;
@property (strong, atomic) MBProgressHUD  *hud;  // for activity indicator

@end

@implementation SpecifyDrupalSiteViewController

/** @function checkDrupalSite
 *  @param (id)sender
 *  @abstract This verifies the user input and tests to see if the URL points to a live host.
 *  @seealso
 *  @discussion Vivek: Actually there is no provision in this code to determine if this is a valid D8 site.
 *  It just checks if device is able to connect (i.e 200 OK http status) to web site specified.
 *  Ideally a Drupal 8 REST module's responsibility is to enable one publically accesible end point,
 *  and its URL pattern should be some standard documented on drupal.org for example /node/verify .
 *  So then app can call GET on this specific URL, and the the PHP code on the server will verify
 *  that REST and related modules are enabled and based on that it will return some status code
 *  in response. By using this endpoint we can verify that this is Drupal 8 or not.
 *  There may be better way, perhaps based on response headers. This point may require
 *  discussion with some very experienced, D8 community people.
 *  @return Message to user that the URL is valid and live or alerts to the contrary
 *  @throws N/A
 *  @updated
 */
- (IBAction)checkDrupalSite:(id)sender {
    // If required, this code can be dispatch on a separate thread to get more performance
    // check logic goes here --
    NSURL *url = [self cleanupAndCheckURL:self.userSiteRequest.text]; // check the URL scheme and host, at http scheme if necessary
    if ( url ) {
        D8D(@"checkDrupalSite: URL host entered for %@ is %@ and the scheme is %@", url, url.host, url.scheme);
        [self toggleSpinner:YES];  // show them we are busy
        
        [D8iOS verifyDrupalSite:url completion:^(NSError *completion) {
            D8D(@"checkDrupalSite: completionCode is %@", completion);
            switch (completion.code) {
                case 200: {  // MAS:  maybe not an 'OK' response.  What is 'OK'?
                    [self.statusInfoLabel setText:self.userSiteRequest.text];
                    NSAttributedString *attributeStatus = [[NSAttributedString alloc]                                                                initWithString:@"OK"                                                               attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.1 green:2.0 blue:0.0 alpha:1.000]}];
                    [self.connectionStatusLabel setAttributedText:attributeStatus];
                    break;
                }
                case 403: {
                    [self presentViewController:[NotifyViewController alreadySignedInNotifyError:completion.localizedDescription] animated:YES completion:nil];
                    NSAttributedString *attributeStatus = [[NSAttributedString alloc]initWithString:@"FAILED" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.000]}];
                    [self.connectionStatusLabel setAttributedText:attributeStatus];
                    break;
                }
                default: {
                    [self presentViewController:[NotifyViewController otherURLNotifyError:completion.localizedDescription] animated:YES completion:nil];
                    NSAttributedString *attributeStatus = [[NSAttributedString alloc] initWithString:@"FAILED"          attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.000]}];
                    [self.connectionStatusLabel setAttributedText:attributeStatus];
                    
                    break;
                }
            }
            [self toggleSpinner:NO];  // all done
        }];
    }
    else { // this URL did not pass the smell test
        
        [self presentViewController:[NotifyViewController invalidURLNotify] animated:YES completion:nil];
        NSAttributedString *attributeStatus = [[NSAttributedString alloc] initWithString:@"..."                                                                                attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.0                                                                                                             green:0.0                                                                                                                                                blue:0.0                                                                                                                                               alpha:1.000]}];
        [self.connectionStatusLabel setAttributedText:attributeStatus];
        
    }
    
    // [self dismissViewControllerAnimated:YES completion:nil];
}

/** @function cleanAndCheckURL
 *  @param potentialURL A NSString containing a URL that may or may not have a scheme but should have a host.
 *  @abstract This ensures that the entered string has a http scheme and then checks its validity.
 *  The weakness is that the user may want an https connection.  BTW, it might validate
 *  a ftp or other valid scheme.
 *  @seealso
 *  @discussion FWIW, best regex for a URL ( by @diegoperini https://gist.github.com/dperini/729294 )
 *  We do not use it, but WTF.
 *  @return Verified NSURL with scheme and host or nil if invalid
 *  @throws N/A
 *  @updated
 */

-(NSURL *)cleanupAndCheckURL:(NSString *) potentialURL {
    NSString * checkString;
    D8D(@"cleanupAndCheckURL: URL String is %@", potentialURL);
    NSURL *testURL = [NSURL URLWithString:potentialURL];
    // Look for the scheme -
    if ( testURL.host ) {
        checkString = potentialURL;
    }
    else {
        D8D(@"cleanupAndCheckURL: appended URL is %@", [@"http://" stringByAppendingString: potentialURL]);
        checkString = [@"http://" stringByAppendingString: potentialURL];
    }
    // Check the URL -
    if ( [checkString isValidURL] ) {
        D8D(@"cleanupAndCheckURL: URL validated as complete");
        return [NSURL URLWithString: checkString];
    }
    else {
        D8D(@"cleanupAndCheckURL: isValidURL and RegEx eval tests failed");
        return nil;
    }
}
/** @function toggleSpinner: (bool) on
 *  @param on A bool indicating whether the activity indicator should be on or off.
 *  @abstract This implements MBProgressHUB as an alternative to UIActivityIndicatorView .
 *  @seealso https://github.com/jdg/MBProgressHUD
 *  @discussion This needs to be a Cocoapod and abstracted into its own class with specific objects
 *              for each use (more illustrative).
 *  @return N/A
 *  @throws N/A
 *  @updated
 *
 */
-(void)toggleSpinner:(bool) on {
    if ( on ) {
        _hud = [[MBProgressHUD alloc ] initWithView:super.view];
        [super.view addSubview:_hud];
        _hud.delegate = nil;
        _hud.labelText = @"Verifying Drupal 8 site";
        [_hud show:YES];
    }
    else {
        UIImageView *imageView;
        UIImage *image = [UIImage imageNamed:@"37x-Checkmark.png"];
        imageView = [[UIImageView alloc] initWithImage:image];
        _hud.customView = imageView;
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.labelText = @"Completed";
        dispatch_async(dispatch_get_main_queue(), ^{
            // Put main thread to sleep so that "Completed" HUD stays on for a second
            sleep(1);
            [_hud hide:YES];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.statusInfoLabel setText:[defaults objectForKey:@"drupal8site"] ?:@"None" ];
    [self.userSiteRequest setText:[defaults objectForKey:@"drupal8site"]?:@""];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
