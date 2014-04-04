//
//  ARAudioRecognizer.m
//  Audio Recognizer
//
//  Created by Anthony Picciano on 6/6/13.
//  Copyright (c) 2013 Anthony Picciano. All rights reserved.
//

#import "ARAudioRecognizer.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface ARAudioRecognizer ()

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *levelTimer;

- (void)initializeRecorder;
- (void)initializeLevelTimer;

@end

@implementation ARAudioRecognizer

@synthesize delegate = _delegate;
@synthesize sensitivity = _sensitivity, frequency = _frequency, lowPassResults = _lowPassResults;

- (id)init
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    return [self initWithSensitivity:AR_AUDIO_RECOGNIZER_SENSITIVITY_DEFAULT
                           frequency:AR_AUDIO_RECOGNIZER_FREQUENCY_DEFAULT];
}

- (id)initWithSensitivity:(float)sensitivity frequency:(float)frequency
{
    if (self = [super init]) {
        _sensitivity = sensitivity;
        _frequency = frequency;
        _lowPassResults = 0.0f;
    }
    
    [self initializeRecorder];
    [self initializeLevelTimer];
    
    return self;
}

- (void)initializeRecorder
{
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
  	NSError *error;
    
  	self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
  	if (self.recorder) {
  		[self.recorder prepareToRecord];
  		[self.recorder setMeteringEnabled:YES];
  		[self.recorder record];
  	} else
  		NSLog(@"Error in initializeRecorder: %@", [error description]);
}

- (void)initializeLevelTimer
{
    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
}

- (void)levelTimerCallback:(NSTimer *)timer
{
	[self.recorder updateMeters];
    
	const double ALPHA = 0.1;
	double peakPowerForChannel = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
	_lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * self.lowPassResults;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioLevelUpdated:level:)]) {
        [self.delegate audioLevelUpdated:self level:self.lowPassResults];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioLevelUpdated:averagePower:peakPower:)]) {
        [self.delegate audioLevelUpdated:self averagePower:[self.recorder averagePowerForChannel:0] peakPower:[self.recorder peakPowerForChannel:0]];
    }
    
	if (self.lowPassResults > 0.95 && self.delegate && [self.delegate respondsToSelector:@selector(audioRecognized:)]) {
        [self.delegate audioRecognized:self];
        _lowPassResults = 0.0f;
    }
}

@end
