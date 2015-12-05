//
//  D8iOS.h
//  Drupal8iOS
//
//  Created by Michael Smith on 10/16/15.
//  Copyright © 2015 PikLips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "MBProgressHUD.h"


@interface D8iOS : NSObject <MBProgressHUDDelegate>

+(void)verifyDrupalSite: (NSURL *)drupalSiteURL
/* withView: (UIView *)view */
             completion:(void (^)(NSError *))completion;
// completion:(void (^)(BOOL verified))completion;

+(void)uploadImageToServer: (PHAsset *) asset
                  withImage: (UIImageView *) assetImage
                 withinView: (UIViewController *) navController;

+(void)getCommentDataforNodeID:(NSString *)nodeID
                      withView:(UIView *)view
                    completion:(void (^)(NSMutableArray *commentList))completion;

+(void)getFileDatafromPath: (NSString *)path
                  withView:(UIView *)view
                completion:(void (^)(NSMutableArray *fileList))completion;

+(void)getArticleDatawithView:(UIView *)view
                   completion:(void (^)(NSMutableArray *articleList))completion;

+(void)uploadFilewithFileName: (NSString *)fileName
                andDataString:(NSString *)base64EncodedString
                     withView:(UIView *)view;

+(void)createUserAccountwithUserName: (NSString *)userName
                            password:(NSString *)password
                            andEmail:(NSString *)email
                            withView:(UIView *)view;

+(void)updateUserAccoutwithUserName: (NSString *)userName
                    currentPassword:(NSString *)currentPass
                              email:(NSString *)email
                revisedUserPassword:(NSString *)revisedUserPassword
                           withView:(UIView *)view;

+(void)loginwithUserName: (NSString *)userName
                password:(NSString *)password
                withView: (UIView *)view
              completion:(void (^)(NSMutableDictionary *userDetails))completion;

+(void)deleteFilewithFileID: (NSString *)fileID
                   withView: (UIView *)view
                 completion:(void (^)(BOOL deleted))completion;

+(void)getArticlewithNodeID: (NSString *)nodeID
                   withView: (UIView *)view
                 completion:(void (^)(NSMutableDictionary *articleDetails))completion;

+(void)postComment: (NSString *)comment
         withTitle: (NSString *)title
          onNodeID: (NSString *)nodeID
          withView: (UIView *)view
        completion:(void (^)(BOOL success))completion;

@end
