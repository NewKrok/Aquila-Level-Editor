package aquila;

import aquila.AttackLineSmallPreview;
import aquila.ui.UiElements;
import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.UIGrid;
import hpp.openfl.ui.VUIBox;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import aquila.config.AttackLineConfig;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AttackLineSelector extends Sprite
{
	public var target:AttackLineInput;

	var container:VUIBox;
	var closeButton:BaseButton;
	var elementsHolder:UIGrid;
	var previews:Array<AttackLineSmallPreview>;

	public function new()
	{
		super();

		visible = false;
		addChild(container = new VUIBox(20));
		container.addChild(elementsHolder = new UIGrid(10, 20, new Point(113, 64)));

		container.addChild(closeButton = new BaseButton(
			function(_) { visible = false; },
			'CLOSE',
			UiElements.getSimpleButtonBackground(),
			UiElements.getSimpleButtonOverBackground()
		));
		closeButton.fontSize = 12;

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		graphics.beginFill(0, .8);
		graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		graphics.endFill();
	}

	public function build(attackLines:Array<AttackLine>):Void
	{
		clear();

		for (attackLine in attackLines)
		{
			var preview:AttackLineSmallPreview = new AttackLineSmallPreview(attackLine);
			preview.addEventListener(MouseEvent.CLICK, function(_) { visible = false; target.setValue(attackLine.id); });
			elementsHolder.addChild(preview);
			previews.push(preview);
		}

		container.rePosition();

		elementsHolder.x = 20;
		elementsHolder.y = 20;
		closeButton.x += 20;
		closeButton.y += 40;

		container.graphics.beginFill(0, .8);
		container.graphics.drawRect(0, 0, container.width + 40, container.height - closeButton.height);
		container.graphics.endFill();

		for (preview in previews)
		{
			preview.drawLine();
		}

		container.x = width / 2 - container.width / 2;
		container.y = height / 2 - container.height / 2;
	}

	function clear()
	{
		container.graphics.clear();

		if (previews != null)
		{
			for (preview in previews)
			{
				elementsHolder.removeChild(preview);
				preview = null;
			}
		}

		previews = [];
	}
}