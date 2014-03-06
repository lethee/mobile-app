package com.weaveus.lethee.flow;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;

public class NextActivity extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_next);
    }

    public void back(View view) {
    	finish();
    }
}
