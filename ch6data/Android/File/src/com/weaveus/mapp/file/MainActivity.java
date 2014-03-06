package com.weaveus.mapp.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.Menu;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Assets 파일
        
        try {
        	AssetManager am = this.getAssets();
        	InputStream is = am.open("Text.txt");
        	
        	byte[] buffer = new byte[1000];
        	int length = is.read(buffer);
        	is.close();
        	
        	String assetData = new String(buffer, 0, length, "utf-8");
        	Log.d("Asset", assetData);
        	
        	// Log: My Text Resource
        } catch (IOException e) {
        	e.printStackTrace();
		}
        
        // 애플리케이션 데이터 파일
        
        try {
        	Log.d("Files", getFilesDir().toString());
        	
        	FileOutputStream fout = this.openFileOutput("data.txt", Context.MODE_PRIVATE);
        	fout.write("My Data".getBytes("utf-8"));
        	fout.close();
        	
        	FileInputStream fin = this.openFileInput("data.txt");
        	byte[] buffer = new byte[1000];
        	int length = fin.read(buffer);
        	fin.close();
        	
        	String fileData = new String(buffer, 0, length, "utf-8");
        	Log.d("Files", fileData);
        	
        	// Log: /data/data/com.weaveus.mapp.file/files
        	// Log: My Data
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
        
        try {
	        File extFile = new File(Environment.getExternalStorageDirectory(), "data.txt");
	        FileOutputStream fout = new FileOutputStream(extFile);
        	fout.write("My Data".getBytes("utf-8"));
        	fout.close();
        	
        	FileInputStream fin = new FileInputStream(extFile);
        	byte[] buffer = new byte[1000];
        	int length = fin.read(buffer);
        	fin.close();
        	
        	String fileData = new String(buffer, 0, length, "utf-8");
        	Log.d("SDCard", fileData);
        	// Log: My Data
	    } catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
        
        SharedPreferences pref = getPreferences(MODE_PRIVATE);
        SharedPreferences.Editor prefEditor = pref.edit();
        prefEditor.putString("id", "myid");
        prefEditor.putString("password", "mypassword");
        prefEditor.commit();
        
        SharedPreferences prefRead = getSharedPreferences(getLocalClassName(), MODE_PRIVATE);
        String id = prefRead.getString("id", null);
        String password = prefRead.getString("password", null);
        
        Log.d("SharedPreferences", id);
        Log.d("SharedPreferences", password);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
    
}
