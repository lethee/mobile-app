package com.weaveus.lethee.app.webview;

import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends Activity {
	
	final int MENU_ID_Back = 1;
	final int MENU_ID_Refresh = 2;
	final int MENU_ID_Local = 3;
	final int MENU_ID_Android = 4;
	
	WebView webView;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		webView = (WebView) findViewById(R.id.webView);
		webView.setWebViewClient(new WebViewClient1());
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.addSubMenu(Menu.NONE, MENU_ID_Back, Menu.NONE, "Back");
		menu.addSubMenu(Menu.NONE, MENU_ID_Refresh, Menu.NONE, "Refresh");
		menu.addSubMenu(Menu.NONE, MENU_ID_Local, Menu.NONE, "Local");
		menu.addSubMenu(Menu.NONE, MENU_ID_Android, Menu.NONE, "Android");
		return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case MENU_ID_Back:
			webView.goBack();
			break;
		case MENU_ID_Refresh:
			webView.reload();
			break;
		case MENU_ID_Local:
			webView.loadUrl("file:///android_asset/index.html");
			break;
		case MENU_ID_Android:
			webView.loadUrl("http://www.android.com/");
			break;
		}
		return true;
	}

	class WebViewClient1 extends WebViewClient {
		
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			return super.shouldOverrideUrlLoading(view, url);
		}
		
		@Override
		public void onPageStarted(WebView view, String url, Bitmap favicon) {
			super.onPageStarted(view, url, favicon);
		}
		
		@Override
		public void onPageFinished(WebView view, String url) {
			super.onPageFinished(view, url);
		}
		
		@Override
		public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
			super.onReceivedError(view, errorCode, description, failingUrl);
		}
	}
}
