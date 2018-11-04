package aquila;

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
class AttackLineInput extends Sprite
{
	public var value:String;

	var label:TextField;
	var onValueChange:Void->Void;

	public function new(onValueChange:Void->Void, defaultValue:String)
	{
		super();

		this.onValueChange = onValueChange;

		addChild(new Bitmap(Assets.getBitmapData("img/attack_line_info_background.png")));

		addChild(label = new TextField());
		label.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
		label.text = value = defaultValue;
		label.width = 125;
		label.height = label.textHeight;
		label.selectable = false;

		buttonMode = true;
	}

	public function setValue(value:String):String
	{
		this.value = value;
		label.text = value;
		onValueChange();

		return value;
	}
}