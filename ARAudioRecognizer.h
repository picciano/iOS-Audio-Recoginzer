//
//  ARAudioRecognizer.h
//  Audio Recognizer
//
//  Created by Anthony Picciano on 6/6/13.
//  Copyright (c) 2013 Anthony Picciano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARAudioRecognizerDelegate.h"

#define AR_AUDIO_RECOGNIZER_SENSITIVITY_LOW 0.90f
#define AR_AUDIO_RECOGNIZER_SENSITIVITY_MODERATE 0.70f
#define AR_AUDIO_RECOGNIZER_SENSITIVITY_HIGH 0.50f
#define AR_AUDIO_RECOGNIZER_SENSITIVITY_DEFAULT AR_AUDIO_RECOGNIZER_SENSITIVITY_MODERATE

#define AR_AUDIO_RECOGNIZER_FREQUENCY_LOW 0.1f
#define AR_AUDIO_RECOGNIZER_FREQUENCY_MODERATE 0.03f
#define AR_AUDIO_RECOGNIZER_FREQUENCY_HIGH 0.02f
#define AR_AUDIO_RECOGNIZER_FREQUENCY_DEFAULT AR_AUDIO_RECOGNIZER_FREQUENCY_MODERATE

@interface ARAudioRecognizer : NSObject

@property (nonatomic, weak) id <ARAudioRecognizerDelegate> delegate;
@property (nonatomic, readonly) float sensitivity;
@property (nonatomic, readonly) float frequency;
@property (nonatomic, readonly) float lowPassResults;

- (id)initWithSensitivity:(float)sensitivity frequency:(float)frequency;

@end
