package aquila.ui;

import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.HUIBox;
import hpp.openfl.ui.PlaceHolder;
import hpp.util.GeomUtil.SimplePoint;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseEntry extends Sprite
{
	var container:HUIBox;
	var background:BaseButton;
	var iconContainer:Sprite;
	var icon:Bitmap;
	var iconSelected:Bitmap;
	var content:Sprite;
	var menu:HUIBox;

	var iconUrl:String;
	var iconUrlSelected:String;
	var size:SimplePoint;

	var addEntryButton:BaseButton;
	var expandButton:BaseButton;

	var isSelected(default, set):Bool;

	public function new(iconUrl:String, iconUrlSelected:String, size:SimplePoint)
	{
		super();
		this.iconUrlSelected = iconUrlSelected;
		this.iconUrl = iconUrl;
		this.size = size;

		addChild(background = new BaseButton(
			function(_) { onClick(); },
			"",
			UiElements.getBaseEntryBackground(size),
			UiElements.getBaseEntryOverBackground(size),
			UiElements.getBaseEntrySelectedBackground(size)
		));

		container = new HUIBox();
		container.mouseEnabled = false;
		container.mouseChildren = false;
		container.addChild(new PlaceHolder(5,1));

		iconContainer = new Sprite();
		iconContainer.mouseEnabled = false;
		iconContainer.mouseChildren = false;
		iconContainer.graphics.beginFill(0, 0);
		iconContainer.graphics.drawRect(0, 0, 30, size.y);
		iconContainer.graphics.endFill();
		container.addChild(iconContainer);
		iconContainer.addChild(icon = new Bitmap(Assets.getBitmapData(iconUrl)));
		icon.x = iconContainer.width / 2 - icon.width / 2;
		icon.y = iconContainer.height / 2 - icon.height / 2;
		iconContainer.addChild(iconSelected = new Bitmap(Assets.getBitmapData(iconUrlSelected)));
		iconSelected.x = iconContainer.width / 2 - iconSelected.width / 2;
		iconSelected.y = iconContainer.height / 2 - iconSelected.height / 2;

		container.addChild(new PlaceHolder(5, 1));

		content = new Sprite();
		content.mouseEnabled = false;
		content.mouseChildren = false;
		content.graphics.beginFill(0, 0);
		content.graphics.drawRect(0, 0, size.x - 35, size.y);
		content.graphics.endFill();
		container.addChild(content);

		menu = new HUIBox();
		menu.addChild(expandButton = new BaseButton(
			onToggleExpand,
			"",
			new Bitmap(Assets.getBitmapData("img/expand_arrow.png")),
			new Bitmap(Assets.getBitmapData("img/expand_arrow_over.png"))
		));
		menu.addChild(addEntryButton = new BaseButton(
			onAddEntry,
			"",
			new Bitmap(Assets.getBitmapData("img/instant_add_entry_button.png")),
			new Bitmap(Assets.getBitmapData("img/instant_add_entry_button_over.png"))
		));
		menu.x = width - menu.width - 10;
		menu.y = height / 2 - menu.height / 2;
		addChild(menu);

		addChild(container);
		isSelected = false;
	}

	function set_isSelected(value:Bool):Bool
	{
		icon.visible = !value;
		iconSelected.visible = value;
		background.isSelected = value;

		return isSelected = value;
	}

	public function select():Void
	{
		onClick();
	}

	public function deSelect():Void
	{
		isSelected = false;
	}

	function onClick() {}

	dynamic function onAddEntry(t:BaseButton) {}
	dynamic function onToggleExpand(t:BaseButton) {}

	public function update() {}
	public function dispose() {}
	public function clone():BaseEntry { return new BaseEntry(iconUrl, iconUrlSelected, size); }
}