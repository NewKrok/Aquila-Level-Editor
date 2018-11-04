package aquila;

import com.greensock.TweenMax;
import com.greensock.easing.Power3;
import hpp.openfl.ui.VUIBox;
import openfl.display.DisplayObject;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AnimatedVUIBox extends VUIBox
{
	override function orderByHorizontal():Void
	{
		if (canOrder())
		{
			var nextChildPosition:Float = 0;

			for(i in 0...numChildren)
			{
				var child:DisplayObject = getChildAt(i);
				TweenMax.to(child, .5, { set_x: nextChildPosition, ease: Power3.easeOut });
				nextChildPosition += child.width + gap;
			}
		}
	}

	override function orderByVertical():Void
	{
		if (canOrder())
		{
			var nextChildPosition:Float = 0;

			for(i in 0...numChildren)
			{
				var child:DisplayObject = getChildAt(i);
				TweenMax.to(child, .5, { set_y: nextChildPosition, ease: Power3.easeOut });
				nextChildPosition += child.height + gap;
			}
		}
	}
}