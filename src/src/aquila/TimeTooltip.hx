package aquila;

import hpp.util.TimeUtil;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Krisztian Somoracz
 */
class TimeTooltip extends Sprite
{
	var label:TextField;

	public function new()
	{
		super();

		addChild(new Bitmap(Assets.getBitmapData("img/time_tooltip_back.png")));

		addChild(label = new TextField());
		label.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
		label.autoSize = "center";
		label.text = "00:00.000";
		label.x = (width - 5) / 2 - label.width / 2;
	}

	public function updateTime(timeStamp:Float):Void
	{
		label.text = TimeUtil.timeStampToFormattedTime(timeStamp, TimeUtil.TIME_FORMAT_MM_SS_MS);
	}
}