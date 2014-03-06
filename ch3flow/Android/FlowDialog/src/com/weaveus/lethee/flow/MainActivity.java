package com.weaveus.lethee.flow;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity {

	TextView textView;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		textView = (TextView)findViewById(R.id.textView1);
		
		Toast toast = Toast.makeText(this, 
				"메시지를 Toast로 굽습니다.", Toast.LENGTH_LONG);
		toast.show();
	}

	public void showDialog(View view) {
		
		DialogListener dialogListener = new DialogListener();
		
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		
		/*
		builder.setTitle("다이얼로그 타이틀")
			.setMessage("다이얼로그가 보입니까?\n어떤 선택을 하시겠습니까!")
			.setPositiveButton("예", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int id) {
					textView.setText("예 를 선택하셨군요.");
					dialog.dismiss();
				}
			})
			.setNegativeButton("아니오", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int id) {
					textView.setText("아니오 를 선택하셨군요.");
					dialog.dismiss();
				}
			});
		*/
		
		builder.setTitle("다이얼로그 타이틀")
			.setMessage("다이얼로그가 보입니까?\n어떤 선택을 하시겠습니까!")
			.setPositiveButton("예", dialogListener)
			.setNegativeButton("아니오", dialogListener);
		
		AlertDialog alert = builder.create();
		alert.show();
	}
	
	class DialogListener implements DialogInterface.OnClickListener {
		public void onClick(DialogInterface dialog, int id) {
			switch (id) {
			case DialogInterface.BUTTON_POSITIVE: // -1
				textView.setText("예 를 선택하셨군요.");
				break;
			case DialogInterface.BUTTON_NEGATIVE: // -2
				textView.setText("아니오 를 선택하셨군요.");
				break;
			case DialogInterface.BUTTON_NEUTRAL:  // -3
				break;
			}
			dialog.dismiss();
		}
	}
}
