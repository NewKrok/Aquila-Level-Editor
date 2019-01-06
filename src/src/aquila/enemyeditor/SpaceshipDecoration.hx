package aquila.enemyeditor;

import aquila.config.AnimationConfig.AnimationConfigs;
import aquila.config.DecorationConfigs.DecorationConfig;
import aquila.ui.Animation;
import openfl.Lib;
import openfl.display.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SpaceshipDecoration extends Sprite
{
	var lastTime:Float = Lib.getTimer();
	var animation:Animation;
	var config:DecorationConfig;

	public function new(config:DecorationConfig)
	{
		super();
		this.config = config;

		addChild(createNewDecor());
	}

	function createNewDecor():Animation
	{
		animation = switch(config.type)
		{
			case ANIMATION: new Animation(AnimationConfigs.getConfig(config.id));
		}

		graphics.clear();
		graphics.beginFill(0xFFFFFF, 0);
		graphics.drawCircle(animation.width / 2, animation.width / 2, animation.width / 2);
		graphics.endFill();

		return animation;
	}

	public function reset():Void
	{
		// Forked spritesheet to be able set timeElapsed = 0;
		animation.reset();
	}
}