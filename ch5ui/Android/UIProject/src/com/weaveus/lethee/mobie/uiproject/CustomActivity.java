package com.weaveus.lethee.mobie.uiproject;

import android.app.Activity;
import android.os.Bundle;

public class CustomActivity extends Activity {

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    
    int layout = getIntent().getIntExtra("layout", 0);
    if (layout == 0) {
      finish();
      return;
    }
    
    setContentView(layout);
  }
}