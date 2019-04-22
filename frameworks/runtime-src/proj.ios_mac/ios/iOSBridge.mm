#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "iOSBridge.h"
#import "KeychainItemWrapper.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"
#import "WXMediaMessage+messageConstruct.h"
#import "AppController.h"
#import "AudioRecord.h"

#import "cocos2d.h"
#import "CCLuaEngine.h"
#import "CCLuaBridge.h"
#import "RootViewController.h"

@implementation iOSBridge

+(NSString *) getDeviceName {
  return [[UIDevice currentDevice] name];
}

+(NSString *) getDeviceVersion {
  return [UIDevice currentDevice].systemVersion;
}

+(float) getBatteryInfo {
    UIDevice.currentDevice.batteryMonitoringEnabled = YES;
    float level = [UIDevice currentDevice].batteryLevel;
    UIDevice.currentDevice.batteryMonitoringEnabled = NO;
    return level * 100;
}

+(NSString *) getNativeInfo:(NSDictionary *) params {
    NSString * key_name = [params objectForKey:@"key"];
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:key_name];
}

+(void)deviceVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+(BOOL) setDataInKeyChain:(NSDictionary *) params {
    NSString * key = [params objectForKey:@"key"];
    NSString * value = [params objectForKey:@"value"];
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:key accessGroup:nil];
    [wrapper setObject:value forKey:(id)kSecAttrAccount];
    [wrapper release];
    return YES;
}

+(NSString *) getDataInKeyChain:(NSDictionary *) params {
    NSString * key = [params objectForKey:@"key"];
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:key accessGroup:nil];
    NSString * data = [wrapper objectForKey:(id)kSecAttrAccount];
    [wrapper release];
    return data;
}

+(void) initWeChat:(NSDictionary *) params {
    NSString * app_id = [params objectForKey:@"app_id"];
    NSString * app_name = [params objectForKey:@"app_name"];
    [WXApi registerApp:app_id withDescription:app_name];
}

// 调用微信分享文字
+ (BOOL)sendTextToWeiChat:(NSDictionary *) params {
    enum WXScene scene;
    NSString * text             = [params objectForKey:@"text"];
    NSMutableString *inScene    = [params objectForKey:@"inScene"];
    int inSceneInt              = inScene.intValue;
    if (inSceneInt == 0) {  // 0 聊天 1 朋友圈
        scene = WXSceneSession;
    } else {
        scene = WXSceneTimeline;
    }
    scene     = WXSceneSession; // WXSceneSession;
    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:text
                                                   OrMediaMessage:nil
                                                            bText:YES
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

//图片压缩
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContext(size);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();

    if(newImage == nil){
        NSLog(@"scale image fail");
    }

    UIGraphicsEndImageContext();

    return newImage;

}

// 调用微信分享链接
+ (BOOL)sendLinkURLToWeChat:(NSDictionary *) params {
    enum WXScene scene;
    NSString * urlString = [params objectForKey:@"url"];
    NSString * tagName = [params objectForKey:@"tagName"];
    NSString * title = [params objectForKey:@"title"];
    NSString * description = [params objectForKey:@"description"];
    NSString * imagePath = [params objectForKey:@"imagePath"];
    NSMutableString *inScene    = [params objectForKey:@"inScene"];
    int inSceneInt              = inScene.intValue;
    NSMutableString *handler    = [params objectForKey:@"callfunc"];
    int callback = 0;
    if (nil != handler) {
        callback = handler.intValue;
    }
    [[WXApiManager sharedManager] setShareCallbackHandler:callback];
    if (inSceneInt == 0) {  // 0 聊天 1 朋友圈
        scene = WXSceneSession;
    } else {
        scene = WXSceneTimeline;
    }

    UIImage *thumbImage = [UIImage imageNamed:imagePath];

//    thumbImage  = [self imageCompressForSize:im targetSize:nSize];

    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:thumbImage
                                                      MediaTag:tagName];
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

+(UIImage *)scaleImage:(UIImage *)sourceImage ToSize:(CGSize)itemSize {
    UIImage *image;
    //    CGSize itemSize=CGSizeMake(30, 30);
//    UIGraphicsBeginImageContext(itemSize);
//    CGRect imageRect=CGRectMake(0, 0, itemSize.width, itemSize.height);
//    [img drawInRect:imageRect];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = itemSize.width;
    CGFloat targetHeight = itemSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, itemSize) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContext(itemSize);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();

    if(newImage == nil){
        NSLog(@"scale image fail");
    }

    UIGraphicsEndImageContext();

    return newImage;
}

// 分享图片到微信
+ (void)sendImageToWeChat:(NSDictionary *) params {
    NSString * tagName = [params objectForKey:@"tagName"];
    NSString * messageExt = [params objectForKey:@"description"];
    NSString * imagePath = [params objectForKey:@"imagePath"];
    NSMutableString *inScene    = [params objectForKey:@"inScene"];
    CGFloat bigWidth = [[params objectForKey:@"bigWidth"] floatValue];
    CGFloat bigHeight = [[params objectForKey:@"bigHeight"] floatValue];
    
    int inSceneInt              = inScene.intValue;
    enum WXScene scene;
    if (inSceneInt == 0) {  // 0 聊天 1 朋友圈
        scene = WXSceneSession;
    } else {
        scene = WXSceneTimeline;
    }
    
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage imageNamed:imagePath];

    CGSize size = image.size;
    float destWidth = 150.0;
    float scale = size.width / destWidth;
    float destHeight = size.height / scale;
    CGSize itemSize = CGSizeMake(destWidth, destHeight);
    CGSize bigitemSize = CGSizeMake(bigWidth, bigHeight);
    UIImage * thumbImage = [self scaleImage:image ToSize:itemSize];
    UIImage * bigImage = [self scaleImage:image ToSize:bigitemSize];
    imageData =   UIImageJPEGRepresentation(bigImage, 0.6);

//    thumbImage = [UIImage imageWithData:imageData];

    NSString * action = [NSString stringWithUTF8String:""];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = imageData;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:nil
                                                   Description:nil
                                                        Object:ext
                                                    MessageExt:messageExt
                                                 MessageAction:action
                                                    ThumbImage:thumbImage
                                                      MediaTag:tagName];
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    
    [WXApi sendReq:req];
}

+(BOOL) startWeChatAuth:(NSDictionary *) params {
    NSString * scope = [params objectForKey:@"authScope"];
    NSString * openID = [params objectForKey:@"authOpenID"];
    NSString * state = [params objectForKey:@"authState"];
    
    NSMutableString *handler    = [params objectForKey:@"callback"];
    int callback = handler.intValue;
    [[WXApiManager sharedManager] setAuthCallbackHandler:callback];
    
    SendAuthReq* req = [[[SendAuthReq alloc] init] autorelease];
    req.scope = scope;
    req.state = state;
    req.openID = openID;
    
    return [WXApi sendAuthReq:req
               viewController:[UIApplication sharedApplication].keyWindow.rootViewController
                     delegate:[WXApiManager sharedManager]];
}

// 复制内容到剪切版
+(void) copyToPasteBoard:(NSDictionary *) params {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [params objectForKey:@"content"];
}

// 初始化录音机制
+(void) initRecorder:(NSDictionary *) params {
    NSString * savePath = [params objectForKey:@"savePath"];
    NSMutableString *seconds_string    = [params objectForKey:@"seconds"];
    int seconds = seconds_string.intValue;
    [[AudioRecord shareAudioRecord] setSavePath:savePath];
    [[AudioRecord shareAudioRecord] setSeconds:seconds];
}

// 开始录音
+(void) startRecorder:(NSDictionary *) params {
    NSMutableString *handler = [params objectForKey:@"callback"];
    int callback = handler.intValue;
    [[AudioRecord shareAudioRecord] startRecord: callback];
}

// 停止录音
+(void) stopRecorder:(NSDictionary *) params {
    [[AudioRecord shareAudioRecord] stopRecord];
}

// 播放声音
+(void) playSound:(NSDictionary *) params {
    NSString * filePath = [params objectForKey:@"filePath"];
    NSMutableString *handler = [params objectForKey:@"callback"];
    int callback = handler.intValue;
    [[AudioRecord shareAudioRecord] playSound:filePath callback:callback];
}

// 获得定位
+(void) getLocation:(NSDictionary *) params
{
    NSMutableString *handler    = [params objectForKey:@"callback"];
    int callback = handler.intValue;
    RootViewController *rootView =[UIApplication sharedApplication].keyWindow.rootViewController;
    rootView.callback = callback;
    [rootView startLocation];
}

+(void) enterApp:(NSDictionary *)params
{
    NSString *toString = [NSString stringWithFormat:@"%@://", [params objectForKey:@"enterName"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:toString]];
}

// 获得定位
+(void) getLocationString:(NSDictionary *) params
{
    double latitude = [[params objectForKey:@"latitude"] doubleValue];
    double longitude = [[params objectForKey:@"longitude"] doubleValue];
    NSMutableString *handler    = [params objectForKey:@"callback"];
    int callback = handler.intValue;
    CLLocation *currLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);

    //根据经纬度反向地理编译出地址信息
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];

    [geoCoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {

        for (CLPlacemark * placemark in placemarks) {

            NSDictionary *address = [placemark addressDictionary];

            //  Country(国家)  State(省)  City（市）
            NSLog(@"#####%@",address);

            NSLog(@"%@", [address objectForKey:@"Country"]);

            NSLog(@"%@", [address objectForKey:@"State"]);

            NSLog(@"%@", [address objectForKey:@"City"]);

            NSString *nsret = [NSString stringWithFormat:@"%@ %@ %@",[address objectForKey:@"Country"],[address objectForKey:@"State"],[address objectForKey:@"City"]];
            std::string *bar = new std::string([nsret UTF8String]);
            cocos2d::LuaValue ret =cocos2d::LuaValue::stringValue(*bar);
            cocos2d::LuaBridge::pushLuaFunctionById(callback);
            cocos2d::LuaBridge::getStack()->pushLuaValue(ret);
            cocos2d::LuaBridge::getStack()->executeFunction(1);
            cocos2d::LuaBridge::releaseLuaFunctionById(callback);

        }

    }];
}

@end

