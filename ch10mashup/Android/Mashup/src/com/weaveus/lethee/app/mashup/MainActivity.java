package com.weaveus.lethee.app.mashup;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.HttpConnectionParams;
import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Editable;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

public class MainActivity extends Activity {

  JSONObject jsonApiResults;

  ListView listView;
  EditText editSearch;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    listView = (ListView) findViewById(R.id.listView1);
    editSearch = (EditText) findViewById(R.id.editTextSearch);
  }

  void hideKeyboard() {
    InputMethodManager inputManager = (InputMethodManager)
        getSystemService(Context.INPUT_METHOD_SERVICE);
    inputManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(),
        InputMethodManager.HIDE_NOT_ALWAYS);
  }

  public void onButtonClick(View view) {
    hideKeyboard();
    
    Editable keyword = editSearch.getText();
    if (keyword != null && keyword.length() > 0) {
      new ApiCallTask().execute(keyword.toString());
    }
  }

  void showApiResults() {
    try {
      ArrayList<String> items = new ArrayList<String>();
      JSONArray jsonResults = jsonApiResults.getJSONArray("results");
      for (int i = 0; i < jsonResults.length(); i++) {
        JSONObject item = jsonResults.getJSONObject(i);
        String text = String.format("@%s - %s",
            item.getString("from_user_name"),
            item.getString("text"));
        items.add(text);
      }

      ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, items);
      listView.setAdapter(adapter);

    } catch (Exception e) {
      Log.d("Exception", e.toString());
      Toast.makeText(this, e.toString(), Toast.LENGTH_LONG).show();
    }
  }

  class ApiCallTask extends AsyncTask<String, Void, JSONObject> {

    @Override
    protected JSONObject doInBackground(String... params) {
      DefaultHttpClient client = new DefaultHttpClient();
      HttpConnectionParams.setConnectionTimeout(client.getParams(), 10000);
      HttpGet httpGet = new HttpGet("http://search.twitter.com/search.json?q=" + params[0]);
      try {
        HttpResponse response = client.execute(httpGet);

        StringBuilder sb = new StringBuilder();
        InputStream is = response.getEntity().getContent();
        BufferedReader buff = new BufferedReader(new InputStreamReader(is, "UTF-8"));
        String line = null;
        while ((line = buff.readLine()) != null) {
          sb.append(line + "\n");
        }

        JSONObject jsonObj = new JSONObject(sb.toString());
        return jsonObj;
      } catch (Exception e) {
        e.printStackTrace();
      }

      return null;
    }

    @Override
    protected void onPostExecute(JSONObject jsonObj) {
      MainActivity.this.jsonApiResults = jsonObj;
      MainActivity.this.showApiResults();
    }
  }
}
