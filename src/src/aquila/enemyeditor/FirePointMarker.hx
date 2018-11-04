package aquila.enemyeditor;

import aquila.config.TileConfigs;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class FirePointMarker extends Sprite
{
	public function new(tile:String)
	{
		super();

		var preview:Bitmap = new Bitmap(Assets.getBitmapData(tile));
		preview.scaleX = preview.scaleY = aquila.config.TileConfigs.TILE_SCALE;
		preview.x = -preview.width / 2;
		preview.y = -preview.height / 2;
		addChild(preview);

		graphics.beginFill(0xFFFFFF, .3);
		graphics.lineStyle(2, 0xFFFFFF);
		graphics.drawCircle(0, 0, preview.width + 5);
		graphics.endFill();

		buttonMode = true;
	}
}