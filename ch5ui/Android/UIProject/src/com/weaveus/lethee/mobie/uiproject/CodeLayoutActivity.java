package com.weaveus.lethee.mobie.uiproject;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;

public class CodeLayoutActivity extends Activity {
	
	EditText editText;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		// LinearLayout ����
		
		LinearLayout ll = new LinearLayout(this);
		ll.setOrientation(LinearLayout.VERTICAL);
		ll.setLayoutParams(
			new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
		
		// EditText ����
		
		EditText newEditText = new EditText(this);
		newEditText.setLayoutParams(
			new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
		newEditText.setHint("EditText �Է�");
		
		ll.addView(newEditText); // LinearLayout�� ������� �߰�
		this.editText = newEditText; //��Ƽ��Ƽ ������ ����
		
		// Button ���� Click �̺�Ʈ ó��
		
		Button newButton = new Button(this);
		newButton.setText("�ڷ� ����");
		newButton.setLayoutParams(
			new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
		newButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				CodeLayoutActivity.this.finish();
			}
		});
	
		ll.addView(newButton); // LinearLayout�� ������� �߰�
		
		setContentView(ll); // LinearLayout ��Ƽ��Ƽ�� ����
	}
}