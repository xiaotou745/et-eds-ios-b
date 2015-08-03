//
//  AppAudioPlayer.m
//  EtaoshiHotelCenter
//
//  Created by WangShengFeng on 13-6-28.
//  Copyright (c) 2013年 etaoshi. All rights reserved.
//

#import "AppAudioPlayer.h"

@implementation AppAudioPlayer

- (id)initSystemShake
{
    self = [super init];
    if (self) {
        systemSoundID = kSystemSoundID_Vibrate;//震动
    }
    return self;
}

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType
{
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&systemSoundID);
            
            if (error != kAudioServicesNoError) {
                systemSoundID = 0;
            }
        }
    }
    return self;
}

- (void)play
{
    AudioServicesPlaySystemSound(systemSoundID);
}
#pragma mark  PLAY type
-(id)initWithSystemMessageReceivedType{
    return [self initSystemSoundWithName:@"sms-received1" SoundType:@"caf"];
}
@end
