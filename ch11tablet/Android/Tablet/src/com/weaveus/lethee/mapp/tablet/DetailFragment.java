package com.weaveus.lethee.mapp.tablet;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public class DetailFragment extends Fragment {

	TextView detailLabel;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {

		View v = inflater.inflate(R.layout.detail, container, false);
		this.detailLabel = (TextView) v.findViewById(R.id.detailLabel);

		return v;
	}
	
	public void update(String item) {
		detailLabel.setText(item);
	}
}