package aquila.ui;

import hpp.openfl.ui.PlaceHolder;
import hpp.openfl.ui.UIGrid;
import hpp.openfl.ui.VUIBox;
import hpp.util.GeomUtil.SimplePoint;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import aquila.config.TileConfigs;

/**
 * ...
 * @author Krisztian Somoracz
 */
class TileProperty extends BaseProperty
{
	var previewSize:SimplePoint = { x: 49, y: 49 };
	var padding:Float = 4.9;

	var tileConfigs:Array<TileConfig>;
	var previews:Array<TilePreview>;

	public function new(propertyName:String, tileConfigs:Array<TileConfig>, previewSize:SimplePoint = null, minWidth:Float = 700, minHeight:Float = 30, propertyNamePercent:Float = .4, baseColor:UInt = 0x555555)
	{
		this.tileConfigs = tileConfigs;
		if (previewSize != null) this.previewSize = previewSize;

		super(propertyName, minWidth, minHeight, propertyNamePercent, baseColor);
	}

	override function build()
	{
		var subContainer:VUIBox = new VUIBox();
		subContainer.addChild(new PlaceHolder(1, 5));

		var tilePreview:UIGrid = new UIGrid(Math.floor(valueWidth / (previewSize.x + padding)), padding);
		previews = [];

		for (tileConfig in tileConfigs)
		{
			var preview:TilePreview;
			tilePreview.addChild(preview = new TilePreview(
				function(c) { value = c.gameUrl; },
				tileConfig,
				previewSize
			));
			previews.push(preview);
		}
		previews[0].linkToButtonList(cast previews);
		previews[0].isSelected = true;

		subContainer.addChild(tilePreview);
		subContainer.addChild(new PlaceHolder(1, 5));
		container.addChild(subContainer);

		content.rePosition();
		draw();
	}

	override function set_value(value:Dynamic):Dynamic
	{
		for (preview in previews)
			if (preview.config.editorUrl == value)
				preview.isSelected = true;

		return super.value = value;
	}
}