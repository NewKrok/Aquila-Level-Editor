package aquila.ui;

import hpp.openfl.ui.LinkedButton;
import hpp.util.GeomUtil.SimplePoint;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import aquila.config.TileConfigs;

/**
 * ...
 * @author Krisztian Somoracz
 */
class TilePreview extends LinkedButton
{
	public var config(default, set):TileConfig;
	var preview:Bitmap;

	public function new(onClick:TileConfig->Void, config:TileConfig, size:SimplePoint)
	{
		super(
			function(_) {
				if (onClick != null) onClick(config);
			},
			"",
			UiElements.getTilePreviewBackground(size),
			UiElements.getTilePreviewOverBackground(size),
			UiElements.getTilePreviewSelectedBackground(size)
		);

		if (onClick == null) isSelectable = false;

		this.config = config;
	}

	function set_config(value:TileConfig):TileConfig
	{
		config = value;

		if (preview != null)
		{
			removeChild(preview);
			preview = null;
		}

		preview = new Bitmap(Assets.getBitmapData(config.editorUrl), null, true);
		if (preview.width > preview.height)
		{
			preview.width = width - 10;
			preview.scaleY = preview.scaleX;
		}
		else
		{
			preview.height = height - 10;
			preview.scaleX = preview.scaleY;
		}

		preview.x = width / 2 - preview.width / 2;
		preview.y = height / 2 - preview.height / 2;
		addChild(preview);

		return config;
	}
}