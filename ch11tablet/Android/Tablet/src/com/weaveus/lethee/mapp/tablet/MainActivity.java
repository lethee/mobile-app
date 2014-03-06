package com.weaveus.lethee.mapp.tablet;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;

public class MainActivity extends Activity {

  private MasterFragment masterFrag;
  private DetailFragment detailFrag;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    this.masterFrag = (MasterFragment) 
        getFragmentManager().findFragmentById(R.id.masterFrag);
    this.detailFrag = (DetailFragment) 
        getFragmentManager().findFragmentById(R.id.detailFrag);
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    getMenuInflater().inflate(R.menu.main, menu);
    return true;
  }

  public void onSelectMyItem(String item) {
    if (detailFrag != null) {
      detailFrag.update(item);
    } else {
      Intent detail = new Intent(this, DetailActivity.class);
      detail.putExtra("item", item);
      startActivity(detail);
    }
  }
}
