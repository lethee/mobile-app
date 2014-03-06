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

    String[] weekNames = { "������", "ȭ����", "������", "�����", 
      "�ݿ���", "�����", "�Ͽ���" };
    
    initSimpleAdapter(weekNames);
    // or
    // initCustomAdapter(weekNames);
  }

  // SimpleAdapter & 2���� ����Ʈ �����͸� Ȱ���ϴ� ���
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

  // ���� Adapter �����ϴ� ���
  void initCustomAdapter(String[] array) {
    arrayModel = new ArrayList<String>(Arrays.asList(array));
    CustomAdapter adapter = new CustomAdapter(this,
        R.layout.listview_custom, arrayModel);
    listView1.setAdapter(adapter);
  }

  // ����� ���� Adapter
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

      // �����ۺ� ���� �� ����
      if (convertView == null) {
        view = mInflater.inflate(mResource, parent, false);
      } else {
        view = convertView;
      }

      // UI ���۷��� ��������
      text1 = (TextView) view.findViewById(android.R.id.text1);
      text2 = (TextView) view.findViewById(android.R.id.text2);
      img = (ImageView) view.findViewById(R.id.img);

      // ������ �� �ݿ�
      text1.setText((String) getItem(position));
      text2.setText("����� ���� " + (String) getItem(position));
      img.setImageResource(R.drawable.ic_launcher);

      // �����ۺ� ��ȯ
      return view;
    }
  }
}