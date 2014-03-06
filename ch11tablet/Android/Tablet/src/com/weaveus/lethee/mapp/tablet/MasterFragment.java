package com.weaveus.lethee.mapp.tablet;

import java.util.ArrayList;

import android.app.ListFragment;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class MasterFragment extends ListFragment {

  private int selectedPosition = 0;

  ArrayList<String> items;

  @Override
  public void onActivityCreated(Bundle savedInstanceState) {
    super.onActivityCreated(savedInstanceState);

    getListView().setChoiceMode(ListView.CHOICE_MODE_SINGLE);

    this.items = new ArrayList<String>();
    this.items.add("Item 1");
    this.items.add("Item 2");
    this.items.add("Item 3");
    this.items.add("Item 4");

    ArrayAdapter<String> adap = new ArrayAdapter<String>(
        this.getActivity(), android.R.layout.simple_list_item_1,
        this.items);

    this.setListAdapter(adap);

    if (savedInstanceState != null) {
      selectedPosition = savedInstanceState.getInt("selectedPosition", 0);
      getListView().setSelection(selectedPosition);
    }
  }

  @Override
  public void onSaveInstanceState(Bundle outState) {
    super.onSaveInstanceState(outState);
    outState.putInt("selectedPosition", selectedPosition);
  }

  @Override
  public void onListItemClick(ListView l, View v, int position, long id) {
    super.onListItemClick(l, v, position, id);

    MainActivity mainAct = (MainActivity) getActivity();
    if (mainAct != null) {
      mainAct.onSelectMyItem(this.items.get(position));
    }
  }
}