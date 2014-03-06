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
				"�޽����� Toast�� �����ϴ�.", Toast.LENGTH_LONG);
		toast.show();
	}

	public void showDialog(View view) {
		
		DialogListener dialogListener = new DialogListener();
		
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		
		/*
		builder.setTitle("���̾�α� Ÿ��Ʋ")
			.setMessage("���̾�αװ� ���Դϱ�?\n� ������ �Ͻðڽ��ϱ�!")
			.setPositiveButton("��", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int id) {
					textView.setText("�� �� �����ϼ̱���.");
					dialog.dismiss();
				}
			})
			.setNegativeButton("�ƴϿ�", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int id) {
					textView.setText("�ƴϿ� �� �����ϼ̱���.");
					dialog.dismiss();
				}
			});
		*/
		
		builder.setTitle("���̾�α� Ÿ��Ʋ")
			.setMessage("���̾�αװ� ���Դϱ�?\n� ������ �Ͻðڽ��ϱ�!")
			.setPositiveButton("��", dialogListener)
			.setNegativeButton("�ƴϿ�", dialogListener);
		
		AlertDialog alert = builder.create();
		alert.show();
	}
	
	class DialogListener implements DialogInterface.OnClickListener {
		public void onClick(DialogInterface dialog, int id) {
			switch (id) {
			case DialogInterface.BUTTON_POSITIVE: // -1
				textView.setText("�� �� �����ϼ̱���.");
				break;
			case DialogInterface.BUTTON_NEGATIVE: // -2
				textView.setText("�ƴϿ� �� �����ϼ̱���.");
				break;
			case DialogInterface.BUTTON_NEUTRAL:  // -3
				break;
			}
			dialog.dismiss();
		}
	}
}
