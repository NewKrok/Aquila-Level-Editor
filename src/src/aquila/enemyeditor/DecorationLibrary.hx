package aquila.enemyeditor;

import aquila.config.DecorationConfigs;
import hpp.openfl.ui.VUIBox;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import spritesheet.AnimatedSprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class DecorationLibrary extends Sprite
{
	var decors:Array<SpaceshipDecoration> = [];

	public function new(addDecoration:DecorationConfig->Void)
	{
		super();

		var container:VUIBox = new VUIBox(10);

		var config = DecorationConfigs.config;
		for (entry in config) container.addChild(createDecorEntry(entry, addDecoration));

		addChild(container);

		graphics.beginFill(0x666666);
		graphics.drawRect(0, 0, 50, 100);

		container.x = width / 2 - container.width / 2;
		container.y = height / 2 - container.height / 2;

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	function createDecorEntry(config:DecorationConfig, addDecoration)
	{
		var decor = new SpaceshipDecoration(config);
		decor.buttonMode = true;
		decors.push(decor);
		decor.addEventListener(MouseEvent.CLICK, function(_) { addDecoration(config); });

		return decor;
	}

	function onEnterFrame(e:Event) for (d in decors) d.update();
}