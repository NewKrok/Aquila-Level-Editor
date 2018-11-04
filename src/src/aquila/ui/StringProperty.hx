package aquila.ui;

import hpp.openfl.ui.PlaceHolder;
import hpp.openfl.ui.VUIBox;
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
class StringProperty extends BaseProperty
{
	var maxChars:UInt;
	var valueText:TextField;

	public function new(propertyName:String, maxChars:UInt, minWidth:Float = 700, minHeight:Float = 30, propertyNamePercent:Float = .4, baseColor:UInt = 0x555555)
	{
		this.maxChars = maxChars;

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
		valueText.maxChars = maxChars;
		valueText.text = "W";
		valueText.type = TextFieldType.INPUT;
		valueText.width = valueWidth - 20;
		valueText.height = valueText.textHeight;
		valueText.y = valueContainer.height / 2 - valueText.height / 2 - 2;
		valueText.addEventListener(KeyboardEvent.KEY_UP, function(_) { value = valueText.text; });

		valueContainer.addChild(valueText);
		subContainer.addChild(valueContainer);
		subContainer.addChild(new PlaceHolder(1, 4));
		container.addChild(subContainer);

		content.rePosition();
	}

	override function set_value(value:Dynamic):Dynamic
	{
		valueText.text = cast value;

		return super.value = value;
	}
}