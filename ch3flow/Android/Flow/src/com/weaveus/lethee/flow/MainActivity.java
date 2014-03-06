package com.weaveus.lethee.flow;

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
    
    public void showNextActivity(View view) {
    	Intent intent = new Intent(this, NextActivity.class);
    	startActivity(intent);
    }
}
