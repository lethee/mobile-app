package com.weaveus.lethee.mapp.photo;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ImageView;

public class MainActivity extends Activity {

  private static final int REQUEST_CODE_LIBRARY = 1;
  private static final int REQUEST_CODE_CAMERA = 2;
  private static final int REQUEST_CODE_CAMERA_FULL = 3;

  private ImageView imageView; // 레이아웃에서 정의한 이미지뷰

  private Uri cameraPhotoUri; // 카메라에서 찍은 원본 이미지를 저장하고 읽는데 사용할 파일경로

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    this.imageView = (ImageView) findViewById(R.id.imageView);
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    getMenuInflater().inflate(R.menu.activity_main, menu);
    return true;
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {

    case R.id.menu_images: // 이미지 라이브러리에서 선택
      Intent intent = new Intent(Intent.ACTION_PICK);
      intent.setType(MediaStore.Images.Media.CONTENT_TYPE);
      startActivityForResult(intent, REQUEST_CODE_LIBRARY);
      break;

    case R.id.menu_camera: // 카메라에서 캡쳐 (썸네일)
      Intent cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
      startActivityForResult(cameraIntent, REQUEST_CODE_CAMERA);
      break;

    case R.id.menu_camera_full: // 카메라에서 캡쳐 (원본)
      String tmpFileName = "tmp_" + String.valueOf(System.currentTimeMillis()) + ".jpg";
      File tmpFile = new File(Environment.getExternalStorageDirectory(), tmpFileName);
      this.cameraPhotoUri = Uri.fromFile(tmpFile);
      Log.i("URI", this.cameraPhotoUri.toString());

      Intent cameraFullIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
      cameraFullIntent.putExtra(MediaStore.EXTRA_OUTPUT, this.cameraPhotoUri);
      startActivityForResult(cameraFullIntent, REQUEST_CODE_CAMERA_FULL);
      break;
    }
    return true;
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {

    // 라이브러리로부터 얻은 데이터
    if (requestCode == REQUEST_CODE_LIBRARY && resultCode == Activity.RESULT_OK) {
      try {
        Uri uri = data.getData();
        Log.d("Selected Image URI", uri.toString());
        InputStream imageStream = getContentResolver().openInputStream(uri);

        Bitmap bitmap = BitmapFactory.decodeStream(imageStream);
        imageView.setImageBitmap(bitmap);

        String realPath = getPathForMediaStoreImageURI(uri);
        Log.d("Selected Image Path", realPath);
        showExif(realPath);
      } catch (FileNotFoundException e) { // openInputStream Exception
        e.printStackTrace();
      }
    }

    // 카메라 이미지 데이터 (썸네일)
    if (requestCode == REQUEST_CODE_CAMERA && resultCode == Activity.RESULT_OK) {
      Bitmap photo = (Bitmap) data.getExtras().get("data");
      imageView.setImageBitmap(photo);
    }

    // 카메라 이미지 데이터 (원본)
    if (requestCode == REQUEST_CODE_CAMERA_FULL && resultCode == Activity.RESULT_OK) {
      File tmpImageFile = new File(this.cameraPhotoUri.getPath());
      if (tmpImageFile.exists()) {
        Bitmap photo = BitmapFactory.decodeFile(this.cameraPhotoUri.getPath());
        imageView.setImageBitmap(photo);

        showExif(this.cameraPhotoUri.getPath());
      }
    }

    super.onActivityResult(requestCode, resultCode, data);
  }

  /**
   * ExifInterface.TAG_GPS_LATITUDE<br>
   * "num1/denom1,num2/denom2,num3/denom3"<br>
   * <br>
   * '37/1,30/1,25603/1000' to 37.3025603
   */
  double convertToDegree(String stringDMS) {
    String[] DMS = stringDMS.split(",", 3);

    String[] stringD = DMS[0].split("/", 2);
    double D0 = Double.valueOf(stringD[0]);
    double D1 = Double.valueOf(stringD[1]);
    double d = D0 / D1;

    String[] stringM = DMS[1].split("/", 2);
    double M0 = Double.valueOf(stringM[0]);
    double M1 = Double.valueOf(stringM[1]);
    double m = M0 / M1;

    String[] stringS = DMS[2].split("/", 2);
    double S0 = Double.valueOf(stringS[0]);
    double S1 = Double.valueOf(stringS[1]);
    double s = S0 / S1;

    return d + (m / 60) + (s / 3600);
  };

  void showExif(String path) {
    try {
      ExifInterface exif = new ExifInterface(path);

      double lat = convertToDegree(exif.getAttribute(ExifInterface.TAG_GPS_LATITUDE));
      double lon = convertToDegree(exif.getAttribute(ExifInterface.TAG_GPS_LONGITUDE));

      String msg = String.format("촬영 일시: %s\n촬영 위치: %s, %s",
          exif.getAttribute(ExifInterface.TAG_DATETIME),
          new DecimalFormat("#.##").format(lat),
          new DecimalFormat("#.##").format(lon));

      new AlertDialog.Builder(this)
          .setTitle("EXIF 메타데이터")
          .setMessage(msg)
          .create().show();

    } catch (IOException e) { // ExifInterface Exception
      e.printStackTrace();
    }
  }

  String getPathForMediaStoreImageURI(Uri uri) {
    String[] proj = { MediaStore.Images.Media.DATA };
    Cursor cursor = managedQuery(uri, proj, null, null, null);
    int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
    cursor.moveToFirst();
    return cursor.getString(column_index);
  }
}