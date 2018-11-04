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
class EnemyInput extends Sprite
{
	public var value:String;

	var label:TextField;
	var onValueChange:Void->Void;

	public function new(onValueChange:Void->Void, defaultValue:String)
	{
		super();

		this.onValueChange = onValueChange;

		addChild(new Bitmap(Assets.getBitmapData("img/enemy_input_back.png")));

		addChild(label = new TextField());
		label.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
		label.text = value = defaultValue;
		label.width = 100;
		label.selectable = false;
		label.height = label.textHeight;

		buttonMode = true;
	}

	public function setValue(value:String):Void
	{
		this.value = value;
		label.text = value;

		onValueChange();
	}
}