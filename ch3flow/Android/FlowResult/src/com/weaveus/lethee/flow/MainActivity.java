package com.weaveus.lethee.flow;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

public class MainActivity extends Activity {
	
	final int REQUEST_CODE_FOR_NEXT = 1;
	
	TextView textView;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        textView = (TextView)findViewById(R.id.textView1);
    }
    
    public void showNextActivity(View view) {
    	Intent intent = new Intent(this, NextActivity.class);
    	intent.putExtra("MyData", "액티비티 1 데이터");
    	
    	startActivityForResult(intent, REQUEST_CODE_FOR_NEXT);
    }
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    	if (requestCode == REQUEST_CODE_FOR_NEXT) {
    		String myData = data.getStringExtra("MyDataResult");
        	
        	textView.setText(myData);
    	}
    }
}
