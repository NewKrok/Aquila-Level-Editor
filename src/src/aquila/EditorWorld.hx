package aquila;

import openfl.display.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class EditorWorld extends Sprite
{
	public function new()
	{
		super();

		graphics.lineStyle(1, 0xFFFFFF);
		graphics.drawRect(0, 0, 1136, 640);
	}
}