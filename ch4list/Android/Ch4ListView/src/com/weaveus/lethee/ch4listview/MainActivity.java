package com.weaveus.lethee.ch4listview;

import java.util.ArrayList;
import java.util.Arrays;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.GridView;
import android.widget.Toast;

public class MainActivity extends Activity {

  GridView listView1;

  ArrayList<String> model;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    
    // 레이아웃 불러오기
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    
    setTitle("Ch4GridView");

    // 리스트뷰 프로퍼티 설정
    listView1 = (GridView) findViewById(R.id.listView1);

    // 데이터 모델 준비
    String[] weekNames = { "월요일", "화요일", "수요일", "목요일",
      "금요일", "토요일", "일요일", "월요일", "화요일", "수요일", "목요일",
      "금요일", "토요일", "일요일" };
    model = new ArrayList<String>(Arrays.asList(weekNames));

    // 어댑터와 리스트뷰 연결
    ArrayAdapter<String> adapter = new ArrayAdapter<String>(
        this,
        android.R.layout.simple_list_item_1, 
        model);
    listView1.setAdapter(adapter);
    
    // 리스트뷰 이벤트 리스너 설정
    ItemClickListener itemClickListener = new ItemClickListener();
    listView1.setOnItemClickListener(itemClickListener);
  }

  class ItemClickListener implements OnItemClickListener {

    // 리스트뷰 아이템 터치 처리
    public void onItemClick(AdapterView<?> listView,
        View subView, int position, long id)
    {
      String msg = String.format("%s 터치!", model.get(position));
      Toast.makeText(MainActivity.this, msg, Toast.LENGTH_SHORT).show();
    }
  }
}