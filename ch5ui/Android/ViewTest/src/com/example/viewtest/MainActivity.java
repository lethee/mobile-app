package com.example.viewtest;

import android.app.Activity;
import android.graphics.Point;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

public class MainActivity extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }
    
	@Override
    public void onWindowFocusChanged(boolean hasFocus) {
    	super.onWindowFocusChanged(hasFocus);
    	
    	TextView text1 = (TextView)findViewById(R.id.text1);
    	text1.append("\nWidth: " + text1.getWidth());
        
    	TextView text2 = (TextView)findViewById(R.id.text2);
        text2.append("\nWidth: " + text2.getWidth());
        
        TextView text3 = (TextView)findViewById(R.id.text3);
        
        text3.append("\n");
        text3.append("Density: " + getResources().getDisplayMetrics().density);
        text3.append("\n");
        text3.append("DensityDpi: " + getResources().getDisplayMetrics().densityDpi);

        Point screenSize = new Point();
        
        // Android 3.2 이상
        // getWindowManager().getDefaultDisplay().getSize(screenSize);
        
        screenSize.x = getWindowManager().getDefaultDisplay().getWidth();
        screenSize.y = getWindowManager().getDefaultDisplay().getHeight();
        
        text3.append("\n");
        text3.append("ScreenSize: " + screenSize);
        
        Log.i("ViewTest", text3.getParent().getClass().toString());
    }
}
