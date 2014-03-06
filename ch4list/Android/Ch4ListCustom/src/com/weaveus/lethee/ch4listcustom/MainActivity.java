package com.weaveus.lethee.ch4listcustom;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

public class MainActivity extends Activity {

  ListView listView1;

  ArrayList<String> arrayModel;

  ArrayList<HashMap<String, Object>> arrayMapModel;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    listView1 = (ListView) findViewById(R.id.listView1);

    String[] weekNames = { "월요일", "화요일", "수요일", "목요일", 
      "금요일", "토요일", "일요일" };
    
    initSimpleAdapter(weekNames);
    // or
    // initCustomAdapter(weekNames);
  }

  // SimpleAdapter & 2차원 리스트 데이터를 활용하는 방법
  void initSimpleAdapter(String[] array) {
    arrayMapModel = new ArrayList<HashMap<String, Object>>();

    for (String arrayData : array) {
      HashMap<String, Object> itemMap = new HashMap<String, Object>();
      itemMap.put("row1", arrayData);
      itemMap.put("row2", arrayData + " Simple!");
      itemMap.put("img", R.drawable.ic_launcher);
      arrayMapModel.add(itemMap);
    }

    String[] from = { "row1", "row2", "img" };
    int[] to = { android.R.id.text1, android.R.id.text2, R.id.img };
    SimpleAdapter adapter = new SimpleAdapter(this, 
        arrayMapModel, 
        R.layout.listview_custom, 
        from, to);
    
    listView1.setAdapter(adapter);
  }

  // 직접 Adapter 구현하는 방법
  void initCustomAdapter(String[] array) {
    arrayModel = new ArrayList<String>(Arrays.asList(array));
    CustomAdapter adapter = new CustomAdapter(this,
        R.layout.listview_custom, arrayModel);
    listView1.setAdapter(adapter);
  }

  // 사용자 정의 Adapter
  class CustomAdapter extends BaseAdapter {

    private int mResource;
    private ArrayList<String> mObjects;
    private LayoutInflater mInflater;

    public CustomAdapter(Context context, int layoutId,
        ArrayList<String> objects) 
    {
      mResource = layoutId;
      mObjects = objects;
      mInflater = (LayoutInflater) context
          .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
      return mObjects.size();
    }

    @Override
    public Object getItem(int position) {
      return mObjects.get(position);
    }

    @Override
    public long getItemId(int position) {
      return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
      View view;
      TextView text1, text2;
      ImageView img;

      // 아이템뷰 생성 및 재사용
      if (convertView == null) {
        view = mInflater.inflate(mResource, parent, false);
      } else {
        view = convertView;
      }

      // UI 레퍼런스 가져오기
      text1 = (TextView) view.findViewById(android.R.id.text1);
      text2 = (TextView) view.findViewById(android.R.id.text2);
      img = (ImageView) view.findViewById(R.id.img);

      // 데이터 값 반영
      text1.setText((String) getItem(position));
      text2.setText("사용자 정의 " + (String) getItem(position));
      img.setImageResource(R.drawable.ic_launcher);

      // 아이템뷰 반환
      return view;
    }
  }
}