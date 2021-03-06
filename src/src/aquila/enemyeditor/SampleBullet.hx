package aquila.enemyeditor;

import aquila.config.AnimationConfig.AnimationConfigs;
import aquila.ui.Animation;
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

		var preview:Animation = new Animation(AnimationConfigs.getConfig(tile));
		preview.scaleX = preview.scaleY = aquila.config.TileConfigs.TILE_SCALE;
		preview.x = -preview.width / 2;
		preview.y = -preview.height / 2;
		preview.rotation = angle - 90;
		addChild(preview);

		xSpeed = speed * Math.cos(angle);
		ySpeed = speed * Math.sin(angle);

		TweenMax.delayedCall(3 / speedMultiplier, function(){ onRemove(this); });
	}

	public function update(delta:Float, speedMultiplier:Float)
	{
		x += xSpeed * (delta / 100) * speedMultiplier;
		y += ySpeed * (delta / 100) * speedMultiplier;

		if (x < 0 || x > 400 || y < 0 || y > 600) onRemove(this);
	}
}