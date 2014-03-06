package com.weaveus.lethee.mapp.tablet;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class DetailActivity extends Activity {

  TextView detailLabel;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.detail);

    this.detailLabel = (TextView) findViewById(R.id.detailLabel);

    String item = getIntent().getStringExtra("item");
    this.detailLabel.setText(item);
  }

}
