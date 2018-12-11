//
//  WebServiceCall.m
//  ASI
//
//  Created by Antony Joe Mathew on 11/16/13.
//  Copyright (c) 2013 MSI. All rights reserved.
//

#import "NetworkLayer.h"
#import <dispatch/dispatch.h>
#import <malloc/malloc.h>
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "URLConstants.h"
#import "CommonFunction.h"
#import "Reachability.h"
static int FailAttempt= 5;

static NetworkLayer *sharedInstance = nil;
@interface NetworkLayer() {
    AppDelegate *appdelegate;
}
 - (BOOL)connected;
@end



@implementation NetworkLayer

- (id)init
{
    self = [super init];
    if (self) {
        appdelegate= (id)[[UIApplication sharedApplication] delegate];
     }
    return self;
}


+(NetworkLayer *) getInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}



- (BOOL)connected
{
    return TRUE;
}

- (BOOL)isConnectedToInternet
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)postWebserviceResponseForparams:(NSDictionary*)params andUrl:(NSString*)urlString Counter:(int)failCounter Completion:(void (^)(BOOL success,id responseObject, NSError *error))completion
{
    
    if (![self isConnectedToInternet])
    {
        NSError *error = [CommonFunction errorFromErrormessage:[CommonFunction localizedString:@"No Active Internet"]];
        completion(FALSE,nil,error);
        
        return;
    }
    
    int fCounter=failCounter;
    fCounter++;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:AuthenticationUserName password:AuthenticationPassword];
    //  AFHTTPRequestOperation *post=
    
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(TRUE,responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fCounter<FailAttempt)
        {
            [self postWebserviceResponseForparams:params andUrl:urlString Counter:fCounter Completion:^(BOOL success, id responseObject, NSError *error1) {
                completion(success,responseObject,error1);
            }];
        }
        else
        {
            NSLog(@"error %@ url %@ params %@",error,urlString,params);
            NSError *errNodata =[CommonFunction errorFromErrormessage:[CommonFunction localizedString:@"No Data Found"]];// [CommonFunction errorFromErrormessage:[CommonFunction localizedString:@"No Data Found"] andTag:kCodeNoData];
            
            completion(FALSE,nil,errNodata);
            
        }
        
    }];
    
    
    
}

#pragma mark - Base Webservice Method
- (void)postWebserviceResponseForparams:(NSDictionary*)params andUrl:(NSString*)urlString Completion:(void (^)(BOOL success,id responseObject, NSError *error))completion{
    
    [self postWebserviceResponseForparams:params andUrl:urlString Counter:0 Completion:^(BOOL success, id responseObject, NSError *error)
     {
         completion(success,responseObject,error);
         
     }];
    
    
    
}


- (void)getWebserviceResponseForparams:(NSDictionary*)params andUrl:(NSString*)urlString Completion:(void (^)(BOOL success,id responseObject, NSError *error))completion{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    /* [manager.requestSerializer setValue:[self getCookeeValue] forHTTPHeaderField:@"Cookie"];
     [manager.requestSerializer setValue:[self getTokenValue] forHTTPHeaderField:@"X-CSRF-Token"];
     
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     */
    // manager.responseSerializer = [AFHTTPSessionManager serializer];
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(TRUE,responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completion(FALSE,nil,error);
        
    }];
    
    
}


-(void)showNoInternetAlert
{
  
   /* CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initWithMessage:NSLocalizedString(@"Please check your internet connection !!",@"")];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:[CommonFunction localizedString:@"OK"], nil]];
    [alertView setDelegate:nil];
    // alertView.tag=12;
    [alertView show];*/
}

#pragma -mark-UPLOADIN IMAGE/VIDEO OF FALCON

/*
 - (void)uploadMediaOffalcon:(Falcon*)falconObj  Completion:(void (^)(BOOL success,id responseObject, NSError *error))completion
{
    
     NSMutableArray *medias = [NSKeyedUnarchiver unarchiveObjectWithData:falconObj.mediaFiles];
     NSMutableArray *mutableOperations = [NSMutableArray array];
    
    
    for (id obj in medias)
    {
        NSDictionary *params;
        NSURL *fileURL =[NSURL fileURLWithPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[obj valueForKey:@"path"]]];
        ;
        NSLog(@"  --->%@",[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[obj valueForKey:@"path"]]);

          if ([[obj valueForKey:@"type"] isEqualToString:@"V"])
         {
             params=[NSDictionary dictionaryWithObjectsAndKeys:falconObj.responseID,@"Id",@"Video",@"MediaType", nil];
         }
        else
        {
            params=[NSDictionary dictionaryWithObjectsAndKeys:falconObj.responseID,@"Id",@"Picture",@"MediaType", nil];

        }
        
        NSError *er;
        NSURLRequest *request=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@/api/APIMedia/PostFormData",BaseURLString] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileURL:fileURL name:[obj valueForKey:@"path"] error:nil];
            
            
        } error:&er];
        NSLog(@" %@\n --->%@",params,[NSString stringWithFormat:@"%@/api/APIMedia/PostFormData",BaseURLString]);

        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        NSURLCredential *credential = [NSURLCredential  credentialWithUser:[CommonFunction getValueForkeyAfterDecoding:EmailKey] password:[CommonFunction getValueForkeyAfterDecoding:Password] persistence:NSURLCredentialPersistenceForSession];
     //  [operation setCredential:credential];
        
        [mutableOperations addObject:operation];
        
    }
    
     NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"%lu of %lu complete", numberOfFinishedOperations, totalNumberOfOperations);
    } completionBlock:^(NSArray *operations)
    {
       completion(TRUE,nil,nil);
        NSLog(@"All operations in batch complete");
    } ];
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
    
}*/
- (void)RegisteringPNToken
{
 
    NSString *deviceUuid =@"";//"";
    NSString *token=[[NSUserDefaults standardUserDefaults] valueForKey:pushNotificationToken];
 
    if (![token isKindOfClass:[NSString class]]) {
        return;
    }
 
    
    
     NSDictionary *parameters1 = @{@"token": token,@"device_type":@"iphone",@"device_id":deviceUuid};
    
    [self postWebserviceResponseForparams:parameters1 andUrl:@"http://demo.nasst.ae/pushapp/app/api/RegisterDevice.json" Completion:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            /*  {
             error = 0;
             group = user;
             message = "Successfully registered!";
             uid = 109;
             }
             */
            NSLog(@"RegisteringToken JSON: %@", responseObject);
            
            if ([[responseObject valueForKey:@"error"] intValue]==0)
            {
                
                [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:isPushTokenChanged];
                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:pushRegisterd];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                //                                                                message:[responseObject valueForKey:@"message"]
                //                                                               delegate:nil
                //                                                      cancelButtonTitle:@"Ok"
                //                                                      otherButtonTitles:nil];
                // [alertView show];
                
            }
            else
            {
                
                //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                //                                                                message:[responseObject valueForKey:@"message"]
                //                                                               delegate:nil
                //                                                      cancelButtonTitle:@"Ok"
                //                                                      otherButtonTitles:nil];
                //  [alertView show];
                
            }
        }
        
    }];
    
 
}




#pragma -RegisterWS
- (void)registerWithparams:(NSDictionary*)params Completion:(void (^)(BOOL success,id responseObject, NSError *error))completion{
    
   /*
    NSData *data= [[operation responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    
    id responseObj=[[NSJSONSerialization JSONObjectWithData:data
                                                    options:0
                                                      error:&error] mutableCopy];

    
   */
    
    
}

#pragma -RegisterWS
- (void)loginWithParams:(NSDictionary*)params Completion:(void (^)(BOOL success,id responseObject, NSError *error))completion{
    
    
    completion(TRUE,nil,nil);
    return;
    
 
    
    
}
- (void)downloaSqliteToPath:(NSString *)filePath withServerURL:(NSString *)serverURL withCompletion:(void (^)(BOOL completed, NSURL *source_url, NSError *error))completion
{
    
    
     NSURL *storeURL1                         = [[self applicationDocumentsDirectory]
                                                URLByAppendingPathComponent:filePath];
    if ([NSData dataWithContentsOfURL:storeURL1]) {
        
        [[NSFileManager defaultManager] removeItemAtURL:storeURL1 error:nil];
        
        
    }
    
    
    filePath = [storeURL1 absoluteString];
    NSURLRequest *request;
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"111"];
    //NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    
    NSURLSessionDownloadTask *downloadTask= [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress){
        
        float progres = downloadProgress.fractionCompleted;
        NSLog(@"progres--->%f",progres);
        
    }destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return storeURL1;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath_url, NSError *error) {
        
        
   
        
   
        
        
        
        completion(true,filePath_url,nil);
    }];
    
    [downloadTask resume];
    
    
}
- (NSURL *)applicationDocumentsDirectory
{
 return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
 }

 @end
