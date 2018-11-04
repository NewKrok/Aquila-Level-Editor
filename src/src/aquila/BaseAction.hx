package aquila;

import aquila.ActionList.ActionType;
import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.VUIBox;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseAction extends VUIBox
{
	public var duration(default, set):Float = 0;
	public var actionType(default, null):ActionType;

	var title:Sprite;
	var label:TextField;
	var background:BaseButton;

	public function new(backgroundUrl:String = "img/action_header.png", backgroundOverUrl:String = null, backgroundSelectedUrl:String = null)
	{
		super();

		title = new Sprite();

		if (backgroundOverUrl == null)
		{
			backgroundOverUrl = backgroundUrl;
		}

		if (backgroundSelectedUrl == null)
		{
			backgroundSelectedUrl = backgroundUrl;
		}

		title.addChild(background = new BaseButton(
			function(_) { onClick(); },
			"",
			new Bitmap(Assets.getBitmapData(backgroundUrl)),
			new Bitmap(Assets.getBitmapData(backgroundOverUrl)),
			new Bitmap(Assets.getBitmapData(backgroundSelectedUrl))
		));

		title.addChild(label = new TextField());
		label.defaultTextFormat = new TextFormat("Verdana", 12, 0x000000);
		label.text = "W";
		label.autoSize = "left";
		label.width = width - 36;
		label.selectable = false;
		label.mouseEnabled = false;
		label.x = 36;
		label.y = title.height / 2 - label.textHeight / 2;

		addChild(title);

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		build();
	}

	public function dispose():Void
	{
		removeChild(title);
		title = null;

		removeChild(label);
		label = null;
	}

	function set_duration(value:Float):Float
	{
		duration = value;

		update();

		return duration;
	}

	function build() {}
	function update() {}
	function onClick() {}

	public function clone():BaseAction { return new BaseAction(); }
}