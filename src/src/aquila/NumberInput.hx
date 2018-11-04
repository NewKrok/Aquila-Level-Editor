package aquila;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Krisztian Somoracz
 */
class NumberInput extends Sprite
{
	public var value:Float;

	var label:TextField;
	var onValueChange:Void->Void;

	public function new(onValueChange:Void->Void, defaultValue:Float, isFloat:Bool = false)
	{
		super();

		this.onValueChange = onValueChange;

		addChild(new Bitmap(Assets.getBitmapData("img/number_input_back.png")));

		addChild(label = new TextField());
		label.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
		value = defaultValue;
		label.text = Std.string(value);
		label.type = TextFieldType.INPUT;
		label.width = 50;
		label.height = label.textHeight;
		label.restrict = isFloat ? "0-9." : "0-9";
		label.maxChars = isFloat ? 4 : 2;

		label.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}

	private function onKeyUp(e:KeyboardEvent):Void
	{
		if (label.text == "" || label.text == "0")
		{
			value = 1;
		}
		else
		{
			value = Std.parseFloat(label.text);
		}

		onValueChange();
	}

	public function setValue(value:Float):Void
	{
		this.value = value;
		label.text = Std.string(value);
	}
}