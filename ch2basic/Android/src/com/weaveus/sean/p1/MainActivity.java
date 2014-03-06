package com.weaveus.sean.p1;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.EditText;

public class MainActivity extends Activity {

	// Life Cycles ////////////////////////////

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		show(null);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.activity_main, menu);
		return true;
	}

	// Event Handles //////////////////////////

	public void show(View v) {
		GreetModel model = new GreetModel();
		model.setContent("World");

		renderModel(model);
	}

	public void clear(View v) {
		renderModel(null);
	}

	// Render Model into View /////////////////

	void renderModel(GreetModel model) {
		EditText target = (EditText) findViewById(R.id.editText_ModelPlaceholder);

		if (model != null) {
			String text = String.format("Hello, %s!", model.content);
			target.setText(text);
		} else {
			target.setText(null);
		}
	}
}