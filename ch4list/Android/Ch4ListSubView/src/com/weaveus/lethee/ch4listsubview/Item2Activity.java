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

    String[] weekNames = { "������", "ȭ����", "������", "�����", "�ݿ���", "�����", "�Ͽ���" };

    arrayMapModel = new ArrayList<HashMap<String, Object>>();

    // 2���� �迭 ������
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
