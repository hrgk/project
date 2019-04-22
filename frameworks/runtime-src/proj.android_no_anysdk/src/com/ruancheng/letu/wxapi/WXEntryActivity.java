package com.ruancheng.letu.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.jw.utils.Bridge;
import com.jw.utils.WeChatLoginHelper;

import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendAuth.Resp;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler {

	// IWXAPI 鏄涓夋柟app鍜屽井淇￠�氫俊鐨刼penapi鎺ュ彛
	private IWXAPI api;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		// 閫氳繃WXAPIFactory宸ュ巶锛岃幏鍙朓WXAPI鐨勫疄渚�
		String appID = Bridge.getWeChatAppID();
		api = WXAPIFactory.createWXAPI(this, appID, false);

		api.handleIntent(getIntent(), this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);

		setIntent(intent);
		api.handleIntent(intent, this);
	}

	// 寰俊鍙戦�佽姹傚埌绗笁鏂瑰簲鐢ㄦ椂锛屼細鍥炶皟鍒拌鏂规硶
	@Override
	public void onReq(BaseReq req) {
		switch (req.getType()) {
		case ConstantsAPI.COMMAND_GETMESSAGE_FROM_WX:
			break;
		case ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX:
			break;
		default:
			break;
		}
	}

	// 绗笁鏂瑰簲鐢ㄥ彂閫佸埌寰俊鐨勮姹傚鐞嗗悗鐨勫搷搴旂粨鏋滐紝浼氬洖璋冨埌璇ユ柟娉�
	@Override
	public void onResp(BaseResp resp) {
//		ConstantsAPI.COMMAND_PAY_BY_WX
		if (resp instanceof Resp) {
			WeChatLoginHelper helper = Bridge.getWeChatLoginHelper();
			if (null != helper) {
				helper.sdkOnResp(resp);
			}
		}
		finish();
	}
}
