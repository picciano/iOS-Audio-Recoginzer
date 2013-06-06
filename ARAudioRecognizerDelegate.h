//
//  ARAudioRecognizerDelegate.h
//  Audio Recognizer
//
//  Created by Anthony Picciano on 6/6/13.
//  Copyright (c) 2013 Anthony Picciano. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARAudioRecognizer;

@protocol ARAudioRecognizerDelegate <NSObject>

@required
- (void)audioRecognized:(ARAudioRecognizer *)recognizer;

@optional
- (void)audioLevelUpdated:(ARAudioRecognizer *)recognizer level:(float)lowPassResults;
- (void)audioLevelUpdated:(ARAudioRecognizer *)recognizer averagePower:(float)averagePower peakPower:(float)peakPower;

@end
