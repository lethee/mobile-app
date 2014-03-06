package com.weaveus.lethee.mapp.sqlite;

import java.util.Date;
import java.util.List;

import android.app.ListActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

public class MainActivity extends ListActivity {
	
	static final int NOT_SELECTED = -1;
	
	int listViewSelectedItemId = NOT_SELECTED;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		getListView().setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> listView, View view, int itemId, long arg3) {
				listViewSelectedItemId = itemId;
			}
		});
		
		loadData();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case R.id.menu_add:
		{
			Todo todo = new Todo();
			todo.content = new Date().toString();
			todo.createDate = new Date();
			todo.dueDate = new Date();

			TodoHelper db = new TodoHelper(this);
			db.create(todo);
			
			Toast.makeText(this, "Add Item", Toast.LENGTH_SHORT).show();
			
			loadData();
		}	break;
		case R.id.menu_delete:
		{	
			if (listViewSelectedItemId != NOT_SELECTED) {
				Todo todo = (Todo) getListAdapter().getItem(listViewSelectedItemId);
				
				listViewSelectedItemId = NOT_SELECTED;
				TodoHelper db = new TodoHelper(this);
				db.delete(todo.id);
			
				Toast.makeText(this, "Delete Item", Toast.LENGTH_SHORT).show();
			
				loadData();
			}
		}	break;
		case R.id.menu_refresh:
		{
			TodoHelper db = new TodoHelper(this);
			List<Todo> list = db.list();
			
			String msg = "Items Count: " + list.size();
			Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
			
			loadData();
		}	break;
		}
		
		return true;
	}
	
	void loadData() {
		TodoHelper db = new TodoHelper(this);

		ArrayAdapter<Todo> adapter = new ArrayAdapter<Todo>(this, android.R.layout.simple_list_item_single_choice);
		adapter.addAll(db.list());
		
		this.getListView().setChoiceMode(ListView.CHOICE_MODE_SINGLE);
		this.setListAdapter(adapter);
	}
}
