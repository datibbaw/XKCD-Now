package com.datibbaw.xkcdworldclock;

import java.io.IOException;
import java.io.InputStream;
import java.util.Calendar;
import java.util.TimeZone;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Path;
import android.util.AttributeSet;
import android.view.View;

public class ClockView extends View 
{
	public enum Mode {
		MODE_LOCAL, MODE_UNIVERSAL
	};

	private Bitmap b;
	private Mode mode = Mode.MODE_UNIVERSAL;

	TimeZone local = TimeZone.getDefault();
	TimeZone utc = TimeZone.getTimeZone("UTC");

	public void setMode(Mode mode) 
	{
		this.mode = mode;
		invalidate();
	}

	public ClockView(Context context, AttributeSet attrs) throws IOException 
	{
		super(context, attrs);
		if (!isInEditMode()) {
			b = getBitmapFromAsset(context, "clockdial.png");
		}
	}

	private Bitmap getBitmapFromAsset(Context context, String strName) throws IOException 
	{
	    AssetManager assetManager = context.getAssets();

	    InputStream istr;
        istr = assetManager.open(strName);

        return BitmapFactory.decodeStream(istr);
	}

	private void drawOuterDial(Canvas canvas)
	{
		float centre_x = b.getWidth() / 2;
		float centre_y = b.getHeight() / 2;

		canvas.save();

		canvas.translate(centre_x, centre_y);
		canvas.rotate(getOuterDialAngle());
		canvas.drawBitmap(b, -centre_x, -centre_y, null);

		canvas.restore();
	}

	private void drawInnerDial(Canvas canvas)
	{
		Path clip = new Path();

		float centre_x = b.getWidth() / 2;
		float centre_y = b.getHeight() / 2;

		clip.addCircle(centre_x, centre_y, 299, Path.Direction.CW);

		canvas.save();

		canvas.clipPath(clip);
		canvas.translate(centre_x, centre_y);
		canvas.rotate(getInnerDialAngle());
		canvas.drawBitmap(b, -centre_x, -centre_y, null);

		canvas.restore();
	}

	private float getInnerDialAngle()
	{
		if (mode == Mode.MODE_LOCAL) {
			return 180 - getAngleFromSeconds(local.getRawOffset() / 1000);
		} else {
			return getAngleFromSeconds(getSecondsSinceMidnight(utc));
		}
	}

	private float getOuterDialAngle()
	{
		if (mode == Mode.MODE_LOCAL) {
			return 180 - getAngleFromSeconds(getSecondsSinceMidnight(local));
		} else {
			return 0;
		}
	}

	private float getAngleFromSeconds(long seconds)
	{
		return (float)seconds / 86400 * 360;
	}

	private long getSecondsSinceMidnight(TimeZone zone)
	{
		Calendar c = Calendar.getInstance();
		long now = c.getTimeInMillis();

		c.setTimeZone(zone);
		c.set(Calendar.HOUR, 0);
		c.set(Calendar.MINUTE, 0);
		c.set(Calendar.SECOND, 0);
		c.set(Calendar.MILLISECOND, 0);

		return (now - c.getTimeInMillis()) / 1000;		
	}

	protected void onDraw(Canvas canvas)
	{
		if (!isInEditMode()) {
			drawOuterDial(canvas);
			drawInnerDial(canvas);
		}
	}
}
