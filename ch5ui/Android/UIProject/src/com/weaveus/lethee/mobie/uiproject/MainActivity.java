package com.weaveus.lethee.mobie.uiproject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

public class MainActivity extends Activity {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
	}

	public void onClickButtonViewBasic(View view) {
		Intent next = new Intent(this, BasicViewActivity.class);
		startActivity(next);
	}

	public void onClickButtonWeight(View view) {
		Intent next = new Intent(this, CustomActivity.class);
		next.putExtra("layout", R.layout.activity_weight_gravity);
		startActivity(next);
	}

	public void onClickButtonCommonControl(View view) {
		Intent next = new Intent(this, RelativeLayoutActivity.class);
		startActivity(next);
	}

	public void onClickButton(View view) {
		if ("CodeLayout".equals(view.getTag())) {
			Intent next = new Intent(this, CodeLayoutActivity.class);
			startActivity(next);
		}
	}
}