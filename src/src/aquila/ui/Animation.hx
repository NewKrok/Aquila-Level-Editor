package aquila.ui;

import aquila.config.AnimationConfig;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import spritesheet.AnimatedSprite;
import spritesheet.Spritesheet;
import spritesheet.data.BehaviorData;
import spritesheet.importers.BitmapImporter;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Animation extends Sprite
{
	var lastTime:Float = Lib.getTimer();
	var animation:AnimatedSprite;
	var config:AnimationConfig;

	public function new(config:AnimationConfig)
	{
		super();
		this.config = config;

		addChild(build());

		addEventListener(Event.ENTER_FRAME, update);
	}

	function build():AnimatedSprite
	{
		var spritesheet:Spritesheet = BitmapImporter.create(Assets.getBitmapData(config.tile), config.cols, config.rows, config.width, config.height);
		spritesheet.addBehavior(new BehaviorData("idle", config.frames, true, config.fps));
		animation = new AnimatedSprite(spritesheet, true);
		animation.showBehavior("idle");

		return animation;
	}

	function update(_):Void
	{
		var delta = Lib.getTimer() - lastTime;
		animation.update(cast delta);
		lastTime = Lib.getTimer();
	}

	public function reset():Void
	{
		// Forked spritesheet to be able set timeElapsed = 0;
		animation.reset();
		lastTime = Lib.getTimer();
	}
}