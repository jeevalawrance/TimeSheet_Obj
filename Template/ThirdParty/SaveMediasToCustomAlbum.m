//
//  SaveImageToCustomAlbum.m
//  InstaPost
//
//  Created by Anthony on 11/19/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "SaveMediasToCustomAlbum.h"
static SaveMediasToCustomAlbum *sharedInstance = nil;

@implementation SaveMediasToCustomAlbum


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


+(SaveMediasToCustomAlbum *) getInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)saveImageToCameraRoll:(UIImage *)image albumName:(NSString*)albumName  completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error,PHAsset *asset))completionHandler{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusAuthorized) {
        // Access has been granted.
        [self savingImageAfterAuthorisation:image albumName:albumName completionHandler:^(BOOL success, NSError * _Nullable error, PHAsset *asset) {
            completionHandler(success,error,asset);
        }];
    }
    
    else if (status == PHAuthorizationStatusDenied) {
        // Access has been denied.
    }
    
    else if (status == PHAuthorizationStatusNotDetermined) {
        
        // Access has not been determined.
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                // Access has been granted.
          
                [self savingImageAfterAuthorisation:image albumName:albumName completionHandler:^(BOOL success, NSError * _Nullable error, PHAsset *asset) {
                    completionHandler(success,error,asset);
                }];
            }
            
            else {
                // Access has been denied.
            }
        }];
    }
    
    else if (status == PHAuthorizationStatusRestricted) {
        // Restricted access - normally won't happen.
    }
    
    
}
- (void)savingImageAfterAuthorisation:(UIImage *)image albumName:(NSString*)albumName  completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error,PHAsset *asset))completionHandler{
    
    void (^saveBlock)(PHAssetCollection *assetCollection) = ^void(PHAssetCollection *assetCollection) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];
            
        } completionHandler:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"Error creating asset: %@", error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(success,error,nil);
                });
            }
            
        }];
    };
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"localizedTitle = %@", albumName];
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions];
    if (fetchResult.count > 0) {
        saveBlock(fetchResult.firstObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(TRUE,nil,fetchResult.firstObject);
        });
    } else {
        __block PHObjectPlaceholder *albumPlaceholder;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
            albumPlaceholder = changeRequest.placeholderForCreatedAssetCollection;
            
        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumPlaceholder.localIdentifier] options:nil];
                if (fetchResult.count > 0) {
                    saveBlock(fetchResult.firstObject);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(success,error,fetchResult.firstObject);
                });
            } else {
                NSLog(@"Error creating album: %@", error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(success,error,nil);
                });
            }
          
            
        }];
    }
}
- (void)saveVideoToCameraRollUrl:(NSURL *)url albumName:(NSString*)albumName  completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler
{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusAuthorized) {
        // Access has been granted.
        [self savingVideoAfterAuthorisation:url albumName:albumName completionHandler:^(BOOL success, NSError * _Nullable error) {
            completionHandler(success,error);
        }];
    }
    
    else if (status == PHAuthorizationStatusDenied) {
        // Access has been denied.
    }
    
    else if (status == PHAuthorizationStatusNotDetermined) {
        
        // Access has not been determined.
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                // Access has been granted.
                [self savingVideoAfterAuthorisation:url albumName:albumName completionHandler:^(BOOL success, NSError * _Nullable error) {
                    completionHandler(success,error);
                }];
            }
            
            else {
                // Access has been denied.
            }
        }];
    }
    
    else if (status == PHAuthorizationStatusRestricted) {
        // Restricted access - normally won't happen.
    }
    

    
    
}
- (void)savingVideoAfterAuthorisation:(NSURL *)url albumName:(NSString*)albumName  completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler
{
    
    NSLog(@"entered %s", __PRETTY_FUNCTION__);
    __block PHAssetCollection *collection;
    __block PHObjectPlaceholder *placeholder;
    
    // Find the album
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", albumName];
    // this is how we get a match for album Title held by 'collectionTitle'
    
    collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions].firstObject;
    
    // check if album exists
    if (!collection)
    {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            NSLog(@" Album did not exist, now creating album: %@",albumName);
            // Create the album
            PHAssetCollectionChangeRequest *createAlbum = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
            
            placeholder = [createAlbum placeholderForCreatedAssetCollection];
            
        } completionHandler:^(BOOL didItSucceed, NSError *error) {
            if (didItSucceed)
            {
                PHFetchResult *collectionFetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[placeholder.localIdentifier] options:nil];
                
                collection = collectionFetchResult.firstObject;
                [self locallySaveVideo:url collection:collection completionHandler:^(BOOL success, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(success,error);
                    });
                }];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(didItSucceed,error);
                });
            }
           
        }];
    }
    else
    {
        [self locallySaveVideo:url collection:collection completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(success,error);
            });
        }];
        
    }
    

    
}
-(void)locallySaveVideo:(NSURL *)url collection:(PHAssetCollection*)collection completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler
{
    __block PHFetchResult *photosAsset;
    __block PHObjectPlaceholder *placeholder;

    // Save to the album
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
        
        placeholder = [assetRequest placeholderForCreatedAsset];
        photosAsset = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        
        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection assets:photosAsset];
        [albumChangeRequest addAssets:@[placeholder]];
        
    } completionHandler:^(BOOL didItSucceed, NSError *error) {
        
        if (didItSucceed)
        {       // if YES
            
            // NSLog(@" Looks like Image was saved in camera Roll as %@", placeholder.localIdentifier);
            //NSLog(@"placeholder holds %@", placeholder.debugDescription );
            
        }
        else
        {
            NSLog(@"%@", error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(didItSucceed,error);
        });
    }];
    
}
@end

