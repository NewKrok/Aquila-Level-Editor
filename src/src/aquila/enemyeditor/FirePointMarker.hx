package aquila.enemyeditor;

import aquila.config.AnimationConfig.AnimationConfigs;
import aquila.config.TileConfigs;
import aquila.ui.Animation;
import openfl.display.Bitmap;
import openfl.display.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class FirePointMarker extends Sprite
{
	public function new(graphicId:String)
	{
		super();

		var preview:Animation = new Animation(AnimationConfigs.getConfig(graphicId));
		preview.scaleX = preview.scaleY = aquila.config.TileConfigs.TILE_SCALE;
		preview.x = -preview.width / 2;
		preview.y = -preview.height / 2;
		addChild(preview);

		graphics.beginFill(0xFFFFFF, .1);
		graphics.lineStyle(2, 0xFFFFFF, .2);
		graphics.drawCircle(0, 0, preview.width + 5);
		graphics.endFill();

		buttonMode = true;
	}
}