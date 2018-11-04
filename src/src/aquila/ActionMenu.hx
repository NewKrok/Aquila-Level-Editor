package aquila;

import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.HUIBox;
import openfl.Assets;
import openfl.display.Bitmap;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ActionMenu extends HUIBox
{
	var upButton:BaseButton;
	var downButton:BaseButton;
	var duplicateButton:BaseButton;
	var removeButton:BaseButton;

	public function new(upRequest:Void->Void, downRequest:Void->Void, duplicateRequest:Void->Void, removeRequest:Void->Void)
	{
		super(5);

		addChild(upButton = new BaseButton(
			function(_){ upRequest(); },
			"UP",
			new Bitmap(Assets.getBitmapData("img/move_button.png")),
			new Bitmap(Assets.getBitmapData("img/move_button_over.png"))
		));
		upButton.fontSize = 12;

		addChild(downButton = new BaseButton(
			function(_){ downRequest(); },
			"DOWN",
			new Bitmap(Assets.getBitmapData("img/move_button.png")),
			new Bitmap(Assets.getBitmapData("img/move_button_over.png"))
		));
		downButton.fontSize = 12;

		addChild(duplicateButton = new BaseButton(
			function(_){ duplicateRequest(); },
			"DUPLICATE",
			new Bitmap(Assets.getBitmapData("img/duplicate_button.png")),
			new Bitmap(Assets.getBitmapData("img/duplicate_button_over.png"))
		));
		duplicateButton.fontSize = 12;

		addChild(removeButton = new BaseButton(
			function(_){ removeRequest(); },
			"REMOVE",
			new Bitmap(Assets.getBitmapData("img/remove_button.png")),
			new Bitmap(Assets.getBitmapData("img/remove_button_over.png"))
		));
		removeButton.fontSize = 12;
		removeButton.label.textColor = 0xFFFFFF;

		rePosition();

		graphics.beginFill(0x888888);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
	}
}