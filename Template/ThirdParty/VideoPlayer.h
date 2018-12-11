//
//  VideoPlayer.h
//  Xpress
//
//  Created by Antony Joe Mathew on 3/5/14.
//  Copyright (c) 2014 Antony Joe Mathew, Media Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
 #import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
@protocol VideoPlayerDelegate;
@interface VideoPlayer : NSObject <UIPickerViewDelegate,AVAudioPlayerDelegate> {
    
}

@property (nonatomic, readwrite) NSIndexPath *indexPath;
@property(nonatomic,retain) NSTimer		*updateTimer;
@property(nonatomic,retain) MPMoviePlayerViewController *mplayer ;
- (void)playAudio:(NSString*)path;

+(VideoPlayer *) getInstance;

//-(VideoPlayer *) getPlayer;
@property (nonatomic, assign) id<VideoPlayerDelegate> delegate;
-(void)playVideo:(NSString*)path isLocal:(BOOL)isLocal;
-(MPMoviePlayerViewController*)getPlayer;
@end

