//
//  VideoPlayer.m
//  Xpress
//
//  Created by Antony Joe Mathew on 3/5/14.
//  Copyright (c) 2014 Antony Joe Mathew, Media Systems Inc. All rights reserved.
//

#import "VideoPlayer.h"


static VideoPlayer *sharedInstance = nil;
@interface VideoPlayer ()
{
   
}
@end

@implementation VideoPlayer
@synthesize mplayer;
+(VideoPlayer *) getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[VideoPlayer alloc] init];
        // Do any other initialisation stuff here
        
    });
    return sharedInstance;
}

-(void)initialisePlayerWithpath:(NSString*)path isLocal:(BOOL)isLocal
{
    
  
    NSLog(@"path----->%@",path);
    NSURL *movieURL   ;
    if (isLocal) {
        movieURL = [NSURL fileURLWithPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:path]];

    }
    else
    {
    
        movieURL = [NSURL URLWithString:path];
  }
    
    mplayer                                = [[ MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    //remove this observer first because it seems this is cause video automatically dismissed.
    [[NSNotificationCenter defaultCenter] removeObserver:mplayer name:MPMoviePlayerPlaybackDidFinishNotification object:mplayer.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:mplayer.moviePlayer];
    UIViewController *vc=(UIViewController*)self.delegate;
    [vc presentMoviePlayerViewControllerAnimated:mplayer];
}
-(void)playVideo:(NSString*)path isLocal:(BOOL)isLocal
{
    if (mplayer)
    {
        UIViewController *vc=(UIViewController*)self.delegate;
         [vc dismissViewControllerAnimated:FALSE completion:nil];
         [[VideoPlayer getInstance] initialisePlayerWithpath:path isLocal:isLocal];
    }
    else
    {
        [[VideoPlayer getInstance] initialisePlayerWithpath:path isLocal:isLocal];
    }
   
}
-(MPMoviePlayerViewController*)getPlayer
{
    return mplayer;
}
-(void)delay
{
 //   UIViewController *vc=(UIViewController*)self.delegate;
    
}
- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] == MPMovieFinishReasonPlaybackError)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        
        // Remove this class from the observers
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.5f];
        
    }
    else if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        // Dismiss the view controller
          UIViewController *vc=(UIViewController*)self.delegate;
        [vc dismissMoviePlayerViewControllerAnimated];
    }
}

@end

