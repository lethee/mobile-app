package com.weaveus.lethee.map;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.provider.Settings;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends Activity implements LocationListener {

	EditText editLatitude; // 위도 값 표
	EditText editLongitude; // 경도 값 표
	EditText editAccuracy; // 정확도 값 표

	Button buttonWatch; // '현재위치 탐색 버튼' 버튼

	boolean isLocationWatching = false;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		// 레이아웃
		setContentView(R.layout.activity_main);

		// 위도, 경도, 정확 EditText 레퍼런스
		editLatitude = (EditText) findViewById(R.id.editText1);
		editLongitude = (EditText) findViewById(R.id.editText2);
		editAccuracy = (EditText) findViewById(R.id.editText3);

		// '현재위치 탐색 버튼' 버튼 레퍼런스
		// 버튼 제목 변경을 위해 레퍼런스가 필요
		buttonWatch = (Button) findViewById(R.id.button2);
	}

	// 버튼 터치시 호출되는 메소드
	public void onButtonClick(View view) {

		// 시스템으로부터 LocationManager 얻기
		LocationManager locmgr = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

		// '현재위치' 버튼 터치
		if ("location".equals(view.getTag())) {

			// GPS 센서 사용 가능여부 확인
			if (false == locmgr.isProviderEnabled(LocationManager.GPS_PROVIDER)) {

				// GPS 설정 화면 액티비티 실행
				Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
				startActivity(intent);
			} else {

				// 마지막으로 얻었던 위치정보를 한번 확인해보기
				Location loc = locmgr.getLastKnownLocation(LocationManager.GPS_PROVIDER);
				updateLocation(loc);
			}
		}

		// '현재위치 탐색' 및 '탐색 중지' 버튼 터치
		if ("watch".equals(view.getTag())) {

			// 탐색중이 아닐 때
			if (isLocationWatching == false) {
				locmgr.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, this);
				isLocationWatching = true;

				// 버튼 타이틀 변경
				buttonWatch.setText(getResources().getText(R.string.button_watching));
				Toast.makeText(this, "위치정보 탐색을 시작", Toast.LENGTH_SHORT).show();
			}
			// 탐색중일 때
			else {
				locmgr.removeUpdates(this);
				isLocationWatching = false;

				// 버튼 타이틀 변경
				buttonWatch.setText(getResources().getText(R.string.button_watch));
				Toast.makeText(this, "위치정보 탐색을 중지", Toast.LENGTH_SHORT).show();
			}
		}

		// 'MapView 보기' 버튼 터치
		if ("mapview".equals(view.getTag())) {
			Intent intent = new Intent(this, MyMapActivity.class);
			startActivity(intent);
		}
	}

	// 전달받은 Location 클래스 위치정보에 따라 UI에 값을 반영하여 나타냄
	// LocationListener 인터페이스 메소드
	public void updateLocation(Location location) {
		if (location != null) {
			editLatitude.setText(Double.toString(location.getLatitude()));
			editLongitude.setText(Double.toString(location.getLongitude()));
			editAccuracy.setText(Float.toString(location.getAccuracy()));
		} else {
			editLatitude.setText("알 수 없음");
			editLongitude.setText("알 수 없음");
			editAccuracy.setText("알 수 없음");
		}
	}

	// LocationListener 인터페이스 메소드
	// 위치정보가 업데이트되면 호출되는 메소드
	public void onLocationChanged(Location location) {
		updateLocation(location);
	}

	// LocationListener 인터페이스 메소드
	public void onProviderDisabled(String provider) {
	}

	// LocationListener 인터페이스 메소드
	public void onProviderEnabled(String provider) {
	}

	// LocationListener 인터페이스 메소드
	public void onStatusChanged(String provider, int status, Bundle bundle) {
	}

}