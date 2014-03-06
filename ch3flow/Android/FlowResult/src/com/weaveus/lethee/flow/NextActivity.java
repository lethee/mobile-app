package com.weaveus.lethee.flow;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

public class NextActivity extends Activity {
	
	TextView textView;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_next);
        
        textView = (TextView)findViewById(R.id.textView1);
    }
    
    @Override
    protected void onResume() {
    	Intent intent = getIntent();
    	String myData = intent.getStringExtra("MyData");
    	
    	textView.setText(myData);
    	
    	super.onResume();
    }

    public void back(View view) {
    	Intent result = new Intent();
    	result.putExtra("MyDataResult", "액티비티 2 데이터");
    	setResult(RESULT_FIRST_USER, result);
    	
    	finish();
    }
}
