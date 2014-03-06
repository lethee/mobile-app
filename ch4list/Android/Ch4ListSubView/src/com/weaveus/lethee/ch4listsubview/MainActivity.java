package com.weaveus.lethee.ch4listsubview;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

public class MainActivity extends ListActivity {

  class CellStyle {
    int style;
    String text1;

    public CellStyle(int style, String title) {
      this.style = style;
      this.text1 = title;
    }
  }

  CellStyle[] listStyles = {
    new CellStyle(android.R.layout.simple_list_item_1, "simple_list_item_1"),
    new CellStyle(android.R.layout.simple_list_item_2, "simple_list_item_2"),
    new CellStyle(android.R.layout.activity_list_item, "activity_list_item"),
    new CellStyle(android.R.layout.simple_expandable_list_item_1, "simple_expandable_list_item_1"),
    new CellStyle(android.R.layout.simple_expandable_list_item_2, "simple_expandable_list_item_2"),
    new CellStyle(android.R.layout.simple_list_item_activated_1, "simple_list_item_activated_1"),
    new CellStyle(android.R.layout.simple_list_item_activated_2, "simple_list_item_activated_2"),
    new CellStyle(android.R.layout.simple_selectable_list_item, "simple_selectable_list_item"),
    new CellStyle(android.R.layout.simple_list_item_checked, "simple_list_item_checked"),
    new CellStyle(android.R.layout.simple_list_item_multiple_choice, "simple_list_item_multiple_choice"),
    new CellStyle(android.R.layout.simple_list_item_single_choice, "simple_list_item_single_choice"),
    new CellStyle(android.R.layout.test_list_item, "test_list_item"),
    new CellStyle(android.R.layout.two_line_list_item, "two_line_list_item") };

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    initListView();
  }

  void initListView() {
    ArrayAdapter<CellStyle> adapter = new ArrayAdapter<CellStyle>(this, 0, listStyles) {
      public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        convertView = inflater.inflate(getItem(position).style, null);

        TextView text1 = (TextView) convertView.findViewById(android.R.id.text1);
        text1.setText(getItem(position).text1);

        TextView text2 = (TextView) convertView.findViewById(android.R.id.text2);
        if (text2 != null) {
          text2.setText(getItem(position).text1);
        }

        return convertView;
      }
    };
    setListAdapter(adapter);
  }

  @Override
  protected void onListItemClick(ListView l, View v, int position, long id) {
    Intent intent = new Intent(this, Item2Activity.class);
    startActivity(intent);
  }
}
