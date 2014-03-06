package com.weaveus.lethee.ch4listviewbinddata;

import java.util.ArrayList;
import java.util.Arrays;

import android.app.AlertDialog;
import android.app.ListActivity;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

public class MainActivity extends ListActivity
    implements OnItemLongClickListener
{

  ArrayList<String> model;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    getListView().setOnItemLongClickListener(this);

    String[] weekNames = { "월요일", "화요일", "수요일", "목요일",
      "금요일", "토요일", "일요일" };
    model = new ArrayList<String>(Arrays.asList(weekNames));
    ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,
        android.R.layout.simple_list_item_1, model);

    setListAdapter(adapter);
  }

  // 롱-터치시 해당 아이템 데이터 삭제
  public boolean onItemLongClick(AdapterView<?> listView,
      View subView, final int position, long id)
  {
    final ArrayAdapter<?> adapter = 
        (ArrayAdapter<?>) listView.getAdapter();

    AlertDialog.Builder builder = new AlertDialog.Builder(this)
        .setTitle("삭제 확인")
        .setMessage(adapter.getItem(position) + "?")
        .setCancelable(true)
        .setPositiveButton("OK", new OnClickListener() {
          public void onClick(DialogInterface arg0, int arg1) {
            model.remove(position);
            adapter.notifyDataSetChanged();
          }
        });

    builder.create().show();
    return true; // LongClick Event is handled.
  }

  @Override
  protected void onListItemClick(ListView l, View v, int position, long id) {
    String msg = String.format("Touch %s!", model.get(position));
    Toast.makeText(MainActivity.this, msg, Toast.LENGTH_SHORT).show();
  }
  
  public void onCheckDataButton(View v) {
    new AlertDialog.Builder(this)
        .setTitle("model 데이터 확인")
        .setMessage(TextUtils.join(", ", model))
        .create().show();
  }

  public void onAddButton(View v) {
    Toast.makeText(this, "데이터 추가", Toast.LENGTH_SHORT).show();

    model.add(0, "휴가 !");
    model.add("공휴일 !");

    ArrayAdapter<?> adapter = (ArrayAdapter<?>) getListAdapter();
    adapter.notifyDataSetChanged();
  }

  public void onDeleteButton(View v) {
    if (model.size() < 2) {
      Toast.makeText(this, "데이터 삭제 불가", Toast.LENGTH_SHORT).show();
      return;
    }
    
    Toast.makeText(this, "데이터 삭제", Toast.LENGTH_SHORT).show();
    
    model.remove(model.size() - 1);
    model.remove(0);

    ArrayAdapter<?> adapter = (ArrayAdapter<?>) getListAdapter();
    adapter.notifyDataSetChanged();
  }  
}