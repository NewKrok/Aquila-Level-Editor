package aquila.enemyeditor;
import aquila.config.DecorationConfigs;

import aquila.config.DecorationConfigs.DecorationConfig;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import spritesheet.AnimatedSprite;
import spritesheet.Spritesheet;
import spritesheet.data.BehaviorData;
import spritesheet.importers.BitmapImporter;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SpaceshipDecoration extends Sprite
{
	var lastTime:Float = Lib.getTimer();
	var animation:AnimatedSprite;

	public function new(config:DecorationConfig)
	{
		super();

		addChild(createNewDecor(config));
	}

	function createNewDecor(config:DecorationConfig):AnimatedSprite
	{
		var spritesheet:Spritesheet = BitmapImporter.create(Assets.getBitmapData(config.tile), config.cols, config.rows, config.width, config.height);
		spritesheet.addBehavior(new BehaviorData("idle", config.frames, true, config.fps));
		animation = new AnimatedSprite(spritesheet, true);
		animation.showBehavior("idle");

		return animation;
	}

	public function update():Void
	{
		var delta = Lib.getTimer() - lastTime;
		animation.update(cast delta);
		lastTime = Lib.getTimer();
	}
}