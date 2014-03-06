package com.weaveus.lethee.ch4listactivity;

import java.util.ArrayList;
import java.util.Arrays;

import android.app.ListActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

public class MainActivity extends ListActivity {

  ArrayList<String> model;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    // ListActivity는 이미 ListView가 포함된 레이아웃을 포함하므로
    // 따로 setContentView() 메소드로 레이아웃을 로드하지 않는다.
    //
    // 사용자 정의 레이아웃도 가능하다. 다만
    // <ListView>에서 id="andoird:id/list"로
    // 지정해주어야 상위 클래스인 ListActivity 에서
    // ListView 위젯을 처리할 수 있다.

    String[] weekNames = getResources().getStringArray(R.array.weeknames);
    model = new ArrayList<String>(Arrays.asList(weekNames));
    
    ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, 
        android.R.layout.simple_list_item_1, 
        model);
    
    this.setListAdapter(adapter);
    // or
    // this.getListView().setAdapter(adapter);
  }

  @Override
  protected void onListItemClick(ListView l, View v, int position, long id) {
    String msg = String.format("Touch %s!", model.get(position));
    Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
  }
}
