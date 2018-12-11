//
//  SaveMediasToCustomAlbum.h
//  InstaPost
//
//  Created by Anthony on 11/19/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface SaveMediasToCustomAlbum : NSObject
+(SaveMediasToCustomAlbum *_Nullable) getInstance;

- (void)saveVideoToCameraRollUrl:(NSURL *_Nullable)url albumName:(NSString*_Nullable)albumName  completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;
- (void)saveImageToCameraRoll:(UIImage *)image albumName:(NSString*)albumName  completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error,PHAsset *asset))completionHandler;

@end
