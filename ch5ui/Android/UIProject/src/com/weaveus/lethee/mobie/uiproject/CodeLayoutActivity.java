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
		
		// LinearLayout 생성
		
		LinearLayout ll = new LinearLayout(this);
		ll.setOrientation(LinearLayout.VERTICAL);
		ll.setLayoutParams(
			new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
		
		// EditText 생성
		
		EditText newEditText = new EditText(this);
		newEditText.setLayoutParams(
			new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
		newEditText.setHint("EditText 입력");
		
		ll.addView(newEditText); // LinearLayout에 하위뷰로 추가
		this.editText = newEditText; //액티비티 변수로 설정
		
		// Button 생성 Click 이벤트 처리
		
		Button newButton = new Button(this);
		newButton.setText("뒤로 가기");
		newButton.setLayoutParams(
			new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
		newButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				CodeLayoutActivity.this.finish();
			}
		});
	
		ll.addView(newButton); // LinearLayout에 하위뷰로 추가
		
		setContentView(ll); // LinearLayout 액티비티에 지정
	}
}