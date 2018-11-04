package aquila.ui;

import hpp.openfl.ui.HUIBox;
import hpp.ui.VAlign;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseProperty extends Sprite
{
	public var value(default, set):Dynamic;

	var content:HUIBox;
	var container:Sprite;
	var baseColor:UInt;
	var minWidth:Float;
	var valueWidth:Float;
	var minHeight:Float;

	public function new(propertyName:String, minWidth:Float = 700, minHeight:Float = 30, propertyNamePercent:Float = .4, baseColor:UInt = 0x555555)
	{
		super();
		this.minWidth = minWidth;
		this.minHeight = minHeight;
		this.baseColor = baseColor;
		valueWidth = minWidth - minWidth * propertyNamePercent;

		content = new HUIBox(0, VAlign.TOP);

		var propertyNameContainer:Sprite = new Sprite();
		propertyNameContainer.graphics.drawRect(0, 0, minWidth * propertyNamePercent, minHeight);
		var propertyNameText:TextField = new TextField();
		propertyNameText.defaultTextFormat = new TextFormat("Verdana", 14, 0x111111, true);
		propertyNameText.text = propertyName;
		propertyNameText.selectable = false;
		propertyNameText.autoSize = "left";
		propertyNameText.x = 10;
		propertyNameText.y = minHeight / 2 - propertyNameText.height / 2 - 1;
		propertyNameContainer.addChild(propertyNameText);
		content.addChild(propertyNameContainer);

		content.addChild(container = new Sprite());
		addChild(content);

		draw();
		build();
	}

	public function draw():Void
	{
		graphics.clear();
		graphics.beginFill(baseColor);
		graphics.drawRect(0, 0, Math.max(container.width, minWidth), Math.max(container.height, minHeight));
		graphics.endFill();
	}

	function set_value(_value:Dynamic):Dynamic
	{
		value = _value;
		onValueChanged(value);

		return value;
	}

	function build() {}

	dynamic public function onValueChanged(value:Dynamic) {}
}