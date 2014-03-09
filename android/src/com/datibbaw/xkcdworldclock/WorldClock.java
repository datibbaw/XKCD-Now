package com.datibbaw.xkcdworldclock;

import java.util.Timer;
import java.util.TimerTask;

import android.os.Bundle;
import android.os.Handler;
import android.app.Activity;
import android.view.Menu;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.ToggleButton;

public class WorldClock extends Activity 
{
	private ClockView clock;
	private ToggleButton mode;

	final Handler timerHandler = new Handler();

	final Runnable clockUpdater = new Runnable() {
	   public void run() 
	   {
		   clock.invalidate();
	   }
	};

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_world_clock);

		clock = (ClockView) findViewById(R.id.clockView);
		mode = (ToggleButton) findViewById(R.id.timeMode);

		setUpTimer();
		setUpModeListener();
	}

	private void setUpModeListener() 
	{
		mode.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			@Override
			public void onCheckedChanged(CompoundButton arg0, boolean arg1) 
			{
				if (arg1) {
					clock.setMode(ClockView.Mode.MODE_LOCAL);
				} else {
					clock.setMode(ClockView.Mode.MODE_UNIVERSAL);
				}
			}			
		});
	}

	private void setUpTimer()
	{
		Timer myTimer = new Timer();
		myTimer.schedule(new TimerTask() {
			public void run() 
			{
				updateClock();
			}
		}, 0, 30000);
	}

	private void updateClock()
	{
		timerHandler.post(clockUpdater);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.world_clock, menu);
		return true;
	}
}
