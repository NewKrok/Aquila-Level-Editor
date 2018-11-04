package aquila;

import hpp.openfl.ui.BaseButton;
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
class LinePoint extends Sprite
{
	var removeLinePoint:LinePoint->Void;
	var duplicateLinePoint:LinePoint->Void;

	public function new(id:Int, x:Float, y:Float, removeLinePoint:LinePoint->Void, duplicateLinePoint:LinePoint->Void)
	{
		super();

		this.duplicateLinePoint = duplicateLinePoint;
		this.removeLinePoint = removeLinePoint;

		this.x = x;
		this.y = y;

		var graphic:Bitmap = new Bitmap(Assets.getBitmapData("img/attack_line_point.png"));
		graphic.x = -graphic.width / 2;
		graphic.y = -graphic.height / 2;
		addChild(graphic);

		if (id >= 0)
		{
			var label = new TextField();
			label.defaultTextFormat = new TextFormat("Verdana", 15, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.LEFT);
			label.autoSize = "left";
			label.selectable = false;
			label.text = cast id;
			label.x = 10;
			label.y = -label.height - 10;
			addChild(label);

			var removeButton:BaseButton = new BaseButton(
				removeHandler,
				"",
				new Bitmap(Assets.getBitmapData("img/remove_line_point_button.png")),
				new Bitmap(Assets.getBitmapData("img/remove_line_point_button_over.png"))
			);
			removeButton.x = -removeButton.width - 10;
			removeButton.y = 10;
			addChild(removeButton);

			var duplicateButton:BaseButton = new BaseButton(
				duplicateHandler,
				"",
				new Bitmap(Assets.getBitmapData("img/duplicate_line_point_button.png")),
				new Bitmap(Assets.getBitmapData("img/duplicate_line_point_button_over.png"))
			);
			duplicateButton.x = 10;
			duplicateButton.y = 10;
			addChild(duplicateButton);

			buttonMode = true;
		}
	}

	function removeHandler(_)
	{
		removeLinePoint(this);
	}

	function duplicateHandler(_)
	{
		duplicateLinePoint(this);
	}
}