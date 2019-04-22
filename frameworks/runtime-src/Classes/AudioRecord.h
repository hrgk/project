#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
 
@interface AudioRecord : NSObject<AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    NSString * filePath_;
    float seconds_;
}

/**
 *  获取单例对象
 *
 *  @return 返回数据库对象
 */
+(AudioRecord *)shareAudioRecord;

- (void)setSavePath: (NSString *) path;

- (void)setSeconds: (int) seconds;

/**
 *  将要录音
 *
 *  @return <#return value description#>
 */
- (BOOL)canRecord;

/**
 *  停止录音
 */
- (void)stopRecord;

/**
 *  开始录音
 */
- (void)startRecord:(int) callback;

// 播放声音
- (void) playSound:(NSString *) filePath callback:(int) callback;

/**
 *  初始化音频检查
 */
-(void)initRecordSession;

/**
 *  初始化文件存储路径
 *
 *  @return <#return value description#>
 */
- (NSString *)audioRecordingPath;

/**
 *  录音器
 */
@property (nonatomic, retain) AVAudioRecorder *audioRecorder;

/**
 *  录音播放器
 */
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@end
