package aquila;

import hpp.util.GeomUtil;
import openfl.display.Sprite;
import aquila.config.AttackLineConfig;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AttackLineSmallPreview extends Sprite
{
	var attackLine:AttackLine;

	public function new(attackLine:AttackLine)
	{
		this.attackLine = attackLine;

		super();

		graphics.beginFill(0x888888);
		graphics.drawRect(0, 0, 113, 64);
		graphics.endFill();

		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		buttonMode = true;
	}

	public function drawLine():Void
	{
		var ratio:Float = 10;

		var content:Sprite = new Sprite();
		content.graphics.lineStyle(2, 0xFFFF00);
		addChild(content);

		var index:UInt = 0;
		for (point in attackLine.line)
		{
			if (index++ == 0)
			{
				content.graphics.moveTo(point.x / ratio, point.y / ratio);
			}
			else if (index == attackLine.line.length)
			{
				content.graphics.lineTo(point.x / ratio, point.y / ratio);

				var angle:Float = GeomUtil.getAngle(point, attackLine.line[index - 2]);
				var arrowAngle:Float = 20 * (Math.PI / 180);

				content.graphics.beginFill(0xFFFF00, .5);
				content.graphics.lineTo(point.x / ratio + 10 * Math.cos(angle + arrowAngle), point.y / ratio + 10 * Math.sin(angle + arrowAngle));
				content.graphics.lineTo(point.x / ratio + 10 * Math.cos(angle - arrowAngle), point.y / ratio + 10 * Math.sin(angle - arrowAngle));
				content.graphics.lineTo(point.x / ratio, point.y / ratio);
			}
			else
			{
				content.graphics.lineTo(point.x / ratio, point.y / ratio);
			}
		}
	}

	private function onMouseOver(e:MouseEvent):Void
	{
		graphics.clear();
		graphics.beginFill(0x555555);
		graphics.drawRect(0, 0, 113, 64);
		graphics.endFill();
	}

	private function onMouseOut(e:MouseEvent):Void
	{
		graphics.clear();
		graphics.beginFill(0x888888);
		graphics.drawRect(0, 0, 113, 64);
		graphics.endFill();
	}
}