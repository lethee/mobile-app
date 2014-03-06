package com.weaveus.lethee.mapp.sqlite;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class TodoHelper extends SQLiteOpenHelper {

	private static final int DATABASE_VERION = 1;
	private static final String DATABASE_NAME = "todo_db";
	private static final String TABLE_NAME = "todo";
	
	public TodoHelper(Context context) {
		super(context, DATABASE_NAME, null, DATABASE_VERION);
	}

	@Override
	public void onCreate(SQLiteDatabase db) {
		String CREATE_TODO_TABLE = 
				"CREATE TABLE " + TABLE_NAME + "("
                + "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL," 
				+ "content TEXT,"
				+ "createDate INTEGER,"
				+ "dueDate INTEGER)";
        db.execSQL(CREATE_TODO_TABLE);
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {		
	}

	public void create(Todo todo) {
		SQLiteDatabase db = this.getWritableDatabase();
		 
	    ContentValues values = new ContentValues();
	    values.put("content", todo.content);
	    values.put("createDate", todo.createDate.getTime());
	    values.put("dueDate", todo.dueDate.getTime());
	 
	    db.insert(TABLE_NAME, null, values);
	    db.close();
	}
	
	public Todo read(Integer id) {
		SQLiteDatabase db = this.getReadableDatabase();
		 
	    Cursor cursor = db.query(TABLE_NAME, 
	    		new String[] { "id", "content", "createDate", "dueDate" }, 
	    		"id=?",
	            new String[] { String.valueOf(id) }, 
	            null, null, null, null);
	    
	    if (cursor != null) {
	        cursor.moveToFirst();
	    }
	 
	    Todo todo = parseCursor(cursor);
	    return todo;
	}
	
	private Todo parseCursor(Cursor cursor) {
		Todo todo = new Todo();
	    
	    todo.id = cursor.getInt(cursor.getColumnIndex("id"));
	    todo.content = cursor.getString(cursor.getColumnIndex("content"));
	    todo.createDate = new Date();
	    todo.createDate.setTime(cursor.getLong(cursor.getColumnIndex("createDate")));
	    todo.createDate = new Date();
	    todo.createDate.setTime(cursor.getLong(cursor.getColumnIndex("createDate")));
	    
	    return todo;
	}
	
	public int update(Todo todo) {
		SQLiteDatabase db = this.getWritableDatabase();
		 
		ContentValues values = new ContentValues();
	    values.put("content", todo.content);
	 
	    return db.update(TABLE_NAME, 
	    		values, 
	    		"id = ?",
	            new String[] { String.valueOf(todo.id) });
	}
	
	public void delete(Integer id) {
		SQLiteDatabase db = this.getWritableDatabase();
	    db.delete(TABLE_NAME, 
	    		"id = ?",
	            new String[] { String.valueOf(id) });
	    db.close();
	}
	
	public List<Todo> list() {
		List<Todo> list = new ArrayList<Todo>();

		String selectQuery = "SELECT id,content,createDate,dueDate FROM " + TABLE_NAME;

		SQLiteDatabase db = this.getWritableDatabase();
		Cursor cursor = db.rawQuery(selectQuery, null);

		if (cursor.moveToFirst()) {
			do {
				Todo todo = parseCursor(cursor);
				list.add(todo);
			} while (cursor.moveToNext());
		}

		return list;
	}
}
