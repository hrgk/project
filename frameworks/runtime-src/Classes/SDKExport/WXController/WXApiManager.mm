//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "CCLuaBridge.h"

#import "WXApiManager.h"

@implementation WXApiManager {
    int wxCallBackHandler;
    int wxAuthCallBackHandler;
    int wxShareCallBackHandler;
}

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
        cocos2d::LuaValueDict item;
        int errCode =resp.errCode;
        NSString *strCode = @"-1";
        if (errCode == 0){
            strCode = @"0";
        }
        cocos2d::LuaBridge::pushLuaFunctionById(wxShareCallBackHandler);
        cocos2d::LuaBridge::getStack()->pushString([strCode UTF8String]);
        cocos2d::LuaBridge::getStack()->executeFunction(1);
        cocos2d::LuaBridge::releaseLuaFunctionById(wxShareCallBackHandler);
        wxShareCallBackHandler = -1;
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            [_delegate managerDidRecvAuthResponse:authResp];
        }
        if (wxAuthCallBackHandler > 0) {  //回调lua的函数
            cocos2d::LuaValueDict item;
            item["errStr"] = cocos2d::LuaValue::stringValue([resp.errStr UTF8String]);
            item["errCode"] = cocos2d::LuaValue::intValue(resp.errCode);
            item["code"] = cocos2d::LuaValue::stringValue([authResp.code UTF8String]);
            
            cocos2d::LuaBridge::pushLuaFunctionById(wxAuthCallBackHandler);
            cocos2d::LuaBridge::getStack()->pushLuaValueDict(item);
            cocos2d::LuaBridge::getStack()->executeFunction(1);
            cocos2d::LuaBridge::releaseLuaFunctionById(wxAuthCallBackHandler);
            wxAuthCallBackHandler = -1;
        }
        NSLog(@"微信授权返回，retcode = %d", resp.errCode);
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        if (wxCallBackHandler > 0) {  //如果注册了LUA回调，则调用LUA回调，否则调用默认的处理
            cocos2d::LuaValueDict item;
            item["errStr"] = cocos2d::LuaValue::stringValue([resp.errStr UTF8String]);
            item["errCode"] = cocos2d::LuaValue::intValue(resp.errCode);
            
            cocos2d::LuaBridge::pushLuaFunctionById(wxCallBackHandler);
            cocos2d::LuaBridge::getStack()->pushLuaValueDict(item);
            cocos2d::LuaBridge::getStack()->executeFunction(1);
            cocos2d::LuaBridge::releaseLuaFunctionById(wxCallBackHandler);
            wxCallBackHandler = -1;
        } else {
            NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
            
            switch (resp.errCode) {
                case WXSuccess:
                    strMsg = @"支付结果：成功！";
                    NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                    break;
                    
                default:
                    strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                    NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                    break;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }

}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

- (void)setPaymentCallbackHandler:(int) handler {
    if (handler <= 0) {
        return;
    }
    if (wxCallBackHandler > 0) {
        cocos2d::LuaBridge::releaseLuaFunctionById(wxCallBackHandler);
    }
    wxCallBackHandler = handler;
}

- (void)setAuthCallbackHandler:(int) handler {
    if (handler <= 0) {
        return;
    }
    if (wxAuthCallBackHandler > 0) {
        cocos2d::LuaBridge::releaseLuaFunctionById(wxAuthCallBackHandler);
    }
    wxAuthCallBackHandler = handler;
}

- (void)setShareCallbackHandler:(int) handler {
    if (handler <= 0) {
        return;
    }
    if (wxShareCallBackHandler > 0) {
        cocos2d::LuaBridge::releaseLuaFunctionById(wxShareCallBackHandler);
    }
    wxShareCallBackHandler = handler;
}

@end
