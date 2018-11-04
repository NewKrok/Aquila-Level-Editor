package aquila.enemyeditor;

import com.greensock.TweenMax;
import aquila.config.TileConfigs;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SampleBullet extends Sprite
{
	var onRemove:SampleBullet->Void;
	var xSpeed:Float;
	var ySpeed:Float;

	public function new(tile:String, speed:Float, angle:Float, speedMultiplier:Float, onRemove:SampleBullet->Void)
	{
		super();

		this.onRemove = onRemove;

		var preview:Bitmap = new Bitmap(Assets.getBitmapData(tile));
		preview.scaleX = preview.scaleY = aquila.config.TileConfigs.TILE_SCALE;
		preview.x = -preview.width / 2;
		preview.y = -preview.height / 2;
		preview.rotation = angle + Math.PI / 2;
		addChild(preview);

		xSpeed = speed * Math.cos(angle);
		ySpeed = speed * Math.sin(angle);

		TweenMax.delayedCall(3 / speedMultiplier, function(){ onRemove(this); });
	}

	public function update(delta:Float, speedMultiplier:Float)
	{
		x += xSpeed * delta * speedMultiplier;
		y += ySpeed * delta * speedMultiplier;

		if (x < 0 || x > 400 || y < 0 || y > 600)
			onRemove(this);
	}
}