package aquila.ui;
import hpp.openfl.ui.PlaceHolder;
import hpp.openfl.ui.VUIBox;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Krisztian Somoracz
 */
class StaticProperty extends BaseProperty
{
	var valueText:TextField;

	override function build()
	{
		var subContainer:VUIBox = new VUIBox();
		subContainer.addChild(new PlaceHolder(1, 5));

		var valueContainer:Sprite = new Sprite();
		valueContainer.graphics.beginFill(0x2e2e2e, 0.2);
		valueContainer.graphics.drawRect(0, 0, valueWidth - 10, minHeight - 10);
		valueContainer.graphics.endFill();
		valueText = new TextField();
		valueText.defaultTextFormat = new TextFormat("Verdana", 16, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.RIGHT);
		valueText.text = "W";
		valueText.selectable = false;
		valueText.width = valueWidth - 20;
		valueText.height = valueText.textHeight;
		valueText.y = valueContainer.height / 2 - valueText.height / 2 - 2;

		valueContainer.addChild(valueText);
		subContainer.addChild(valueContainer);
		subContainer.addChild(new PlaceHolder(1, 5));
		container.addChild(valueContainer);

		content.rePosition();
	}

	override function set_value(value:Dynamic):Dynamic
	{
		valueText.text = cast value;

		return value;
	}
}