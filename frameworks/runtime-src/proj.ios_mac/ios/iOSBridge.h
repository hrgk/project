#import <Foundation/Foundation.h>
@interface iOSBridge : NSObject  

+(NSString *) getDeviceName;

+(NSString *) getDeviceVersion;

+(NSString *) getNativeInfo:(NSDictionary *) params;

+(void) deviceVibrate;

+(float) getBatteryInfo;

// 向keychain里写入数据
+(BOOL) setDataInKeyChain:(NSDictionary *) params;

// 从keychain中获取数据
+(NSString *) getDataInKeyChain:(NSDictionary *) params;

+(void) initWeChat:(NSDictionary *) params;

// 发送文字到微信
+ (BOOL) sendTextToWeiChat:(NSDictionary *) params;

// 发送链接到微信
+ (BOOL) sendLinkURLToWeChat:(NSDictionary *) params;

// 发送图片分享到微信
+ (void)sendImageToWeChat:(NSDictionary *) params;

+(void) copyToPasteBoard:(NSDictionary *) params;

// 初始化录音机制
+(void) initRecorder:(NSDictionary *) params;

// 开始录音
+(void) startRecorder:(NSDictionary *) params;

// 停止录音
+(void) stopRecorder:(NSDictionary *) params;

// 播放声音
+(void) playSound:(NSDictionary *) params;

// 获得定位
+(void ) getLocation:(NSDictionary *) params;

+(void) enterApp:(NSDictionary *)params;

+(void) getLocationString:(NSDictionary *) params;

@end
