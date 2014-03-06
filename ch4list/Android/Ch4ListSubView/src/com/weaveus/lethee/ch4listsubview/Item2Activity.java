package com.weaveus.lethee.ch4listsubview;

import java.util.ArrayList;
import java.util.HashMap;

import android.app.ListActivity;
import android.os.Bundle;
import android.widget.SimpleAdapter;

public class Item2Activity extends ListActivity {

  ArrayList<HashMap<String, Object>> arrayMapModel;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    String[] weekNames = { "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일" };

    arrayMapModel = new ArrayList<HashMap<String, Object>>();

    // 2차원 배열 데이터
    for (String arrayData : weekNames) {
      HashMap<String, Object> itemMap = new HashMap<String, Object>();
      itemMap.put("title", arrayData);
      itemMap.put("description", arrayData + " Simple!");
      arrayMapModel.add(itemMap);
    }
    
    String[] from = { "title", "description" };
    int[] to = { android.R.id.text1, android.R.id.text2 };
    SimpleAdapter adapter = new SimpleAdapter(this, 
        arrayMapModel, 
        android.R.layout.simple_list_item_2, 
        from, to);

    setListAdapter(adapter);
  }
}
