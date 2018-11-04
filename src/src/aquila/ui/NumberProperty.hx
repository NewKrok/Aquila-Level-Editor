package aquila.ui;

import hpp.openfl.ui.PlaceHolder;
import hpp.openfl.ui.VUIBox;
import openfl.display.Sprite;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Krisztian Somoracz
 */
class NumberProperty extends BaseProperty
{
	var valueText:TextField;
	var isFloat:Bool;
	var minValue:Float;
	var maxValue:Float;

	public function new(propertyName:String, isFloat:Bool, minValue:Float = null, maxValue:Float = null, minWidth:Float = 700, minHeight:Float = 30, propertyNamePercent:Float = .4, baseColor:UInt = 0x555555)
	{
		this.maxValue = maxValue == null ? 99999999 : maxValue;
		this.minValue = minValue == null ? 0 : minValue;
		this.isFloat = isFloat;

		super(propertyName, minWidth, minHeight, propertyNamePercent, baseColor);
	}

	override function build()
	{
		var subContainer:VUIBox = new VUIBox();
		subContainer.addChild(new PlaceHolder(1, 5));

		var valueContainer:Sprite = new Sprite();
		valueContainer.graphics.beginFill(0x2e2e2e, 1);
		valueContainer.graphics.drawRect(0, 0, valueWidth - 10, minHeight - 10);
		valueContainer.graphics.endFill();
		valueText = new TextField();
		valueText.defaultTextFormat = new TextFormat("Verdana", 16, 0xFFFF00, null, null, null, null, null, TextFormatAlign.RIGHT);
		valueText.maxChars = 30;
		valueText.text = "9";
		valueText.restrict = isFloat ? "0-9." : "0-9";
		valueText.type = TextFieldType.INPUT;
		valueText.width = valueWidth - 20;
		valueText.height = valueText.textHeight;
		valueText.y = valueContainer.height / 2 - valueText.height / 2 - 2;
		valueText.addEventListener(FocusEvent.FOCUS_OUT, function(_) { normalizeValueText(); });
		valueText.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		valueContainer.addChild(valueText);
		subContainer.addChild(valueContainer);
		subContainer.addChild(new PlaceHolder(1, 4));
		container.addChild(subContainer);

		content.rePosition();
	}

	function onKeyUp(e:KeyboardEvent):Void
	{
		if (e.keyCode != 13) return;

		if (valueText.text == "" || valueText.text == "0")
		{
			value = 0;
		}
		else
		{
			value = Std.parseFloat(valueText.text);
		}

		normalizeValueText();
	}

	function normalizeValueText()
	{
		valueText.text = cast Math.max(Std.parseFloat(valueText.text), minValue);
		valueText.text = cast Math.min(Std.parseFloat(valueText.text), maxValue);

		value = Std.parseFloat(valueText.text);
	}

	override function set_value(value:Dynamic):Dynamic
	{
		valueText.text = Std.string(value);

		return super.value = value;
	}
}