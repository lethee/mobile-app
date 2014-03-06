package com.weaveus.lethee.app.webviewex;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends Activity {
	
	final int MENU_ID_CALL = 1;

	WebView webView;

	@SuppressLint("SetJavaScriptEnabled")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		webView = (WebView) findViewById(R.id.webView);
		webView.getSettings().setJavaScriptEnabled(true);
		
		webView.setWebViewClient(new WebViewClient1());
		webView.setWebChromeClient(new WebChromeClient());

		webView.loadUrl("file:///android_asset/index.html");
		webView.addJavascriptInterface(new WebViewObject(), "webViewObject");
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.activity_main, menu);
		menu.add(Menu.NONE, MENU_ID_CALL, Menu.NONE, "Call");
		return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case MENU_ID_CALL:
			webView.loadUrl("javascript:userJavaScriptFunc1('Native Value');");
			return true;
		}
		return super.onOptionsItemSelected(item);
	}

	class WebViewClient1 extends WebViewClient {

		@Override
		public void onPageStarted(WebView view, String url, Bitmap favicon) {
			super.onPageStarted(view, url, favicon);
		}

		@Override
		public void onPageFinished(WebView view, String url) {
			super.onPageFinished(view, url);
		}

		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			return super.shouldOverrideUrlLoading(view, url);
		}
	}

	class WebViewObject {

		public void userFunc1() {
			AlertDialog alert = new AlertDialog.Builder(MainActivity.this).create();
			alert.setTitle("userFunc1");
			alert.setMessage("userFunc1");
			alert.setButton(AlertDialog.BUTTON_NEGATIVE, "OK", new DialogInterface.OnClickListener() {

				@Override
				public void onClick(DialogInterface dialog, int which) {
					dialog.dismiss();
				}
			});
			alert.show();
		}
		
		public void userFunc2(String param) {
			AlertDialog alert = new AlertDialog.Builder(MainActivity.this).create();
			alert.setTitle("userFunc2");
			alert.setMessage(param);
			alert.setButton(AlertDialog.BUTTON_NEGATIVE, "OK", new DialogInterface.OnClickListener() {

				@Override
				public void onClick(DialogInterface dialog, int which) {
					dialog.dismiss();
				}
			});
			alert.show();
		}
	}
}