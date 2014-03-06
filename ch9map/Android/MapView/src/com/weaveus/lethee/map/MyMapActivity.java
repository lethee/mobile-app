package com.weaveus.lethee.map;

import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;
import com.google.android.maps.MyLocationOverlay;

public class MyMapActivity extends MapActivity implements LocationListener {

	MapView mapView;

	MyLocationOverlay myLocationOverlay;

	LocationManager locmgr;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		locmgr = (LocationManager) getSystemService(LOCATION_SERVICE);

		// 레이아웃 설정
		setContentView(R.layout.activity_mymap);

		// 레이아웃으로부터 UI 레퍼런스 얻기
		mapView = (MapView) findViewById(R.id.mapView);

		// 지도 초기화
		mapView.setBuiltInZoomControls(true);

		// 현재 위치 표시
		myLocationOverlay = new MyLocationOverlay(this, mapView);
		mapView.getOverlays().add(myLocationOverlay);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		boolean result = super.onCreateOptionsMenu(menu);
		if (result) {
			menu.add(Menu.NONE, 1, 1, "현재위치 탐색");
			menu.add(Menu.NONE, 2, 2, "현재위치 탐색 중지");
			menu.add(Menu.NONE, 3, 3, "서울");
			menu.add(Menu.NONE, 4, 4, "제주");
		}
		return result;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case 1:
			locmgr.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, this);
			myLocationOverlay.enableMyLocation();
			return true;
		case 2:
			locmgr.removeUpdates(this);
			myLocationOverlay.disableMyLocation();
			return true;
		case 3:
			locmgr.removeUpdates(this);

			GeoPoint seoul = new GeoPoint(37566351, 126977921);
			mapView.getController().setCenter(seoul);
			mapView.getController().setZoom(14);
			return true;
		case 4:
			locmgr.removeUpdates(this);

			GeoPoint jeju = new GeoPoint(33500179, 126532288);
			mapView.getController().setCenter(jeju);
			mapView.getController().setZoom(14);
			return true;
		}
		return super.onOptionsItemSelected(item);
	}

	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}

	// LocationListener 인터페이스 메소드
	// 위치정보가 업데이트되면 호출되는 메소드
	public void onLocationChanged(Location location) {
		int latitude = (int) (location.getLatitude() * 1E6);
		int longitude = (int) (location.getLongitude() * 1E6);

		// 현재 위치로 지도 이동
		GeoPoint point = new GeoPoint(latitude, longitude);
		mapView.getController().setCenter(point);
		mapView.getController().setZoom(16);
	}

	// LocationListener 인터페이스 메소드
	public void onProviderDisabled(String provider) {
	}

	// LocationListener 인터페이스 메소드
	public void onProviderEnabled(String provider) {
	}

	// LocationListener 인터페이스 메소드
	public void onStatusChanged(String provider, int status, Bundle extras) {
	}
}