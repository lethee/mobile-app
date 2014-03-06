package com.weaveus.lethee.android.map.openapi.sampleapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.TextView;

public class MapPOIDetailActivity extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        setTitle("POI Item Detail");
        
        setContentView(R.layout.poi_detail);
        
        Intent intent = getIntent();
        String poiName = intent.getStringExtra("POIName");

        TextView textView = (TextView)findViewById(R.id.textViewPOIDetail);
        textView.setText("POI Name : " + poiName);
    }
}
