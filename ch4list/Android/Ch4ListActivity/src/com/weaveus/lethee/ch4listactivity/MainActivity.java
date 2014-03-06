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

    // ListActivity�� �̹� ListView�� ���Ե� ���̾ƿ��� �����ϹǷ�
    // ���� setContentView() �޼ҵ�� ���̾ƿ��� �ε����� �ʴ´�.
    //
    // ����� ���� ���̾ƿ��� �����ϴ�. �ٸ�
    // <ListView>���� id="andoird:id/list"��
    // �������־�� ���� Ŭ������ ListActivity ����
    // ListView ������ ó���� �� �ִ�.

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
