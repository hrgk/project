//
//  AudioRecord.m
//  audio

#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "CCLuaBridge.h"
#import "AudioRecord.h"

@implementation AudioRecord : NSObject

static int recoderHandler_ = 0;

+(AudioRecord *)shareAudioRecord {
    static AudioRecord *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (void)setSavePath: (NSString *) path {
    filePath_ = path;
    [filePath_ retain];
}

- (void)setSeconds: (int) seconds {
    seconds_ = (float)seconds;
}

/**
 *  设置录制的音频文件的位置
 *
 *  @return <#return value description#>
 */
- (NSString *) audioRecordingPath {
    return filePath_;
}

/**
 *  在初始化AVAudioRecord实例之前，需要进行基本的录音设置
 *
 *  @return <#return value description#>
 */
- (NSDictionary *) audioRecordingSettings {
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithFloat:22050], AVSampleRateKey ,    //采样率 8000/44100/96000/22050
                              [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,  //录音格式
                              [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,   //线性采样位数  8、16、24、32
                              [NSNumber numberWithInt:1], AVNumberOfChannelsKey,      //声道 1，2
                              [NSNumber numberWithInt:AVAudioQualityLow], AVEncoderAudioQualityKey, //录音质量
                              nil];
    return (settings);
}

-(void) resetRecorder {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryAmbient error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [session setActive:YES error:nil];
}

/**
 *  停止音频的录制
 *
 *  @param recorder <#recorder description#>
 */
- (void)stopRecordingOnAudioRecorder:(AVAudioRecorder *)recorder{
    [self resetRecorder];
    [recorder stop];
}

- (void) callRecorderLuaCallback:(int) flag progress: (int) progress release: (BOOL) release {
    if (recoderHandler_ <= 0) {
        NSLog(@"没有设置录音的回调函数！");
        return;
    }
    
    cocos2d::LuaValueDict item;
    item["flag"] = cocos2d::LuaValue::intValue(flag);
    item["progress"] = cocos2d::LuaValue::intValue(progress);
    
    cocos2d::LuaBridge::pushLuaFunctionById(recoderHandler_);
    cocos2d::LuaBridge::getStack()->pushLuaValueDict(item);
    cocos2d::LuaBridge::getStack()->executeFunction(1);
    if (release) {
        cocos2d::LuaBridge::releaseLuaFunctionById(recoderHandler_);
    }
//    cocos2d::LuaBridge::getStack()->removeScriptHandler(recoderHandler_);
}

/**
 *  @param recorder <#recorder description#>
 *  @param flag     <#flag description#>
 */
- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag == YES) {
        NSLog(@"录音完成！");
        [self callRecorderLuaCallback: 1 progress: 1 release: YES];
    } else {
        NSLog(@"录音过程意外终止！");
        [self callRecorderLuaCallback: -1 progress: 1 release: YES];
    }
    self.audioRecorder = nil;
}

- (void) callPlaySoundLuaCallback:(int) callback flag: (int) flag duration: (double)duration {
    if (callback <= 0) {
        NSLog(@"没有设置播放的回调函数！");
        return;
    }
    
    cocos2d::LuaValueDict item;
    item["flag"] = cocos2d::LuaValue::intValue(flag);
    item["duration"] = cocos2d::LuaValue::intValue(int(duration * 1000));
    
    cocos2d::LuaBridge::pushLuaFunctionById(callback);
    cocos2d::LuaBridge::getStack()->pushLuaValueDict(item);
    cocos2d::LuaBridge::getStack()->executeFunction(1);
    cocos2d::LuaBridge::releaseLuaFunctionById(callback);
}

- (void) playSound:(NSString *) filePath callback:(int) callback {
    NSError *playbackError = nil;
    NSError *readingError = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMapped error:&readingError];
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&playbackError];
    
    self.audioPlayer = newPlayer;
    if (self.audioPlayer != nil) {
        self.audioPlayer.delegate = self;
        if ([self.audioPlayer prepareToPlay] == YES &&
            [self.audioPlayer play] == YES) {
            NSLog(@"开始播放音频！");
            [self callPlaySoundLuaCallback: callback flag: 1 duration: newPlayer.duration];
        } else {
            NSLog(@"不能播放音频！");
            [self callPlaySoundLuaCallback: callback flag: -2 duration: 0];
        }
    } else {
        NSLog(@"播放失败！");
        [self callPlaySoundLuaCallback: callback flag: -1 duration: 0];
    }
}

/**
 *  初始化音频检查
 */
-(void)initRecordSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
}

- (void)setRecorderHandler:(int) handler {
    if (handler <= 0) {
        return;
    }
    if (recoderHandler_ > 0) {
        cocos2d::LuaBridge::releaseLuaFunctionById(recoderHandler_);
    }
    recoderHandler_ = handler;
}


/**
 *  开始录音
 */
- (void)startRecord:(int) callback {
    /**
     *  检查权限
     */
    [self setRecorderHandler: callback];
    if (![self canRecord]) {
        return [self callRecorderLuaCallback: -1 progress: 0 release: YES];
    }
    
    [self initRecordSession];
    NSError *error = nil;
    NSString *pathOfRecordingFile = [self audioRecordingPath];
    NSURL *audioRecordingUrl = [NSURL fileURLWithPath:pathOfRecordingFile];
    AVAudioRecorder *newRecorder = [[AVAudioRecorder alloc]
                                    initWithURL:audioRecordingUrl
                                    settings:[self audioRecordingSettings]
                                    error:&error];
    self.audioRecorder = newRecorder;
    if (self.audioRecorder != nil) {
        self.audioRecorder.delegate = self;
        if([self.audioRecorder prepareToRecord] == NO) {
            return [self callRecorderLuaCallback: -3 progress: 0 release: YES];
        }
        
        if ([self.audioRecorder record] == YES) {
            
            NSLog(@"录音开始！");
            [self performSelector:@selector(stopRecordingOnAudioRecorder:)
                       withObject:self.audioRecorder
                       afterDelay:seconds_];
            return [self callRecorderLuaCallback: 1 progress: 0 release: NO];
        } else {
            NSLog(@"录音失败！");
            self.audioRecorder =nil;
            return [self callRecorderLuaCallback: -5 progress: 0 release: YES];
        }
    } else {
        NSLog(@"auioRecorder实例录音器失败！");
        return [self callRecorderLuaCallback: -4 progress: 0 release: YES];
    }
}

/**
 *  停止录音
 */
- (void)stopRecord {
    [self resetRecorder];
    if (self.audioRecorder != nil) {
        if ([self.audioRecorder isRecording] == YES) {
            [self.audioRecorder stop];
        }
        self.audioRecorder = nil;
    }

    if (self.audioPlayer != nil) {
        if ([self.audioPlayer isPlaying] == YES) {
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
    }
}

/**
 *  将要录音
 *
 *  @return boolean
 */
- (BOOL)canRecord {
    __block BOOL bCanRecord = NO;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            } else {
                bCanRecord = NO;
            }
        }];
    }
    return bCanRecord;
}

@end
